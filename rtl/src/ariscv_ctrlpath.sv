module ariscv_ctrlpath #(
   /* PARAMETERS */
   // Delays: DELAY_Source_Receiver
   parameter DELAY_PC_FD   = 1,
   parameter DELAY_FD_DE   = 1,
   parameter DELAY_DE_EM   = 1,
   parameter DELAY_EM_MW   = 1,
   parameter DELAY_EM_PC   = 1,
   parameter DELAY_MW_REG  = 1,
   parameter DELAY_REG_DE  = 1,
   parameter DELAY_LOOP    = 1
)(
   /* INTERFACE */
   input  logic         rst_async_n,
   output logic [5:0]   o_aclk
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

   /* Assignments */



   /* WCHB cells */
   //wchb_cell #(

   //) uu_cell_PC_FD (

   //);


   /* Forks and Joins */


endmodule
