module c_element_asym #(
   parameter bit INIT = 0 //Init. value: 1 = set; 0 = reset
)(
   input  logic a, // strong input
   input  logic b, // weak input
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
            2'b00:        s = 1'b0;
            2'b10, 2'b11: s = 1'b1;
            default:      s = s;
         endcase
      end
   end

   `else
   wire n1,n2,n3,i1;
  
   ORD2X6 OR2_1(
      .A(a),
      .B(b),
      .Y(n1)
   );

   ORD2X6 OR2_2(
      .A(a),
      .B(s),
      .Y(n2)
   );

   AND2X6 AND2_1(
      .A(n1),
      .B(n2),
      .Y(n3)
   );

   generate if (INIT == 1) begin
      
      INVX8 INV_1(
         .A(rst_n),
         .Y(i1)
      );

      OR2X8 OR2_3(
         .A(n3),
         .B(i1),
         .Y(s)
      );
   
   end else begin

      AND2X8 AND2_2(
         .A(n3),
         .B(rst_n),
         .Y(s)
      );
   
   end endgenerate

   `endif

endmodule
