module ariscv_dtpath #(
   /* PARAMETERS */
   parameter ACLK_NBW      = 6,
   parameter NBW_INST      = 32,
   parameter NBW_REGISTER  = 32,
   parameter NBW_ADDR      = 32,
   parameter NBW_PC        = 32
)(
   /* INTERFACE */
   input  logic [ACLK_NBW-1:0]   i_aclk,
   input  logic                  rst_async_n,

   // INSTR MEM
   input  logic [NBW_INST-1:0]   i_inst,
   output logic [NBW_PC-1:0]     o_pc,

   // DATA MEM
   output logic                  o_mem_clk,
   output logic [NBW_DATA-1:0]   o_writeData,
   output logic [NBW_ADDR-1:0]   o_writeAddr,
   output logic                  o_memWrite,
   output logic [NBW_DATA-1:0]   i_readData
);
   /* Local signals and parameters */
   // EXECUTE-FETCH
   logic                      pc_src;
   logic [NBW_PC-1:0]         pc_target;
   // FETCH-DECODE
   logic [NBW_PC-1:0]         pc_fd;
   logic [NBW_PC-1:0]         pc_plus4_fd;
   logic [NBW_INST-1:0]       inst;
   // DECODE-EXEC
   logic [NBW_REGISTER-1:0]   rd1;
   logic [NBW_REGISTER-1:0]   rd2;
   logic [NBW_REGISTER-1:0]   immExt;
   logic [NBW_ADDR-1:0]       wr_addr_reg_de;
   logic [NBW_PC-1:0]         pc_de;
   logic [NBW_PC-1:0]         pc_plus4_de;
   logic                      regWrite_de;
   logic [1:0]                resultSrc_de;
   logic                      memWrite_de;
   logic                      jump;
   logic                      branch;
   logic [2:0]                aluControl;
   logic                      aluSrc;
   // WRITEBACK-DECODE
   logic [NBW_REGISTER-1:0]  wr_dt_reg;
   logic [NBW_ADDR-1:0]      wr_addr_reg_wd;
   logic                     wr_en_reg;
   // EXECUTE-MEMORY
   logic [NBW_REGISTER-1:0]  aluResult_em;
   logic [NBW_REGISTER-1:0]  writeData;
   logic [NBW_ADDR-1:0]      wr_addr_reg_em;
   logic [NBW_PC-1:0]        pc_plus4_em;
   logic                     regWrite_em;
   logic [1:0]               resultSrc_em;
   logic                     memWrite_em;
   // MEMORY-WRITEBACK
   logic [NBW_REGISTER-1:0]  aluResult_mw;
   logic [NBW_REGISTER-1:0]  readData;
   logic [NBW_ADDR-1:0]      wr_addr_reg_mw;
   logic [NBW_PC-1:0]        pc_plus4_mw;
   logic                     regWrite_mw;
   logic [1:0]               resultSrc_mw;
   /**/

   /* Instances */
   ariscv_fetch #(
      .NBW_INST         (NBW_INST),
      .NBW_PC           (NBW_PC)
   ) uu_fetch (
      .rst_async_n      (rst_async_n),
      .pc_aclk          (i_aclk[0]),
      .fd_aclk          (i_aclk[1]),
      // FROM EXECUTE
      .i_pc_src         (pc_src),
      .i_pc_target      (pc_target),
      // TO DECODE
      .o_pc_fd          (pc_fd),
      .o_pc_plus4       (pc_plus4_fd),
      .o_inst           (inst),
      // INSTR MEM
      .i_inst           (i_inst),
      .o_pc_mem         (o_pc)
   );

   ariscv_dec #(
      .NBW_INST      (NBW_INST),
      .NBW_PC        (NBW_PC),
      .NBW_REGISTER  (NBW_REGISTER),
      .NBW_ADDR      (NBW_ADDR)
   ) uu_dec (
      .de_aclk          (i_aclk[2]),
      .reg_aclk         (i_aclk[5]),
      .rst_async_n      (rst_async_n),
      // FROM FETCH
      .i_inst           (inst),
      .i_pc             (pc_fd),
      .i_pc_plus4       (pc_plus4_fd),
      // FROM WRITEBACK
      .i_wr_dt_reg      (wr_dt_reg),
      .i_wr_addr_reg    (wr_addr_reg_wd),
      .i_wr_en_reg      (wr_en_reg),
      // TO EXECUTE
      .o_rd1            (rd1),
      .o_rd2            (rd2),
      .o_immExt         (immExt),
      .o_wr_addr_reg    (wr_addr_reg_de),
      .o_pc             (pc_de),
      .o_pc_plus4       (pc_plus4_de),
      .o_regWrite       (regWrite_de),
      .o_resultSrc      (resultSrc_de),
      .o_memWrite       (memWrite_de),
      .o_jump           (jump),
      .o_branch         (branch),
      .o_aluControl     (aluControl),
      .o_aluSrc         (aluSrc)
   );

   ariscv_exec #(
      .NBW_PC        (NBW_PC),
      .NBW_REGISTER  (NBW_REGISTER),
      .NBW_ADDR      (NBW_ADDR)
   ) uu_exec (
      .em_aclk       (i_aclk[3]),
      .rst_async_n   (rst_async_n),
      // FROM DECODE
      .i_rd1         (rd1),
      .i_rd2         (rd2),
      .i_immExt      (immExt),
      .i_wr_addr_reg (wr_addr_reg_de),
      .i_pc          (pc_de),
      .i_pc_plus4    (pc_plus4_de),
      .i_regWrite    (regWrite_de),
      .i_resultSrc   (resultSrc_de),
      .i_memWrite    (memWrite_de),
      .i_jump        (jump),
      .i_branch      (branch),
      .i_aluControl  (aluControl),
      .i_aluSrc      (aluSrc),
      // TO MEMORY
      .o_aluResult   (aluResult_em),
      .o_writeData   (writeData),
      .o_wr_addr_reg (wr_addr_reg_em),
      .o_pc_plus4    (pc_plus4_em),
      .o_regWrite    (regWrite_em),
      .o_resultSrc   (resultSrc_em),
      .o_memWrite    (memWrite_em),
      // TO PC
      .o_pcTarget    (pc_target),
      .o_PCSrc       (pc_src)
   );

   ariscv_mem #(
      .NBW_REGISTER  (NBW_REGISTER),
      .NBW_ADDR      (NBW_ADDR),
      .NBW_PC        (NBW_PC)
   ) uu_mem (
      .aclk          (i_aclk[4]),
      .rst_async_n   (rst_async_n),
      // FROM EXEC
      .i_aluResult   (aluResult_em),
      .i_writeData   (writeData),
      .i_wr_addr_reg (wr_addr_reg_em),
      .i_pc_plus4    (pc_plus4_em),
      .i_regWrite    (regWrite_em),
      .i_resultSrc   (resultSrc_em),
      .i_memWrite    (memWrite_em),
      // TO WB
      .o_aluResult   (aluResult_mw),
      .o_readData    (readData),
      .o_wr_addr_reg (wr_addr_reg_mw),
      .o_pc_plus4    (pc_plus4_mw),
      .o_regWrite    (regWrite_mw),
      .o_resultSrc   (resultSrc_mw),
      // DATA MEMORY
      .o_writeData   (o_writeData),
      .o_writeAddr   (o_writeAddr),
      .o_memWrite    (o_memWrite),
      .i_readData    (i_readData)
   );

   ariscv_wb #(
      .NBW_REGISTER  (NBW_REGISTER),
      .NBW_PC        (NBW_PC),
      .NBW_ADDR      (NBW_ADDR)
   ) uu_wb (
      // FROM MEM
      .i_readData    (aluResult_mw),
      .i_aluResult   (readData),
      .i_pc_plus4    (wr_addr_reg_mw),
      .o_wr_addr_reg (pc_plus4_mw),
      .i_regWrite    (regWrite_mw),
      .i_resultSrc   (resultSrc_mw),
      // TO DECODE
      .o_result      (wr_dt_reg),
      .o_wr_addr_reg (wr_addr_reg_wd),
      .o_regWrite    (wr_en_reg)
   );

endmodule
