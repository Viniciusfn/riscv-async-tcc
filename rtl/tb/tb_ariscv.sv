`timescale 1ns / 1ns
//`define COREMARK_TEST

import ariscv_params_pkg::*;

module tb_ariscv;

   /* PARAMETERS */
   localparam BASIC_TEST_FILE_NAME = "../mem/inst_mem";
   localparam COREMARK_FILE_NAME = "../mem/coremark_bmrk_iram.bin";
   localparam INST_MEM_SIZE = 256;
   localparam DT_MEM_SIZE = 256;
   localparam VERBOSE = 0; 

   /* INTERFACE */
   logic                                 rst_async_n;

   // INSTR MEM
   logic [ARISCV_PARAMS.NBW_INST-1:0]    inst;
   logic [ARISCV_PARAMS.NBW_PC-1:0]      pc;

   // DATA MEM
   logic                                  mem_clk;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] writeData;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] writeAddr;
   logic                                  memWrite;
   logic [2:0]                            writeWidth;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] readData;

   /* DUT */
   ariscv #(
      .ARISCV_PARAMS (ARISCV_PARAMS)
   ) dut (
      .rst_async_n   (rst_async_n),
      .i_inst        (inst),
      .o_pc          (pc),
      .o_mem_clk     (mem_clk),
      .o_writeData   (writeData),
      .o_writeAddr   (writeAddr),
      .o_memWrite    (memWrite),
      .o_writeWidth  (writeWidth),
      .i_readData    (readData)
   );

   /* MEMORIES */
   inst_mem_model #(
      `ifdef COREMARK_TEST
      .FILE_NAME  (COREMARK_FILE_NAME),
      .FILE_TYPE  ("bin"),
      `else
      .FILE_NAME  (BASIC_TEST_FILE_NAME),
      .FILE_TYPE  ("txt"),
      `endif
      .MEM_SIZE   (INST_MEM_SIZE),
      .NBW_INST   (ARISCV_PARAMS.NBW_INST),
      .NBW_PC     (ARISCV_PARAMS.NBW_PC),
      .VERBOSE    (VERBOSE)
   ) uu_inst_mem (
      .i_pc       (pc),
      .o_inst     (inst)
   );

   dt_mem_model #(
      .MEM_SIZE      (DT_MEM_SIZE),
      .NBW_DATA      (ARISCV_PARAMS.NBW_REGISTER),
      .NBW_ADDR      (ARISCV_PARAMS.NBW_REGISTER)
   ) uu_dt_mem (
      .aclk          (mem_clk),
      .i_writeData   (writeData),
      .i_writeAddr   (writeAddr),
      .i_memWrite    (memWrite),
      .i_writeWidth  (writeWidth),
      .o_readData    (readData)
   );

   /* Testbench local parameters and signals */
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] aux;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] tb_reg_dt [(2**ARISCV_PARAMS.NBW_ADDR)-1:0];
   logic reg_clk;

   assign tb_reg_dt = dut.uu_dtpath.uu_dec.uu_reg_file.reg_dt;
   assign reg_clk = dut.uu_dtpath.uu_dec.uu_reg_file.clk;

   /* TASKS */
   task test_basic(inout integer err_count);

      $display("~ test_basic test start.");
      @(negedge reg_clk);

      /* Initial tests */
      // ADDI
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 'hA5A) else err_count+=1;
      @(negedge reg_clk);
      assert(tb_reg_dt[1] == 'hA + tb_reg_dt[4]);

      // ADD
      @(negedge reg_clk);
      assert(tb_reg_dt[2] == tb_reg_dt[1] + tb_reg_dt[4]);
      @(negedge reg_clk);
      assert(tb_reg_dt[3] == tb_reg_dt[2]);

      /* Save tests*/
      // SW
      @(negedge uu_dt_mem.aclk);
      aux = tb_reg_dt[1] + 'h23;
      assert(uu_dt_mem.mem[aux[$clog2(DT_MEM_SIZE)+1:2]] == tb_reg_dt[3]);

      // SH
      @(negedge uu_dt_mem.aclk);
      aux = tb_reg_dt[2] + 'h2;
      assert(uu_dt_mem.mem[aux[$clog2(DT_MEM_SIZE)+1:2]][16*(aux[1]+1)-1 -: 16] == tb_reg_dt[3][15:0]);

      // SB
      @(negedge uu_dt_mem.aclk);
      aux = tb_reg_dt[4] + 'h3;
      assert(uu_dt_mem.mem[aux[$clog2(DT_MEM_SIZE)+1:2]][8*(aux[1:0]+1)-1 -: 8] == tb_reg_dt[3][7:0]);

      /* Load tests */      
      //LB
      @(negedge uu_dt_mem.aclk);
      @(negedge reg_clk);
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

      @(negedge reg_clk); // for setup

      //SUB
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == tb_reg_dt[1] - tb_reg_dt[2]);

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
      assert(tb_reg_dt[4] == tb_reg_dt[1] ^ tb_reg_dt[2]);

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
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 1);

      //JALR
      @(negedge reg_clk);
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
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 4);

      //BLT
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 5);
      @(negedge reg_clk);

      //BGE
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 6);

      //BLTU
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 7);

      //BGEU
      @(negedge reg_clk);
      @(negedge reg_clk);
      assert(tb_reg_dt[4] == 8);
      @(negedge reg_clk);

      #10
      $display("~ test_basic test complete!");
   endtask

   task test_coremark(inout integer err_count);
      $display("~ test_coremark test start.");
      #1000ns;
      $display("~ test_coremark test complete!");
   endtask

   /* TEST SEQUENCE */
   initial begin
      static integer err_count = 0;
      $dumpfile("wave_trace.vcd");
      $dumpvars(0, tb_ariscv);

      /* INITIALIZING */
      rst_async_n = 1'b1;

      /* RESET */
      #10 rst_async_n = 0;
      #10 rst_async_n = 1;

      $display("==> Testbench start...\n");

      `ifdef COREMARK_TEST
      test_coremark(err_count);
      `else
      test_basic(err_count);
      `endif
      $display("\n");

      //if(err_count > 0) begin
      //   $display("\n=== FAIL! %d assertions were violated. ===\n", err_count);
      //end
      //else begin
      //   $display("\n=== PASS! All assertions passed. ===\n");
      //end

      $finish;
   end
endmodule
