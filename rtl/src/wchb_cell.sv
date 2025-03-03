module wchb_cell #(
   /* PARAMETERS */
   parameter INIT = 0 //Init. value: 1 = set; 0 = reset
)(
   /* INTERFACE */
   input  logic rst_n,

   //Async cell signals
   input  logic i_req,
   input  logic i_ack,
   output logic o_req,
   output logic o_ack,

   //Output aclk
   output logic o_aclk
);

   /* Combinational Logic */
   logic ack_n;
   assign ack_n = ~i_ack;

   /* C element instance */
   c_element #(
      .INIT(INIT)
   ) uu_c_element (
      .a(i_req),
      .b(ack_n),
      .rst_n(rst_n),
      .s(o_aclk)
   );

   /* Output assignment */
   assign o_ack = o_aclk;
   assign o_req = o_aclk;

endmodule
