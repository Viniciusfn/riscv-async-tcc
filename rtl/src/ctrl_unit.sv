module ctrl_unit #(
   /* PARAMETERS */
)(
   /* INTERFACE */
   input  logic [6:0]   i_op,
   input  logic [2:0]   i_funct3,
   input  logic         i_funct7,
   output logic         o_regWrite,
   output logic [1:0]   o_resultSrc,
   output logic         o_memWrite,
   output logic         o_jump,
   output logic         o_branch,
   output logic [2:0]   o_aluControl,
   output logic         o_aluSrc,
   output logic [1:0]   o_immSrc
);

   /* Local signals and parameters */
   logic [1:0] ALUOp_w;

   /* Assignments */
   always_comb begin : Main_Decoder
      case(i_op)
         7'b0000011: begin // lw
            o_regWrite = 1'b1;
            o_immSrc = 2'b00;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b01;
            o_branch = 1'b0;
            ALUOp_w = 2'b00;
            o_jump = 1'b0;
         end
         7'b0100011: begin // sw
            o_regWrite = 1'b0;
            o_immSrc = 2'b01;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b1;
            o_resultSrc = 2'b00; //xx
            o_branch = 1'b0;
            ALUOp_w = 2'b00;
            o_jump = 1'b0;
         end
         7'b0110011: begin // R-type
            o_regWrite = 1'b1;
            o_immSrc = 2'b00; //xx
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b10;
            o_jump = 1'b0;
         end
         7'b1100011: begin // beq
            o_regWrite = 1'b0;
            o_immSrc = 2'b10;
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00; //xx
            o_branch = 1'b1;
            ALUOp_w = 2'b01;
            o_jump = 1'b0;
         end
         7'b0010011: begin // I-type ALU
            o_regWrite = 1'b1;
            o_immSrc = 2'b00;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b10;
            o_jump = 1'b0;
         end
         7'b1101111: begin // jal
            o_regWrite = 1'b1;
            o_immSrc = 2'b11;
            o_aluSrc = 1'b0; //x
            o_memWrite = 1'b0;
            o_resultSrc = 2'b10;
            o_branch = 1'b0;
            ALUOp_w = 2'b00; //xx
            o_jump = 1'b1;
         end
         default: begin
            o_regWrite = 1'bx;
            o_immSrc = 2'bxx;
            o_aluSrc = 1'bx;
            o_memWrite = 1'bx;
            o_resultSrc = 2'bxx;
            o_branch = 1'bx;
            ALUOp_w = 2'bxx;
            o_jump = 1'bx;
         end
      endcase
   end

   always_comb begin : ALU_Decoder
      case(ALUOp_w)
         2'b00: o_aluControl = 3'b000; // lw,sw
         2'b01: o_aluControl = 3'b001; // beq
         2'b10: begin
            case(i_funct3)
               3'b000: begin
                  if ({i_op[5],i_funct7} == 2'b11) begin 
                     o_aluControl = 3'b001; // sub
                  end
                  else begin
                     o_aluControl = 3'b000; // add
                  end
               end
               3'b010: o_aluControl = 3'b101; // slt
               3'b110: o_aluControl = 3'b011; // or
               3'b111: o_aluControl = 3'b010; // and
               default: o_aluControl = 3'bxxx;
            endcase
         end
         default: o_aluControl = 3'bxxx;
      endcase
   end

endmodule
