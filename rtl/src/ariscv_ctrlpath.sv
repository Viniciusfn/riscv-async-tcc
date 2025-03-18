module ariscv_ctrlpath #(
   /* PARAMETERS */
   //
   parameter ACLK_NBW      = 6,
   // Delays: DELAY_Source_Receiver
   parameter DELAY_PC_FD   = 1,
   parameter DELAY_FD_DE   = 1,
   parameter DELAY_DE_EM   = 1,
   parameter DELAY_EM_MW   = 1,
   parameter DELAY_EM_PC   = 1,
   parameter DELAY_MW_REG  = 1,
   parameter DELAY_REG_DE  = 1,
   parameter DELAY_LOOP    = 1,
   // Initialization
   parameter INIT_PC       = 1,
   parameter INIT_FD       = 0,
   parameter INIT_DE       = 0,
   parameter INIT_EM       = 0,
   parameter INIT_MW       = 0,
   parameter INIT_REG      = 1,
   parameter INIT_LOOP1    = 0,
   parameter INIT_LOOP2    = 0
)(
   /* INTERFACE */
   input  logic                  rst_async_n,
   output logic [ACLK_NBW-1:0]   o_aclk
);

   /* Local signals and parameters */
   logic req_PC_F1, ack_PC_F1;
   logic req_L1_L2, ack_L1_L2;
   logic req_L2_J1, ack_L2_J1;
   logic req_FD_J2, ack_FD_J2;
   logic req_DE_EM, ack_DE_EM;
   logic req_EM_F2, ack_EM_F2;
   logic req_MW_REG, ack_MW_REG;
   logic req_REG_J2, ack_REG_J2;

   logic req_F1_L1, ack_F1_L1;
   logic req_F1_FD, ack_F1_FD;
   logic req_F2_MW, ack_F2_MW;
   logic req_F2_J1, ack_F2_J1;
   logic req_J1_PC, ack_J1_PC;
   logic req_J2_DE, ack_J2_DE;

   logic req_L1_L2_delayed;
   logic req_L2_J1_delayed;
   logic req_FD_J2_delayed;
   logic req_DE_EM_delayed;
   logic req_MW_REG_delayed;
   logic req_REG_J2_delayed;
   logic req_F1_L1_delayed;
   logic req_F1_FD_delayed;
   logic req_F2_J1_delayed;
   logic req_F2_MW_delayed;

   /* WCHB cells */
   wchb_cell #(
      .INIT    (INIT_PC)
   ) uu_cell_PC (
      .rst_n   (rst_async_n),
      .i_req   (req_J1_PC),
      .i_ack   (ack_PC_F1),
      .o_req   (req_PC_F1),
      .o_ack   (ack_J1_PC),
      .o_aclk  (o_aclk[0])
   );

   wchb_cell #(
      .INIT    (INIT_FD)
   ) uu_cell_FD (
      .rst_n   (rst_async_n),
      .i_req   (req_F1_FD_delayed),
      .i_ack   (ack_FD_J2),
      .o_req   (req_FD_J2),
      .o_ack   (ack_F1_FD),
      .o_aclk  (o_aclk[1])
   );

   wchb_cell #(
      .INIT    (INIT_DE)
   ) uu_cell_DE (
      .rst_n   (rst_async_n),
      .i_req   (req_J2_DE),
      .i_ack   (ack_DE_EM),
      .o_req   (req_DE_EM),
      .o_ack   (ack_J2_DE),
      .o_aclk  (o_aclk[2])
   );

   wchb_cell #(
      .INIT    (INIT_EM)
   ) uu_cell_EM (
      .rst_n   (rst_async_n),
      .i_req   (req_DE_EM_delayed),
      .i_ack   (ack_EM_F2),
      .o_req   (req_EM_F2),
      .o_ack   (ack_DE_EM),
      .o_aclk  (o_aclk[3])
   );

   wchb_cell #(
      .INIT    (INIT_MW)
   ) uu_cell_MW (
      .rst_n   (rst_async_n),
      .i_req   (req_F2_MW_delayed),
      .i_ack   (ack_MW_REG),
      .o_req   (req_MW_REG),
      .o_ack   (ack_F2_MW),
      .o_aclk  (o_aclk[4])
   );

   wchb_cell #(
      .INIT    (INIT_REG)
   ) uu_cell_REG (
      .rst_n   (rst_async_n),
      .i_req   (req_MW_REG_delayed),
      .i_ack   (ack_REG_J2),
      .o_req   (req_REG_J2),
      .o_ack   (ack_MW_REG),
      .o_aclk  (o_aclk[5])
   );

   wchb_cell #(
      .INIT    (INIT_LOOP1)
   ) uu_cell_LOOP1 (
      .rst_n   (rst_async_n),
      .i_req   (req_F1_L1_delayed),
      .i_ack   (ack_L1_L2),
      .o_req   (req_L1_L2),
      .o_ack   (ack_F1_L1),
      .o_aclk  ()
   );

   wchb_cell #(
      .INIT    (INIT_LOOP2)
   ) uu_cell_LOOP2 (
      .rst_n   (rst_async_n),
      .i_req   (req_L1_L2_delayed),
      .i_ack   (ack_L2_J1),
      .o_req   (req_L2_J1),
      .o_ack   (ack_L1_L2),
      .o_aclk  ()
   );

   /* Forks and Joins */
   wchb_fork #(
      .INIT    (0)
   ) uu_fork_F1 (
      .rst_n   (rst_async_n),
      .i_req   (req_PC_F1),
      .o_ack   (ack_PC_F1),
      .o_req_0 (req_F1_FD),
      .i_ack_0 (ack_F1_FD),
      .o_req_1 (req_F1_L1),
      .i_ack_1 (ack_F1_L1)
   );

   wchb_fork #(
      .INIT    (0)
   ) uu_fork_F2 (
      .rst_n   (rst_async_n),
      .i_req   (req_EM_F2),
      .o_ack   (ack_EM_F2),
      .o_req_0 (req_F2_J1),
      .i_ack_0 (ack_F2_J1),
      .o_req_1 (req_F2_MW),
      .i_ack_1 (ack_F2_MW)
   );

   wchb_join #(
      .INIT    (0)
   ) uu_join_J1 (
      .rst_n   (rst_async_n),
      .i_req_0 (req_F2_J1_delayed),
      .o_ack_0 (ack_F2_J1),
      .i_req_1 (req_L2_J1_delayed),
      .o_ack_1 (ack_L2_J1),
      .o_req   (req_J1_PC),
      .i_ack   (ack_J1_PC)
   );

   wchb_join #(
      .INIT    (0)
   ) uu_join_J2 (
      .rst_n   (rst_async_n),
      .i_req_0 (req_FD_J2_delayed),
      .o_ack_0 (ack_FD_J2),
      .i_req_1 (req_REG_J2_delayed),
      .o_ack_1 (ack_REG_J2),
      .o_req   (req_J2_DE),
      .i_ack   (ack_J2_DE)
   );

   /* Delays */
   delay #(
      .DELAY   (DELAY_LOOP)
   ) uu_dly_PC_L1 (
      .i_data  (req_F1_L1),
      .o_data  (req_F1_L1_delayed)
   );

   delay #(
      .DELAY   (DELAY_LOOP)
   ) uu_dly_L1_L2 (
      .i_data  (req_L1_L2),
      .o_data  (req_L1_L2_delayed)
   );

   delay #(
      .DELAY   (DELAY_LOOP)
   ) uu_dly_L2_J1 (
      .i_data  (req_L2_J1),
      .o_data  (req_L2_J1_delayed)
   );

   delay #(
      .DELAY   (DELAY_FD_DE)
   ) uu_dly_FD_J2 (
      .i_data  (req_FD_J2),
      .o_data  (req_FD_J2_delayed)
   );

   delay #(
      .DELAY   (DELAY_DE_EM)
   ) uu_dly_DE_EM (
      .i_data  (req_DE_EM),
      .o_data  (req_DE_EM_delayed)
   );

   delay #(
      .DELAY   (DELAY_MW_REG)
   ) uu_dly_MW_REG (
      .i_data  (req_MW_REG),
      .o_data  (req_MW_REG_delayed)
   );

   delay #(
      .DELAY   (DELAY_REG_DE)
   ) uu_dly_REG_J2 (
      .i_data  (req_REG_J2),
      .o_data  (req_REG_J2_delayed)
   );

   delay #(
      .DELAY   (DELAY_PC_FD)
   ) uu_dly_F1_FD (
      .i_data  (req_F1_FD),
      .o_data  (req_F1_FD_delayed)
   );

   delay #(
      .DELAY   (DELAY_EM_PC)
   ) uu_dly_F2_J1 (
      .i_data  (req_F2_J1),
      .o_data  (req_F2_J1_delayed)
   );

   delay #(
      .DELAY   (DELAY_EM_MW)
   ) uu_dly_F2_MW (
      .i_data  (req_F2_MW),
      .o_data  (req_F2_MW_delayed)
   );

endmodule
