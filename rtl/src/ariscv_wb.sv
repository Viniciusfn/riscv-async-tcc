module ariscv_wb #(
   /* PARAMETERS */
   parameter NBW_REGISTER        = 32,
   parameter NBW_PC              = 32,
   parameter NBW_ADDR            = 5
)(
   /* INTERFACE */
   // FROM MEM
   input  logic [NBW_REGISTER-1:0]        i_readData,
   input  logic [NBW_REGISTER-1:0]        i_aluResult,
   input  logic [NBW_PC-1:0]              i_pc_plus4,
   input  logic [NBW_PC-1:0]              i_pcTarget,
   input  logic [NBW_ADDR-1:0]            i_wr_addr_reg,
   input  logic                           i_regWrite,
   input  logic [1:0]                     i_resultSrc,
   // TO DECODE
   output logic [NBW_REGISTER-1:0]        o_result,
   output logic [NBW_ADDR-1:0]            o_wr_addr_reg,
   output logic                           o_regWrite
);

   /* Output Assignments */
   assign o_wr_addr_reg = i_wr_addr_reg;
   assign o_regWrite = i_regWrite;

   /* Mux */
   always_comb begin
      case (i_resultSrc)
         2'b00: o_result = i_aluResult;
         2'b01: o_result = i_readData;
         2'b10: o_result = i_pc_plus4;
         2'b11: o_result = i_pcTarget;
      endcase
   end

endmodule
