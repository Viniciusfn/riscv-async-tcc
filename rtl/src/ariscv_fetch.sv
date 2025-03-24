module ariscv_fetch #(
   /* PARAMETERS */
   parameter NBW_INST   = 32,
   parameter NBW_PC     = 32
)(
   /* INTERFACE */
   input  logic                  rst_async_n,
   input  logic                  pc_aclk,
   input  logic                  fd_aclk,
   // FROM EXECUTE
   input  logic                  i_pc_src,
   input  logic [NBW_PC-1:0]     i_pc_target,
   // TO DECODE
   output logic [NBW_PC-1:0]     o_pc_fd,
   output logic [NBW_PC-1:0]     o_pc_plus4,
   output logic [NBW_INST-1:0]   o_inst,
   // INSTR MEM
   input  logic [NBW_INST-1:0]   i_inst,
   output logic [NBW_PC-1:0]     o_pc
);

   /* Local signals and parameters */
   logic [NBW_PC-1:0]      pc_plus4_w;
   logic [NBW_PC-1:0]      next_pc_w;
   logic [NBW_PC-1:0]      pc_ff;

   logic [NBW_PC-1:0]      pc_fd_ff;
   logic [NBW_PC-1:0]      pc_plus4_ff;
   logic [NBW_INST-1:0]    inst_ff;

   /* Output Assignments */
   assign o_pc = pc_ff;
   assign o_inst = inst_ff;
   assign o_pc_fd = pc_fd_ff;
   assign o_pc_plus4 = pc_plus4_ff;

   /* PC logic */
   assign pc_plus4_w = pc_ff + 3'd4;
   assign next_pc_w = (i_pc_src) ?i_pc_target :o_pc_plus4;

   /* FF */
   always_ff @(posedge pc_aclk or negedge rst_async_n) begin : pc_reg
      if (!rst_async_n) begin
         pc_ff <= '0;
      end
      else begin
         pc_ff <= next_pc_w;
      end
   end

   always_ff @(posedge fd_aclk or negedge rst_async_n) begin : fd_reg
      if(!rst_async_n) begin
         inst_ff     <= '0;
         pc_fd_ff    <= '0;
         pc_plus4_ff <= '0;
      end
      else begin
         inst_ff     <= i_inst;
         pc_fd_ff    <= pc_ff;
         pc_plus4_ff <= pc_plus4_w;
      end
   end

endmodule
