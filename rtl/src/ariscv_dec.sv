module ariscv_dec #(
   /* PARAMETERS */
   parameter NBW_INST      = 32,
   parameter NBW_PC        = 32,
   parameter NBW_REGISTER  = 32,
   parameter NBW_ADDR      = 5
)(
   /* INTERFACE */
   input  logic                     de_aclk,
   input  logic                     reg_aclk,
   input  logic                     rst_async_n,
   // FROM FETCH
   input  logic [NBW_INST-1:0]      i_inst,
   input  logic [NBW_PC-1:0]        i_pc_fd,
   input  logic [NBW_PC-1:0]        i_pc_plus4_fd,
   // FROM WRITEBACK
   input  logic [NBW_REGISTER-1:0]  i_wr_dt_reg,
   input  logic [NBW_ADDR-1:0]      i_wr_addr_reg,
   input  logic                     i_wr_en_reg,
   // TO EXECUTE
   output logic [NBW_REGISTER-1:0]  o_rd1,
   output logic [NBW_REGISTER-1:0]  o_rd2,
   output logic [NBW_REGISTER-1:0]  o_immExt,
   output logic [NBW_ADDR-1:0]      o_wr_addr_reg,
   output logic [NBW_PC-1:0]        o_pc_de,
   output logic [NBW_PC-1:0]        o_pc_plus4_de,
   output logic                     o_regWrite,
   output logic [1:0]               o_resultSrc,
   output logic                     o_memWrite,
   output logic                     o_jump,
   output logic                     o_branch,
   output logic [2:0]               o_aluControl,
   output logic                     o_aluSrc
);

   /* Local signals and parameters */
   logic [NBW_REGISTER-1:0]   immExt_w, immExt_ff;
   logic [NBW_REGISTER-1:0]   rd1_w, rd1_ff;
   logic [NBW_REGISTER-1:0]   rd2_w, rd2_ff;

   logic         regWrite_w;
   logic [1:0]   resultSrc_w;
   logic         memWrite_w;
   logic         jump_w;
   logic         branch_w;
   logic [2:0]   aluControl_w;
   logic         aluSrc_w;
   logic [1:0]   immSrc_w;

   /* Output Assignments */
   assign o_rd1 = rd1_ff;
   assign o_rd2 = rd2_ff;
   assign o_immExt = immExt_ff;

   /* FF */
   always_ff @(posedge de_aclk or negedge rst_async_n) begin
      if (!rst_async_n) begin
         rd1_ff         <= '0;
         rd2_ff         <= '0;
         immExt_ff      <= '0;
         o_wr_addr_reg  <= '0;
         o_pc_de        <= '0;
         o_pc_plus4_de  <= '0;
      end
      else begin
         rd1_ff         <= rd1_w;
         rd2_ff         <= rd2_w;
         o_wr_addr_reg  <= i_inst[11:7];
         o_pc_de        <= i_pc_fd;
         o_pc_plus4_de  <= i_pc_plus4_fd;
         o_regWrite     <= regWrite_w;
         o_resultSrc    <= resultSrc_w;
         o_memWrite     <= memWrite_w;
         o_jump         <= jump_w;
         o_branch       <= branch_w;
         o_aluControl   <= aluControl_w;
         o_aluSrc       <= aluSrc_w;
      end
   end
   

   /* REG_FILE */
   reg_file #(
      .NBW_ADDR      (NBW_ADDR),
      .NBW_DATA      (NBW_REGISTER)
   ) uu_reg_file (
      .clk           (reg_aclk),
      .rst_async_n   (rst_async_n),
      .i_wr_en       (i_wr_en_reg),
      .i_rd_addr_1   (i_inst[19:15]),
      .i_rd_addr_2   (i_inst[24:20]),
      .i_wr_addr_3   (i_wr_dt_addr),
      .i_wr_dt       (i_wr_dt_reg),
      .o_rd_dt_1     (rd1_w),
      .o_rd_dt_2     (rd2_w)
   );

   /* Immediate Extend */
   extend #(
      .NBW_INST      (NBW_INST),
      .NBW_REGISTER  (NBW_REGISTER)
   ) uu_extend (
      .i_inst        (i_inst),
      .i_immSrc      (immSrc_w),
      .o_immExt      (immExt_w)
   );

   /* Control Unit */
   ctrl_unit #(

   ) uu_ctrl_unit (
      .i_op          (i_inst[6:0]),
      .i_funct3      (i_inst[14:12]),
      .i_funct7      (i_inst[30]),
      .o_regWrite    (regWrite_w),
      .o_resultSrc   (resultSrc_w),
      .o_memWrite    (memWrite_w),
      .o_jump        (jump_w),
      .o_branch      (branch_w),
      .o_aluControl  (aluControl_w),
      .o_aluSrc      (aluSrc_w),
      .o_immSrc      (immSrc_w)
   );

endmodule
