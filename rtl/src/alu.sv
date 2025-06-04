module alu #(
   /* PARAMETERS */
   NBW_DATA       = 32
)(
   /* INTERFACE */
   input  logic [NBW_DATA-1:0]   i_srcA,
   input  logic [NBW_DATA-1:0]   i_srcB,
   input  logic [2:0]            i_aluControl,
   output logic [NBW_DATA-1:0]   o_result,
   output logic                  o_zero
);

   always_comb begin
      case (i_aluControl)
         3'b000: o_result = i_srcA + i_srcB; // ADD
         3'b001: o_result = i_srcA - i_srcB; // SUB
         3'b010: o_result = i_srcA & i_srcB; // AND
         3'b011: o_result = i_srcA | i_srcB; // OR
         3'b111: o_result = i_srcA ^ i_srcB; // XOR
         3'b101: o_result = (($signed(i_srcA)) < ($signed(i_srcB))) ? 32'b1 : 32'b0; // SLT
         3'b100: o_result = (i_srcA < i_srcB) ? 32'b1 : 32'b0; // SLTU
         default: o_result = '0;
      endcase
   end

   assign o_zero = (o_result == '0) ? 1'b1 : 1'b0;

endmodule
