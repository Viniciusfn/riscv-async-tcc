module extend #(
   /* PARAMETERS */
   parameter   NBW_INST       = 32,
   parameter   NBW_REGISTER   = 32
)(
   /* INTERFACE */
   input  logic [NBW_INST-1:0]      i_inst,
   input  logic [2:0]               i_immSrc,
   output logic [NBW_REGISTER-1:0]  o_immExt
);

   always_comb begin
      case(i_immSrc)
         3'b000: o_immExt = {{20{i_inst[31]}}, i_inst[31:20]};
         3'b001: o_immExt = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
         3'b010: o_immExt = {{20{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
         3'b011: o_immExt = {{12{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
         3'b100: o_immExt = {i_inst[31:12], 12'd0};
         default: o_immExt = {{20{i_inst[31]}}, i_inst[31:20]};
      endcase
   end

endmodule
