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
   output logic [3:0]   o_aluControl,
   output logic         o_aluSrc,
   output logic [2:0]   o_immSrc,

   output logic         o_err_flag
);

   /* Local signals and parameters */
   logic [1:0] ALUOp_w;
   logic [1:0] err_flag_w;

   /* Assignments */
   assign o_err_flag = |err_flag_w;

   always_comb begin : Main_Decoder
      err_flag_w[0] = 1'b0;
      case(i_op)
         7'b0000011: begin // lw
            o_regWrite = 1'b1;
            o_immSrc = 3'b000;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b01;
            o_branch = 1'b0;
            ALUOp_w = 2'b00;
            o_jump = 1'b0;
         end
         7'b0100011: begin // sw
            o_regWrite = 1'b0;
            o_immSrc = 3'b001;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b1;
            o_resultSrc = 2'b00; //xx
            o_branch = 1'b0;
            ALUOp_w = 2'b00;
            o_jump = 1'b0;
         end
         7'b0110011: begin // R-type
            o_regWrite = 1'b1;
            o_immSrc = 3'b000; //xx
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b10;
            o_jump = 1'b0;
         end
         7'b1100011: begin // B-type
            o_regWrite = 1'b0;
            o_immSrc = 3'b010;
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00; //xx
            o_branch = 1'b1;
            ALUOp_w = 2'b01;
            o_jump = 1'b0;
         end
         7'b0010011: begin // I-type ALU
            o_regWrite = 1'b1;
            o_immSrc = 3'b000;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b10;
            o_jump = 1'b0;
         end
         7'b1101111: begin // jal
            o_regWrite = 1'b1;
            o_immSrc = 3'b011;
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b10;
            o_branch = 1'b0;
            ALUOp_w = 2'b11; //xx
            o_jump = 1'b1;
         end
         7'b1100111: begin // jalr
            o_regWrite = 1'b1;
            o_immSrc = 3'b000;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b10;
            o_branch = 1'b0;
            ALUOp_w = 2'b11; //xx
            o_jump = 1'b1;
         end
         7'b0110111: begin // lui
            o_regWrite = 1'b1;
            o_immSrc = 3'b100;
            o_aluSrc = 1'b1;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b11;
            o_jump = 1'b0;
         end
         7'b0010111: begin // auipc
            o_regWrite = 1'b1;
            o_immSrc = 3'b100;
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b11;
            o_branch = 1'b0;
            ALUOp_w = 2'b11;
            o_jump = 1'b0;
         end
         default: begin
            o_regWrite = 1'b0;
            o_immSrc = 3'b000;
            o_aluSrc = 1'b0;
            o_memWrite = 1'b0;
            o_resultSrc = 2'b00;
            o_branch = 1'b0;
            ALUOp_w = 2'b11;
            o_jump = 1'b0;
            err_flag_w[0] = 1'b1;
         end
      endcase
   end

   always_comb begin : ALU_Decoder
      err_flag_w[1] = 1'b0;
      case(ALUOp_w)
         2'b00: o_aluControl = 4'b0000; // lw,sw
         2'b01: begin // branch
            case(i_funct3)
               3'b000:  o_aluControl = 4'b0001; // beq
               3'b001:  o_aluControl = 4'b0001; // bne
               3'b100:  o_aluControl = 4'b0101; // blt
               3'b101:  o_aluControl = 4'b0101; // bge
               3'b110:  o_aluControl = 4'b0100; // bltu
               3'b111:  o_aluControl = 4'b0100; // bgeu
               default: begin
                  o_aluControl = 4'b0001;
                  err_flag_w[1] = 1'b1;
               end
            endcase
         end
         2'b10: begin
            case(i_funct3)
               3'b000: begin
                  if ({i_op[5],i_funct7} == 2'b11) begin 
                     o_aluControl = 4'b0001; // sub
                  end
                  else begin
                     o_aluControl = 4'b0000; // add
                  end
               end
               3'b001: o_aluControl = 4'b1000; // sll
               3'b101: begin
                  case(i_funct7)
                     1'b0: o_aluControl = 4'b1001; //srl
                     1'b1: o_aluControl = 4'b1011; //sra
                  endcase
               end
               3'b010: o_aluControl = 4'b0101; // slt
               3'b011: o_aluControl = 4'b0100; // sltu
               3'b100: o_aluControl = 4'b0111; // xor
               3'b110: o_aluControl = 4'b0011; // or
               3'b111: o_aluControl = 4'b0010; // and
               default: begin
                  o_aluControl = 4'b0000;
                  err_flag_w[1] = 1'b1;
               end
            endcase
         end
         default: o_aluControl = 4'b1111; // lui
      endcase
   end

endmodule
