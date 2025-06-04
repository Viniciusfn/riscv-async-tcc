module alu #(
   /* PARAMETERS */
   NBW_DATA       = 32
)(
   /* INTERFACE */
   input  logic [NBW_DATA-1:0]   i_srcA,
   input  logic [NBW_DATA-1:0]   i_srcB,
   input  logic [3:0]            i_aluControl,
   output logic [NBW_DATA-1:0]   o_result,
   output logic                  o_zero
);

   always_comb begin
      case (i_aluControl)
         4'b0000: o_result = i_srcA + i_srcB; // ADD
         4'b0001: o_result = i_srcA - i_srcB; // SUB
         4'b0010: o_result = i_srcA & i_srcB; // AND
         4'b0011: o_result = i_srcA | i_srcB; // OR
         4'b0111: o_result = i_srcA ^ i_srcB; // XOR
         4'b0101: o_result = (($signed(i_srcA)) < ($signed(i_srcB))) ? 32'b1 : 32'b0; // SLT
         4'b0100: o_result = (i_srcA < i_srcB) ? 32'b1 : 32'b0; // SLTU
         4'b1000: o_result = (i_srcA << i_srcB[4:0]); //SLL
         4'b1001: o_result = (i_srcA >> i_srcB[4:0]); //SRL
         4'b1011: o_result = ($signed(i_srcA) >>> i_srcB[4:0]); //SRA
         default: o_result = '0;
      endcase
   end

   assign o_zero = (o_result == '0) ? 1'b1 : 1'b0;

endmodule
