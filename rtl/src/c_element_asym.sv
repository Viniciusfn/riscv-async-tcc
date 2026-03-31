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
   // TODO

   `endif

endmodule
