module extend #(
   /* PARAMETERS */
   parameter   NBW_INST       = 32,
   parameter   NBW_REGISTER  = 32
)(
   /* INTERFACE */
   input  logic [NBW_INST-1:0]      i_inst,
   input  logic [1:0]               i_immSrc,
   output logic [NBW_REGISTER-1:0]  o_immExt
);

   always_comb begin
      case(i_immSrc)
         2'b00: o_immExt = {{20{i_inst[31]}}, i_inst[31:20]};
         2'b01: o_immExt = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
         2'b10: o_immExt = {{20{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
         default: o_immExt = {{20{i_inst[31]}}, i_inst[31:20]};
      endcase
   end

endmodule
