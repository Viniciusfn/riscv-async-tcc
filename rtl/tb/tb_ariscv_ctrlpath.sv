`timescale 1ns / 1ns
`define CLK_PERIOD 2 //ns

module tb_ariscv_ctrlpath;

   /* PARAMETERS */
   // RB
   parameter ACLK_NBW         = 6;

   /* INTERFACE */
   logic                      clk;
   logic                      rst_async_n;
   logic [ACLK_NBW-1:0]       o_aclk;

   /* DUT */
   ariscv_ctrlpath #(
      .ACLK_NBW               (ACLK_NBW)
   ) dut (
      .rst_async_n            (rst_async_n),
      .o_aclk                 (o_aclk)
   );

   /* TB SIGNALS */
   integer i;

   /* CLOCKS */
   always #`CLK_PERIOD clk = ~clk;

   /* TASKS */
   task test_ariscv_ctrlpath(inout integer err_count);
      integer i;

      $display("~ ariscv_ctrlpath test start.");

      repeat(20)@(negedge clk);

      $display("~ ariscv_ctrlpath test complete!");
   endtask

   /* TEST SEQUENCE */
   initial begin
      static integer err_count = 0;
      $dumpfile("wave_trace.vcd");
      $dumpvars(0, tb_ariscv_ctrlpath);

      /* INITIALIZING */
      clk = 1'b0;
      rst_async_n = 1'b1;

      /* RESET */
      @(negedge clk);
      rst_async_n = 0;
      @(negedge clk);
      rst_async_n = 1;

      $display("==> Testbench start...\n");

      repeat(3) @(negedge clk);

      test_ariscv_ctrlpath(err_count);

      repeat(3) @(negedge clk);

      if(err_count > 0) begin
         $display("\n=== FAIL! %d assertions were violated. ===\n", err_count);
      end
      else begin
         $display("\n=== PASS! All assertions passed. ===\n");
      end

      $finish;
   end
endmodule
