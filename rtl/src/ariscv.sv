module ariscv #(
   /* PARAMETERS */
   parameter ACLK_NBW      = 6,
   // CTRLPATH
      // Delays: DELAY_Source_Receiver
   parameter DELAY_PC_FD   = 1,
   parameter DELAY_FD_DE   = 1,
   parameter DELAY_DE_EM   = 1,
   parameter DELAY_DE_PC   = 1,
   parameter DELAY_EM_MW   = 1,
   parameter DELAY_MW_REG  = 1,
   parameter DELAY_REG_DE  = 1,
   parameter DELAY_LOOP    = 1,
      // Initialization
   parameter INIT_PC       = 0,
   parameter INIT_FD       = 0,
   parameter INIT_DE       = 1,
   parameter INIT_EM       = 0,
   parameter INIT_MW       = 0,
   parameter INIT_REG      = 1,
   parameter INIT_LOOP1    = 0,
   parameter INIT_LOOP2    = 1,

   // DTPATH
   parameter NBW_INST      = 32,
   parameter NBW_REGISTER  = 32,
   parameter NBW_ADDR      = 32,
   parameter NBW_PC        = 32
)(
   /* INTERFACE */
   input logic                   rst_async_n,

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
   logic [ACLK_NBW-1:0]   aclk;

   /* Instances */
   ariscv_dtpath #(
      .ACLK_NBW      (ACLK_NBW),
      .NBW_INST      (NBW_INST),
      .NBW_REGISTER  (NBW_REGISTER),
      .NBW_ADDR      (NBW_ADDR),
      .NBW_PC        (NBW_PC)
   ) uu_dtpath (
      .i_aclk        (aclk),
      .rst_async_n   (rst_async_n),
      .i_inst        (i_inst),
      .o_pc          (o_pc),
      .o_mem_clk     (o_mem_clk),
      .o_writeData   (o_writeData),
      .o_writeAddr   (o_writeAddr),
      .o_memWrite    (o_memWrite),
      .i_readData    (i_readData)
   );

   ariscv_ctrlpath #(
      .ACLK_NBW      (ACLK_NBW),
      .DELAY_PC_FD   (DELAY_PC_FD),
      .DELAY_FD_DE   (DELAY_FD_DE),
      .DELAY_DE_EM   (DELAY_DE_EM),
      .DELAY_DE_PC   (DELAY_DE_PC),
      .DELAY_EM_MW   (DELAY_EM_MW),
      .DELAY_MW_REG  (DELAY_MW_REG),
      .DELAY_REG_DE  (DELAY_REG_DE),
      .DELAY_LOOP    (DELAY_LOOP),
      .INIT_PC       (INIT_PC),
      .INIT_FD       (INIT_FD),
      .INIT_DE       (INIT_DE),
      .INIT_EM       (INIT_EM),
      .INIT_MW       (INIT_MW),
      .INIT_REG      (INIT_REG),
      .INIT_LOOP1    (INIT_LOOP1),
      .INIT_LOOP2    (INIT_LOOP2)
   ) uu_ctrlpath (
      .rst_async_n   (rst_async_n),
      .o_aclk        (aclk)
   );

endmodule
