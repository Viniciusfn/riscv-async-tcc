`timescale 1ns / 1ns

import ariscv_params_pkg::*;

module tb_ariscv;

   /* PARAMETERS */
   localparam FILE_NAME = "../mem/inst_mem";
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
      .i_readData    (readData)
   );

   /* MEMORIES */
   inst_mem_model #(
      .FILE_NAME  (FILE_NAME),
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
      .o_readData    (readData)
   );

   /* TASKS */
   task test_basic(inout integer err_count);

      $display("~ test_basic test start.");
      @(negedge dut.uu_dtpath.uu_dec.uu_reg_file.clk);

      @(negedge dut.uu_dtpath.uu_dec.uu_reg_file.clk);
      assert(dut.uu_dtpath.uu_dec.uu_reg_file.reg_dt[4] == 'hF);
      @(negedge dut.uu_dtpath.uu_dec.uu_reg_file.clk);
      assert(dut.uu_dtpath.uu_dec.uu_reg_file.reg_dt[1] == 'h19);
      @(negedge dut.uu_dtpath.uu_dec.uu_reg_file.clk);
      assert(dut.uu_dtpath.uu_dec.uu_reg_file.reg_dt[2] == 'h28);
      @(negedge dut.uu_dtpath.uu_dec.uu_reg_file.clk);
      assert(dut.uu_dtpath.uu_dec.uu_reg_file.reg_dt[3] == 'h28);

      #10
      $display("~ test_basic test complete!");

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

      test_basic(err_count);

      if(err_count > 0) begin
         $display("\n=== FAIL! %d assertions were violated. ===\n", err_count);
      end
      else begin
         $display("\n=== PASS! All assertions passed. ===\n");
      end

      $finish;
   end
endmodule
