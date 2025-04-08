module ariscv_exec #(
   /* PARAMETERS */
   parameter NBW_PC                 = 32,
   parameter NBW_REGISTER           = 32,
   parameter NBW_ADDR               = 5
)(
   /* INTERFACE */
   input  logic                     em_aclk,
   input  logic                     rst_async_n,
   // FROM DECODE
   input  logic [NBW_REGISTER-1:0]  i_rd1,
   input  logic [NBW_REGISTER-1:0]  i_rd2,
   input  logic [NBW_REGISTER-1:0]  i_immExt,
   input  logic [NBW_ADDR-1:0]      i_wr_addr_reg,
   input  logic [NBW_PC-1:0]        i_pc_de,
   input  logic [NBW_PC-1:0]        i_pc_plus4_de,
   input  logic                     i_regWrite,
   input  logic [1:0]               i_resultSrc,
   input  logic                     i_memWrite,
   input  logic                     i_jump,
   input  logic                     i_branch,
   input  logic [2:0]               i_aluControl,
   input  logic                     i_aluSrc,
   // TO MEMORY
   output logic [NBW_REGISTER-1:0]  o_aluResult,
   output logic [NBW_REGISTER-1:0]  o_writeData,
   output logic [NBW_ADDR-1:0]      o_wr_addr_reg,
   output logic [NBW_PC-1:0]        o_pc_plus4_em,
   output logic                     o_regWrite,
   output logic [1:0]               o_resultSrc,
   output logic                     o_memWrite,
   // TO PC
   output logic [NBW_PC-1:0]        o_pcTarget,
   output logic                     o_PCSrc
);
   /* Local signals and parameters */
   logic [NBW_REGISTER-1:0]         alu_srcB_w;
   logic                            zero_w;
   logic  [NBW_REGISTER-1:0]        aluResult_w, aluResult_ff;
   logic  [NBW_REGISTER-1:0]        writeData_w, writeData_ff;
   logic  [NBW_ADDR-1:0]            wr_addr_reg_w, wr_addr_reg_ff;
   logic  [NBW_PC-1:0]              pc_plus4_em_w, pc_plus4_em_ff;

   /* Output Assignments */
   assign o_aluResult = aluResult_ff;
   assign o_writeData = writeData_ff;
   assign o_wr_addr_reg = wr_addr_reg_ff;
   assign o_pc_plus4_em = pc_plus4_em_ff;
   assign o_regWrite  = i_regWrite;
   assign o_resultSrc = i_resultSrc;
   assign o_memWrite  = i_memWrite;

   /* Assignments */
   assign alu_srcB_w = (i_aluSrc) ? i_immExt : i_rd2;
   assign o_pcTarget = i_immExt + i_pc_de;
   assign o_PCSrc = i_jump || (i_branch && zero_w);
   assign writeData_w = i_rd2;
   assign wr_addr_reg_w = i_wr_addr_reg;
   assign pc_plus4_em_w = i_pc_plus4_de;

   /* FF */
   always_ff @(posedge em_aclk or negedge rst_async_n) begin : em_reg
      if(!rst_async_n) begin
         aluResult_ff <= '0;
         writeData_ff <= '0;
         wr_addr_reg_ff <= '0;
         pc_plus4_em_ff <= '0;
      end
      else begin
         aluResult_ff <= aluResult_w;
         writeData_ff <= writeData_w;
         wr_addr_reg_ff <= wr_addr_reg_w;
         pc_plus4_em_ff <= pc_plus4_em_w;
      end
   end

   /* Instances */
   alu #(
      .NBW_DATA      (NBW_REGISTER)
   ) uu_alu (
      .i_srcA        (i_rd1),
      .i_srcB        (alu_srcB_w),
      .i_aluControl  (i_aluControl),
      .o_result      (aluResult_w),
      .o_zero        (zero_w)
   );

endmodule
