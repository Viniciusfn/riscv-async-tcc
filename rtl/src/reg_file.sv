module reg_file #(
   /* PARAMETERS */
   parameter ADDR_NBW      = 5,
   parameter DATA_NBW      = 32
)(
   /* INTERFACE */
   input  logic                  clk,
   input  logic                  rst_async_n,
   input  logic                  i_wr_en,
   input  logic [ADDR_NBW-1:0]   i_rd_addr_1,
   input  logic [ADDR_NBW-1:0]   i_rd_addr_2,
   input  logic [ADDR_NBW-1:0]   i_wr_addr_3,
   input  logic [DATA_NBW-1:0]   i_wr_dt,
   output logic [DATA_NBW-1:0]   o_rd_dt_1,
   output logic [DATA_NBW-1:0]   o_rd_dt_2,
);

   /* Local signals and parameters */
   logic [DATA_NBW-1:0]    reg_dt [(2**ADDR_NBW)-1:0];

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