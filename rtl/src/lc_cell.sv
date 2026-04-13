module lc_cell #(
   /* PARAMETERS */
   parameter bit INIT = 0 //Init. value: 1 = set; 0 = reset
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

   localparam C_ELEM_INIT = (INIT) ?0 :1;

   /* Combinational Logic */
   logic c1_out_w, c2_out_w;

   /* C element instance */
   c_element_asym #(
      .INIT(C_ELEM_INIT)
   ) uu_c_element_1 (
      .a(i_ack),
      .b(~i_req),
      .rst_n(rst_n),
      .s(c1_out_w)
   );

   c_element_asym #(
      .INIT(C_ELEM_INIT)
   ) uu_c_element_2 (
      .a(c1_out_w),
      .b(i_req),
      .rst_n(rst_n),
      .s(c2_out_w)
   );

   /* Output assignment */
   //AND gate
   assign o_ack = (~c1_out_w) & c2_out_w;

   //Request output
   assign o_req = ~c2_out_w;

endmodule
