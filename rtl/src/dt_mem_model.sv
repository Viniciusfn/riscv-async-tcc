module dt_mem_model #(
   /* PARAMETERS */
   parameter MEM_SIZE      = 256,
   parameter NBW_DATA      = 32,
   parameter NBW_ADDR      = 32
)(
   /* INTERFACE */
   input  logic                  aclk,
   input  logic [NBW_DATA-1:0]   i_writeData,
   input  logic [NBW_ADDR-1:0]   i_writeAddr,
   input  logic                  i_memWrite,
   output logic [NBW_DATA-1:0]   o_readData
);

   /* Local signals and parameters */
   logic [NBW_DATA-1:0] mem [MEM_SIZE-1:0];

   /* Memory */
   always_ff @(posedge aclk) begin
      if (i_memWrite) begin
         mem[i_writeAddr[$clog2(MEM_SIZE)+1:2]] <= i_writeData;
      end
      else begin
         mem[i_writeAddr[$clog2(MEM_SIZE)+1:2]] <= mem[i_writeAddr[$clog2(MEM_SIZE)+1:2]];
      end
   end

   assign o_readData = mem[i_writeAddr[$clog2(MEM_SIZE)+1:2]];
   

endmodule
