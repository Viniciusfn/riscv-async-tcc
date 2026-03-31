module c_element #(
   parameter bit INIT = 0 //Init. value: 1 = set; 0 = reset
)(
   input  logic a,
   input  logic b,
   input  logic rst_n,
   output logic s
);

   `ifndef SYNTHESIS
   always_comb begin
      if (!rst_n) begin
         s = INIT;
      end
      else begin
         case ({a,b})
            2'b00:   s = 1'b0;
            2'b11:   s = 1'b1;
            default: s = s;
         endcase
      end
   end

   `else
   wire n1,n2,n3,i1,i2;

   NAND2X6 NAND2_1(
      .A(a),
      .B(b),
      .Z(n1)
   );

   NAND2X6 NAND2_2(
      .A(a),
      .B(s),
      .Z(n2)
   );

   NAND2X6 NAND2_3(
      .A(b),
      .B(s),
      .Z(n3)
   );

   NAND3X4 NAND3_1(
      .A(n1),
      .B(n2),
      .C(n3),
      .Z(i1)
   );

   generate if (INIT == 1) begin

      INVX8 INV_1(
         .A(rst_n),
         .Z(i2)
      );

      OR2X8 OR2_1(
         .A(i1),
         .B(i2),
         .Z(s)
      );
   
   end else begin
   
      AND2X8 AND2_1(
         .A(i1),
         .B(rst_n),
         .Z(s)
      );
   
   end endgenerate

   `endif

endmodule
