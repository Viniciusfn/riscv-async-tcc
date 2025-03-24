module reg_file #(
   /* PARAMETERS */
   parameter NBW_ADDR      = 5,
   parameter NBW_DATA      = 32
)(
   /* INTERFACE */
   input  logic                  clk,
   input  logic                  rst_async_n,
   input  logic                  i_wr_en,
   input  logic [NBW_ADDR-1:0]   i_rd_addr_1,
   input  logic [NBW_ADDR-1:0]   i_rd_addr_2,
   input  logic [NBW_ADDR-1:0]   i_wr_addr_3,
   input  logic [NBW_DATA-1:0]   i_wr_dt,
   output logic [NBW_DATA-1:0]   o_rd_dt_1,
   output logic [NBW_DATA-1:0]   o_rd_dt_2
);

   /* Local signals and parameters */
   logic [NBW_DATA-1:0]    reg_dt [(2**NBW_ADDR)-1:0];

   /* Assignments */
   assign o_rd_dt_1 = reg_dt[i_rd_addr_1];
   assign o_rd_dt_2 = reg_dt[i_rd_addr_1];


   /* FF */
   always_ff @( posedge clk or negedge rst_async_n ) begin
      if(!rst_async_n) begin
         reg_dt <= '0;
      end
      else if (i_wr_en && (i_wr_addr_3 != '0)) begin
         reg_dt[i_wr_addr_3] <= i_wr_dt;
      end
      else begin
         reg_dt <= reg_dt;
      end
   end

endmodule
