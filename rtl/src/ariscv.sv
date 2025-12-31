import ariscv_params_pkg::*;

module ariscv #(
   parameter ariscv_params_t ARISCV_PARAMS = ARISCV_PARAMS
)(
   /* INTERFACE */
   `ifdef SYNC_RISCV
   input logic                                  clk,
   `endif
   input logic                                  rst_async_n,

   // INSTR MEM
   input  logic [ARISCV_PARAMS.NBW_INST-1:0]    i_inst,
   output logic [ARISCV_PARAMS.NBW_PC-1:0]      o_pc,

   // DATA MEM
   output logic                                    o_mem_clk,
   output logic [ARISCV_PARAMS.NBW_REGISTER-1:0]   o_writeData,
   output logic [ARISCV_PARAMS.NBW_REGISTER-1:0]   o_writeAddr,
   output logic                                    o_memWrite,
   output logic [2:0]                              o_writeWidth,
   input  logic [ARISCV_PARAMS.NBW_REGISTER-1:0]   i_readData
);
   /* Local signals and parameters */
   `ifndef SYNC_RISCV
   logic [ARISCV_PARAMS.NBW_ACLK-1:0]   aclk;
   `endif

   /* Instances */
   ariscv_dtpath #(
      .NBW_ACLK      (ARISCV_PARAMS.NBW_ACLK),
      .NBW_INST      (ARISCV_PARAMS.NBW_INST),
      .NBW_REGISTER  (ARISCV_PARAMS.NBW_REGISTER),
      .NBW_ADDR      (ARISCV_PARAMS.NBW_ADDR),
      .NBW_PC        (ARISCV_PARAMS.NBW_PC)
   ) uu_dtpath (
      `ifdef SYNC_RISCV
      .i_aclk        ({~clk, {(ARISCV_PARAMS.NBW_ACLK-1){clk}}}),
      `else
      .i_aclk        (aclk),
      `endif
      .rst_async_n   (rst_async_n),
      .i_inst        (i_inst),
      .o_pc          (o_pc),
      .o_mem_clk     (o_mem_clk),
      .o_writeData   (o_writeData),
      .o_writeAddr   (o_writeAddr),
      .o_memWrite    (o_memWrite),
      .o_writeWidth  (o_writeWidth),
      .i_readData    (i_readData)
   );

   `ifndef SYNC_RISCV
   ariscv_ctrlpath #(
      .NBW_ACLK      (ARISCV_PARAMS.NBW_ACLK),
      .DELAY_PC_FD   (ARISCV_PARAMS.DELAY_PC_FD),
      .DELAY_FD_DE   (ARISCV_PARAMS.DELAY_FD_DE),
      .DELAY_DE_EM   (ARISCV_PARAMS.DELAY_DE_EM),
      .DELAY_DE_PC   (ARISCV_PARAMS.DELAY_DE_PC),
      .DELAY_EM_MW   (ARISCV_PARAMS.DELAY_EM_MW),
      .DELAY_MW_REG  (ARISCV_PARAMS.DELAY_MW_REG),
      .DELAY_REG_DE  (ARISCV_PARAMS.DELAY_REG_DE),
      .DELAY_LOOP    (ARISCV_PARAMS.DELAY_LOOP),
      .INIT_PC       (ARISCV_PARAMS.INIT_PC),
      .INIT_FD       (ARISCV_PARAMS.INIT_FD),
      .INIT_DE       (ARISCV_PARAMS.INIT_DE),
      .INIT_EM       (ARISCV_PARAMS.INIT_EM),
      .INIT_MW       (ARISCV_PARAMS.INIT_MW),
      .INIT_REG      (ARISCV_PARAMS.INIT_REG),
      .INIT_LOOP1    (ARISCV_PARAMS.INIT_LOOP1),
      .INIT_LOOP2    (ARISCV_PARAMS.INIT_LOOP2)
   ) uu_ctrlpath (
      .rst_async_n   (rst_async_n),
      .o_aclk        (aclk)
   );
   `endif

endmodule
