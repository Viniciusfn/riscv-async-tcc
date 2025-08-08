module ariscv_mem #(
   /* PARAMETERS */
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
   input  logic [2:0]               i_funct3,
   input  logic [NBW_PC-1:0]        i_pcTarget,
   // TO WB
   output logic [NBW_REGISTER-1:0]  o_aluResult,
   output logic [NBW_REGISTER-1:0]  o_readData,
   output logic [NBW_ADDR-1:0]      o_wr_addr_reg,
   output logic [NBW_PC-1:0]        o_pc_plus4,
   output logic [NBW_PC-1:0]        o_pcTarget,
   output logic                     o_regWrite,
   output logic [1:0]               o_resultSrc,
   // DATA MEMORY
   output logic [NBW_REGISTER-1:0]  o_writeData,
   output logic [NBW_REGISTER-1:0]  o_writeAddr,
   output logic                     o_memWrite,
   output logic [2:0]               o_writeWidth,
   input  logic [NBW_REGISTER-1:0]  i_readData
);
   /* Assignments */
   assign o_writeData = i_writeData;
   assign o_writeAddr = i_aluResult;
   assign o_memWrite = i_memWrite;
   assign o_writeWidth = i_funct3;

   /* FF */
   always_ff @( posedge aclk or negedge rst_async_n ) begin : mw_reg
      if(!rst_async_n) begin
         o_aluResult    <= '0;
         o_readData     <= '0;
         o_wr_addr_reg  <= '0;
         o_pc_plus4     <= '0;
         o_regWrite     <= '0;
         o_resultSrc    <= '0;
         o_pcTarget     <= '0;
      end
      else begin
         o_aluResult    <= i_aluResult;
         o_readData     <= i_readData;
         o_wr_addr_reg  <= i_wr_addr_reg;
         o_pc_plus4     <= i_pc_plus4;
         o_regWrite     <= i_regWrite;
         o_resultSrc    <= i_resultSrc;
         o_pcTarget     <= i_pcTarget;
      end
   end

endmodule
