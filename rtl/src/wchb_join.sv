module wchb_join #(
   /* PARAMETERS */
   parameter INIT    = 0
)(
   /* INTERFACE */
   input  logic      rst_n,
   input  logic      i_req_0,
   output logic      o_ack_0,
   input  logic      i_req_1,
   output logic      o_ack_1,
   output logic      o_req,
   input  logic      i_ack
);

   /* Assignments */
   assign o_ack_0 = i_ack;
   assign o_ack_1 = i_ack;

   /* Muller gate */
   c_element #(
      .INIT (INIT)
   ) uu_c_element_join (
      .rst_n   (rst_n),
      .a       (i_req_0),
      .b       (i_req_1),
      .s       (o_req)
   );

endmodule
