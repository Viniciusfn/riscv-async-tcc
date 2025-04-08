module ariscv_mem #(
   /* PARAMETERS */
   parameter DT_MEM_SIZE         = 256,
   parameter NBW_REGISTER        = 32,
   parameter NBW_ADDR            = 5,
   parameter NBW_PC              = 32
)(
   /* INTERFACE */
   input  logic                     aclk,
   input  logic                     rst_async_n,
   // FROM EXEC
   input  logic [NBW_REGISTER-1:0]  i_aluResult,
   input  logic [NBW_REGISTER-1:0]  i_writeData,
   input  logic [NBW_ADDR-1:0]      i_wr_addr_reg,
   input  logic [NBW_PC-1:0]        i_pc_plus4,
   input  logic                     i_regWrite,
   input  logic [1:0]               i_resultSrc,
   input  logic                     i_memWrite,
   // TO WB
   output logic [NBW_REGISTER-1:0]  o_aluResult,
   output logic [NBW_REGISTER-1:0]  o_readData,
   output logic [NBW_ADDR-1:0]      o_wr_addr_reg,
   output logic [NBW_PC-1:0]        o_pc_plus4,
   output logic                     o_regWrite,
   output logic [1:0]               o_resultSrc
);

   /* Local signals and parameters */
   logic [NBW_REGISTER-1:0]   readData_w;

   /* FF */
   always_ff @( posedge aclk or negedge rst_async_n ) begin : mw_reg
      if(!rst_async_n) begin
         o_aluResult    <= '0;
         o_readData     <= '0;
         o_wr_addr_reg  <= '0;
         o_pc_plus4     <= '0;
         o_regWrite     <= '0;
         o_resultSrc    <= '0;
      end
      else begin
         o_aluResult    <= i_aluResult;
         o_readData     <= readData_w;
         o_wr_addr_reg  <= i_wr_addr_reg;
         o_pc_plus4     <= i_pc_plus4;
         o_regWrite     <= i_regWrite;
         o_resultSrc    <= i_resultSrc;
      end
   end

   /* Memory */
   dt_mem_model #(
      .MEM_SIZE      (DT_MEM_SIZE),
      .NBW_DATA      (NBW_REGISTER),
      .NBW_ADDR      (NBW_REGISTER)
   ) uu_dt_mem (
      .aclk          (aclk),
      .i_writeData   (i_writeData),
      .i_writeAddr   (i_aluResult),
      .i_memWrite    (i_memWrite),
      .o_readData    (readData_w)
   );

endmodule
