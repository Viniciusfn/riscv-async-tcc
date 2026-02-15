`timescale 1ns / 1ns
`define PERF_CLK_PERIOD 4
//`define BENCHMARK_TEST

import ariscv_params_pkg::*;

module tb_ariscv_soc_top;

   /* PARAMETERS */
   localparam BASIC_TEST_FILE_NAME = "../mem/inst_mem";
   `ifdef COREMARK
   localparam BENCHMARK_INST_FILE_NAME = "../mem/coremark_bmrk_iram.bin";
   localparam BENCHMARK_DATA_FILE_NAME = "../mem/coremark_bmrk_dram.bin";
   `else // DHRYSTONE
   localparam BENCHMARK_INST_FILE_NAME = "../mem/dhrystone_bmrk_iram.bin";
   localparam BENCHMARK_DATA_FILE_NAME = "../mem/dhrystone_bmrk_dram.bin";
   `endif
   localparam ISA_TEST_FILE_NAME = "../mem/isa_test/rv32i_tests.bin";
   localparam INST_MEM_SIZE = 32768*8/ARISCV_PARAMS.NBW_INST; // 32kBytes
   localparam DT_MEM_SIZE = 8192*8/ARISCV_PARAMS.NBW_REGISTER; // 8kBytes
   localparam VERBOSE = 0;
   localparam TXDATA_REG_ADDR = 32'h00010000;
   localparam PERF_COUNTER_ADDR = 32'h00010004;
   time TIMEOUT_BENCHMARK = 15s;
   // time TIMEOUT_BENCHMARK = 50ms;
   time UPDATE_PROG = 100ms;
   localparam PROGRESSION_VERBOSE = 1;

   /* INTERFACE */
   logic                                 perf_clk;
   logic                                 rst_async_n;

   /* DUT */
   ariscv_soc_top #(
      .ARISCV_PARAMS             (ARISCV_PARAMS),
      .BASIC_TEST_FILE_NAME      (BASIC_TEST_FILE_NAME),
      .BENCHMARK_INST_FILE_NAME  (BENCHMARK_INST_FILE_NAME),
      .BENCHMARK_DATA_FILE_NAME  (BENCHMARK_DATA_FILE_NAME),
      .ISA_TEST_FILE_NAME        (ISA_TEST_FILE_NAME),
      .INST_MEM_SIZE             (INST_MEM_SIZE),
      .DT_MEM_SIZE               (DT_MEM_SIZE),
      .VERBOSE                   (VERBOSE)
   ) dut (
      .clk           (perf_clk),
      .rst_async_n   (rst_async_n)
   );

   /* Testbench local parameters and signals */
   logic [7:0] tx_data_reg; //char
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] aux;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] tb_reg_dt [(2**ARISCV_PARAMS.NBW_ADDR)-1:0];
   logic reg_clk;
   logic inst_error_flag;

   always #(`PERF_CLK_PERIOD/2) perf_clk = ~perf_clk;
   assign tx_data_reg = dut.uu_dt_mem.memory[TXDATA_REG_ADDR][7:0];
   assign tb_reg_dt = dut.uu_core.uu_dtpath.uu_dec.uu_reg_file.reg_dt;
   assign reg_clk = dut.uu_core.uu_dtpath.uu_dec.uu_reg_file.clk;
   assign inst_error_flag = dut.uu_core.uu_dtpath.uu_dec.err_flag_ff;

   /* TASKS */
   task automatic print_progress(time current, time total);
      longint percent;    // 64-bit signed for safe math
      static longint bar_width = 50;
      longint pos;
      string bar;

      // avoid div by zero
      if (total == 0) begin
         $write("\r[ERROR: total=0]");
         return;
      end

      // percentage calc (safe)
      percent = (current * 100) / total;
      if (percent > 100) percent = 100; // clamp

      pos = bar_width * current / total;

      // build progress bar
      bar = "";
      for (longint i = 0; i < bar_width; i++) begin
         if (i < pos) 
            bar = {bar, "="};
         else if (i == pos) 
            bar = {bar, ">"};
         else 
            bar = {bar, " "};
      end

      $write("\r[%s] %0d%% (elapsed time / timeout = %s / %s)", 
               bar, percent, fmt_time(current), fmt_time(total));

      if (percent >= 100) $write("\n");
   endtask

   // helper function: format time into human-readable string
   function string fmt_time(time t);
      real val;
      string unit;

      if (t >= 1s) begin
         val  = t / 1s;
         unit = "s";
      end
      else if (t >= 1ms) begin
         val  = t / 1ms;
         unit = "ms";
      end
      else if (t >= 1us) begin
         val  = t / 1us;
         unit = "us";
      end
      else if (t >= 1ns) begin
         val  = t / 1ns;
         unit = "ns";
      end
      else begin
         val  = t / 1ps;
         unit = "ps";
      end

      return $sformatf("%0.2f%s", val, unit);
   endfunction

   task test_basic();

      $display("~ test_basic test start.");
      @(negedge reg_clk);

      /* Initial tests */
      // ADDI
      `ifdef SYNC_RISCV
      repeat(5) @(negedge reg_clk);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 32'hFFFFFA5A);
      repeat (3) @(negedge reg_clk);
      assert(tb_reg_dt[1] == 32'hA + tb_reg_dt[4]);

      // ADD
      repeat (3) @(negedge reg_clk);
      assert(tb_reg_dt[2] == tb_reg_dt[1] + tb_reg_dt[4]);
      repeat (3) @(negedge reg_clk);
      assert(tb_reg_dt[3] == tb_reg_dt[2]);

      /* Save tests*/
      // SW
      repeat (3) @(negedge dut.uu_dt_mem.aclk);
      aux = tb_reg_dt[1] + 'h23;
      assert(dut.uu_dt_mem.memory[aux[$clog2(DT_MEM_SIZE)+1:2]] == tb_reg_dt[3]);

      // SH
      @(negedge dut.uu_dt_mem.aclk);
      aux = tb_reg_dt[2] + 'h2;
      assert(dut.uu_dt_mem.memory[aux[$clog2(DT_MEM_SIZE)+1:2]][16*aux[1]+15 -: 16] == tb_reg_dt[3][15:0]);

      // SB
      @(negedge dut.uu_dt_mem.aclk);
      aux = tb_reg_dt[4] + 'h3;
      assert(dut.uu_dt_mem.memory[aux[$clog2(DT_MEM_SIZE)+1:2]][8*aux[1:0]+7 -: 8] == tb_reg_dt[3][7:0]);

      /* Load tests */      
      //LB
      `ifndef SYNC_RISCV
      @(negedge dut.uu_dt_mem.aclk);
      @(negedge reg_clk);
      `endif
      assert(tb_reg_dt[5] == {{24{tb_reg_dt[3][7]}},  tb_reg_dt[3][7:0]});

      //LH
      @(negedge reg_clk);
      assert(tb_reg_dt[6] == {{16{tb_reg_dt[3][15]}}, tb_reg_dt[3][15:0]});

      //LW
      @(negedge reg_clk);
      assert(tb_reg_dt[7] == tb_reg_dt[3]);

      //LBU
      @(negedge reg_clk);
      assert(tb_reg_dt[8] == {{24{1'b0}}, tb_reg_dt[3][7:0]});

      //LHU
      @(negedge reg_clk);
      assert(tb_reg_dt[9] == {{16{1'b0}}, tb_reg_dt[3][15:0]});

      // Registers state:
      //x1=0xFFFFFA64 ; x2=x3=0xFFFFF4BE ; x4=0xFFFFFA5A

      /* Operators tests */
      //SLTI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == 'h1);
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == 'h0);
      
      //SLTIU
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == 'h0);
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == 'h1);

      //XORI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == (tb_reg_dt[1] ^ 'hFFFFFAAA));

      //ORI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == (tb_reg_dt[1] | 'hFFFFFAAA));

      //ANDI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == (tb_reg_dt[1] & 'hFFFFFAAA));

      //SLLI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == (tb_reg_dt[4] << 3));

      //SRLI
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == (tb_reg_dt[4] >> 3));

      //SRAI
      @(negedge reg_clk);
      aux = ($signed(tb_reg_dt[4]) >>> 3);
      assert(tb_reg_dt[3] == aux);

      repeat(2) @(negedge reg_clk); // for setup

      //SUB
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == (tb_reg_dt[1] - tb_reg_dt[2]));

      //SLL
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == tb_reg_dt[2] << tb_reg_dt[3][4:0]);

      //SLT
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 'h1);

      //SLTU
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 'h0);

      //XOR
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == (tb_reg_dt[1] ^ tb_reg_dt[2]));

      //SRL
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == tb_reg_dt[2] >> tb_reg_dt[3][4:0]);

      //SRA
      @(negedge reg_clk);
      aux = ($signed(tb_reg_dt[2]) >>> tb_reg_dt[3][4:0]);
      assert(tb_reg_dt[4] == aux);

      //OR
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == (tb_reg_dt[1] | tb_reg_dt[2]));

      //AND
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == (tb_reg_dt[1] & tb_reg_dt[2]));


      /* Jump tests */
      // SETUP
      @(negedge reg_clk);
      @(negedge reg_clk);
      @(negedge reg_clk);
      @(negedge reg_clk);

      // JAL
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 1);

      //JALR
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 2);


      /* Branch tests */
      //BEQ
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 3);
      @(negedge reg_clk);

      //BNE
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 4);

      //BLT
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 5);
      @(negedge reg_clk);

      //BGE
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 6);

      //BLTU
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] != '1);
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 7);

      //BGEU
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 8);
      @(negedge reg_clk);


      /* Others */
      //LUI
      @(negedge reg_clk);
      assert(tb_reg_dt[2] == 32'hA5A5A000);

      //AUIPC
      @(negedge reg_clk);
      assert(tb_reg_dt[2] == 32'h118 + 32'hA5A5A000); // pc + (imm<<12)

      /* Hazards */
      // Data Hazards
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 32'hFFFFFB0B);
      @(negedge reg_clk);
      assert(tb_reg_dt[1] == 32'hFFFFFB0D);
      @(negedge reg_clk);
      assert(tb_reg_dt[2] == 32'hFFFFF618);

      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == tb_reg_dt[2]);
      @(negedge reg_clk);
      `ifdef SYNC_RISCV
      @(negedge reg_clk);
      `endif
      assert(tb_reg_dt[1] == tb_reg_dt[2] + 2);
      @(negedge reg_clk);
      assert(tb_reg_dt[2] == tb_reg_dt[1] + tb_reg_dt[4]);

      // Control Hazards
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == '0);
      repeat(4) @(negedge reg_clk);
      `ifdef SYNC_RISCV
      repeat (5) begin
         @(negedge reg_clk);
         assert(tb_reg_dt[1] != '1);
      end
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[1] == 1);

      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == tb_reg_dt[3]);
      repeat (4) @(negedge reg_clk);
      `ifdef SYNC_RISCV
      repeat (6) begin
         @(negedge reg_clk);
         assert(tb_reg_dt[1] != '1);
      end
      `endif
      @(negedge reg_clk);
      assert(tb_reg_dt[1] == 2);

      #10
      $display("~ test_basic test complete!");
   endtask

   task test_benchmark();
      bit  timeout_flag;
      bit  signal_triggered;
      string text_line;
      string benchmark_text; // Acts like a dynamic char buffer
      int i;

      $display("~ test_benchmark test start.");

      timeout_flag = 0;
      text_line = "";
      benchmark_text = "";

      fork
         // Thread 1: Wait for signal transition
         begin
            while (tb_reg_dt[31] != 32'hFFFF_FFFF) begin
               @(tb_reg_dt[31]);
            end
            $display("[%0t] Reached end of benckmark!", $time);
         end

         // Thread 2: Message Acquisition from ee_printf
         begin
            while(1) begin
               @(posedge (dut.uu_dt_mem.aclk && dut.uu_dt_mem.i_memWrite));
               #1; // to avoid double writting due to no delay simulation
               if(dut.uu_dt_mem.i_writeAddr == TXDATA_REG_ADDR) begin
                  if (dut.uu_dt_mem.i_writeData[7:0] != 8'h00) begin // ignore null bytes
                     benchmark_text = {benchmark_text, byte'(dut.uu_dt_mem.i_writeData[7:0])};
                     text_line = {text_line, byte'(dut.uu_dt_mem.i_writeData[7:0])};
                     if (dut.uu_dt_mem.i_writeData[7:0] == 8'h0A) begin // if end of line, print line (for debug)
                        //$display("%s", text_line); //for debug
                        text_line = "";
                     end
                  end
               end
            end
         end

         // Thread 3: Timeout counter
         begin
            #TIMEOUT_BENCHMARK;
            timeout_flag = 1;
            $display("[%0t] Timeout reached!", $time);
         end

         // Thread 4: Progression bar
         begin
            for (time t = 0; t <= TIMEOUT_BENCHMARK; t += UPDATE_PROG) begin
               if (PROGRESSION_VERBOSE == 1) begin
                  print_progress($time, TIMEOUT_BENCHMARK);
               end
               #(UPDATE_PROG);
            end
         end
      join_any

      $display("\n------------------------ Benchmark Output ------------------------\n%s", benchmark_text);
      $display(  "------------------------------------------------------------------\n");

      if (timeout_flag)
        $display("Test Benchmark FAILED: timeout before end of benchmark.");
      else
        $display("Test Benchmark FINISHED: end of benchmark.");

      // Kill whichever thread is still running
      disable fork;
   endtask

   task test_isa();
      int cycles;
      static int TIMEOUT_CYC = 10000; //cycles
      // Wait until reset deasserts
      @(posedge dut.w_mem_clk);

      cycles = 0;
      // Monitor until done or timeout
      while (cycles < TIMEOUT_CYC) begin
         @(posedge dut.w_mem_clk);
         cycles++;

         if (dut.uu_dt_mem.i_memWrite && (dut.uu_dt_mem.i_writeAddr == TXDATA_REG_ADDR)) begin
            if (dut.uu_dt_mem.i_writeData == 32'h0000_0001) begin
               $display("[TB][PASS] RV32I selftest passed in %0d cycles.", cycles);
            end else begin
               $display("[TB][FAIL] RV32I selftest FAILED. tohost=0x%08x (cycles=%0d)", 
                        dut.uu_dt_mem.i_writeData, cycles);
            end
            break;
         end
      end

      // If timeout
      if (cycles == TIMEOUT_CYC) begin
         $display("[TB][TIMEOUT] No result after %0d cycles.", cycles);
      end
   endtask

   /* TEST SEQUENCE */
   initial begin
      // $dumpfile("wave_trace.vcd");
      // $dumpvars(0, tb_ariscv);

      /* INITIALIZING */
      rst_async_n = 1'b1;

      /* RESET */
      #10 rst_async_n = 0;
      #10 rst_async_n = 1;

      $display("==> Testbench start...\n");

      `ifdef BENCHMARK_TEST
      test_benchmark();
      `elsif ISA_TEST
      test_isa();
      `else
      test_basic();
      `endif
      $display("\n");

      #20

      $finish;
   end
endmodule
