`timescale 1ns / 1ns
`define CLK_PERIOD 2 //ns

module tb_wchb_cell;

   /* PARAMETERS */
   // RB
   parameter INIT              = 0;

   /* INTERFACE */
   logic                   clk;
   logic                   rst_n;
   logic                   i_req;
   logic                   i_ack;
   logic                   o_req;
   logic                   o_ack;
   logic                   o_aclk;

   /* DUT */
   wchb_cell #(
      .INIT                (INIT)
   ) dut (
      .rst_n               (rst_n),
      .i_req               (i_req),
      .i_ack               (i_ack),
      .o_req               (o_req),
      .o_ack               (o_ack),
      .o_aclk              (o_aclk)
   );

   /* CLOCKS */
   always #`CLK_PERIOD clk = ~clk;

   /* TASKS */
   task test_wchb_prot(inout integer err_count);

      $display("~ WCHB Protocol test start.");

      @(negedge clk);

      // Ack faster than req
      i_req = 1'b1;
      #1 req_rise_0: assert(o_aclk == 1'b1 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_ack = 1'b1;
      #1 ack_rise_0: assert(o_aclk == 1'b1 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_req = 1'b0;
      #1 req_fall_0: assert(o_aclk == 1'b0 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_ack = 1'b0;
      #1 ack_fall_0: assert(o_aclk == 1'b0 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;

      // Req faster than ack
      i_req = 1'b1;
      #1 req_rise_1: assert(o_aclk == 1'b1 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_req = 1'b0;
      #1 req_fall_1: assert(o_aclk == 1'b1 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_ack = 1'b1;
      #1 ack_rise_1: assert(o_aclk == 1'b0 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_req = 1'b1;
      #1 req_rise_2: assert(o_aclk == 1'b0 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;
      #1;
      i_ack = 1'b0;
      #1 ack_fall_1: assert(o_aclk == 1'b1 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;

      @(negedge clk);
      $display("~ WCHB Protocol test complete!");

   endtask

   /* TEST SEQUENCE */
   initial begin
      static integer err_count = 0;

      /* INITIALIZING */
      clk   = 1'b0;
      rst_n = 1'b1;
      i_ack = 1'b0;
      i_req = 1'b0;

      /* RESET */
      @(negedge clk);
      rst_n = 0;
      @(negedge clk);
      rst_n = 1;

      $display("==> Testbench start...\n");

      repeat(3) @(negedge clk);
      reset: assert(o_aclk == 1'b0 && o_req == o_aclk && o_ack == o_aclk) else err_count+=1;

      test_wchb_prot(err_count);

      #10;

      if(err_count > 0) begin
         $display("\n=== FAIL! %d assertions were violated. ===\n", err_count);
      end
      else begin
         $display("\n=== PASS! All assertions passed. ===\n");
      end

      $finish;
   end
endmodule
