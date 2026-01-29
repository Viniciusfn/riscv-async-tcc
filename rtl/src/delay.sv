module delay #(
   /* PARAMETERS */
   parameter DELAY   = 1
)(
   /* INTERFACE */
   input  logic   i_data,
   output logic   o_data
);

   //timeunit 1ns;

   `ifdef SYNTHESIS

   genvar i;
   wire w_delay [DELAY-1:0];
   
   BUFX2 uu_buffer (.Y(w_delay[0]), .A(i_data));
   generate for (i = 1; i < DELAY; i++) begin : buffer_instances
      BUFX2 uu_buffer (.Y(w_delay[i]), .A(w_delay[i-1]));
   end endgenerate

   assign o_data = w_delay[DELAY-1];

   `else
   always @(i_data) begin
      o_data <= #(DELAY) i_data;
   end
   `endif

endmodule
