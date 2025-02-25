module c_element #(
   parameter INIT = 0 //Init. value: 1 = set; 0 = reset
)(
   input  logic a,
   input  logic b,
   input  logic rst,
   output logic s
);

   always_comb begin
      if (rst) begin
         o = INIT;
      end
      else begin
         case ({a,b})
            2'b00: o = 1'b0;
            2'b11: o = 1'b1;
            default: o = o;
         endcase
      end
   end

endmodule
