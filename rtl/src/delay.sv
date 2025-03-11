module delay #(
   /* PARAMETERS */
   parameter DELAY   = 1
)(
   /* INTERFACE */
   input  logic   i_data,
   output logic   o_data
);

   timeunit 1ns;
   timeprecision 100ps;

   always @(i_data) begin
      o_data <= #(DELAY) i_data;
   end

endmodule
