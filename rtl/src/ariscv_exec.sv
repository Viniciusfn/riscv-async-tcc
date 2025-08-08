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
   input  logic [NBW_PC-1:0]        i_pc,
   input  logic [NBW_PC-1:0]        i_pc_plus4,
   input  logic                     i_regWrite,
   input  logic [1:0]               i_resultSrc,
   input  logic                     i_memWrite,
   input  logic                     i_jump,
   input  logic                     i_branch,
   input  logic [3:0]               i_aluControl,
   input  logic                     i_aluSrc,
   input  logic [2:0]               i_funct3,
   // TO MEMORY
   output logic [NBW_REGISTER-1:0]  o_aluResult,
   output logic [NBW_REGISTER-1:0]  o_writeData,
   output logic [NBW_ADDR-1:0]      o_wr_addr_reg,
   output logic [NBW_PC-1:0]        o_pc_plus4,
   output logic                     o_regWrite,
   output logic [1:0]               o_resultSrc,
   output logic                     o_memWrite,
   output logic [2:0]               o_funct3,
   output logic [NBW_PC-1:0]        o_pcTarget_ff,
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
   logic  [NBW_PC-1:0]              pc_plus4_w, pc_plus4_ff;

   /* Output Assignments */
   assign o_aluResult = aluResult_ff;
   assign o_writeData = writeData_ff;
   assign o_wr_addr_reg = wr_addr_reg_ff;
   assign o_pc_plus4 = pc_plus4_ff;

   /* Assignments */
   assign alu_srcB_w = (i_aluSrc) ? i_immExt : i_rd2;
   assign o_pcTarget = (i_aluSrc) ? (i_immExt + i_rd1) : (i_immExt + i_pc);
   assign o_PCSrc = i_jump | (i_branch & (zero_w ^ i_funct3[0] ^ i_funct3[2]));
   assign writeData_w = i_rd2;
   assign wr_addr_reg_w = i_wr_addr_reg;
   assign pc_plus4_w = i_pc_plus4;

   /* FF */
   always_ff @(posedge em_aclk or negedge rst_async_n) begin : em_reg
      if(!rst_async_n) begin
         aluResult_ff <= '0;
         writeData_ff <= '0;
         wr_addr_reg_ff <= '0;
         pc_plus4_ff <= '0;
         o_regWrite  <= '0;
         o_resultSrc <= '0;
         o_memWrite  <= '0;
         o_funct3 <= '0;
         o_pcTarget_ff <= '0;
      end
      else begin
         aluResult_ff <= aluResult_w;
         writeData_ff <= writeData_w;
         wr_addr_reg_ff <= wr_addr_reg_w;
         pc_plus4_ff <= pc_plus4_w;
         o_regWrite  <= i_regWrite;
         o_resultSrc <= i_resultSrc;
         o_memWrite  <= i_memWrite;
         o_funct3 <= i_funct3;
         o_pcTarget_ff <= o_pcTarget;
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
