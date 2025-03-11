module wchb_fork #(
   /* PARAMETERS */
   parameter INIT    = 0
)(
   /* INTERFACE */
   input  logic      rst_n,
   input  logic      i_req,
   output logic      o_ack,
   output logic      o_req_0,
   input  logic      i_ack_0,
   output logic      o_req_1,
   input  logic      i_ack_1
);

   /* Assignments */
   assign o_req_0 = i_req;
   assign o_req_1 = i_req;

   /* Muller Gate */
   c_element #(
      .INIT    (INIT)
   ) uu_c_element_fork (
      .a       (i_ack_0),
      .b       (i_ack_1),
      .rst_n   (rst_n),
      .s       (o_ack)
   );

endmodule
