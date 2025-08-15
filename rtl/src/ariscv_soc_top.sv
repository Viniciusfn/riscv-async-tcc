import ariscv_params_pkg::*;

module ariscv_soc_top #(
   parameter ariscv_params_t ARISCV_PARAMS = ARISCV_PARAMS,
   parameter BASIC_TEST_FILE_NAME = "../mem/inst_mem",
   parameter COREMARK_INST_FILE_NAME = "../mem/coremark_bmrk_iram.bin",
   parameter COREMARK_DATA_FILE_NAME = "../mem/coremark_bmrk_dram.bin",
   parameter INST_MEM_SIZE = 32768*8/ARISCV_PARAMS.NBW_INST, // 32kBytes
   parameter DT_MEM_SIZE = 8192*8/ARISCV_PARAMS.NBW_REGISTER, // 8kBytes
   parameter VERBOSE = 0
)(
   /* INTERFACE */
   input logic                clk, // free-running clock for performance measurement
   input logic                rst_async_n
);

   /* INTERNAL INTERFACE */
   logic [ARISCV_PARAMS.NBW_INST-1:0]     w_inst;
   logic [ARISCV_PARAMS.NBW_PC-1:0]       w_pc;

   logic                                  w_mem_clk;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] w_writeData;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] w_writeAddr;
   logic                                  w_memWrite;
   logic [2:0]                            w_writeWidth;
   logic [ARISCV_PARAMS.NBW_REGISTER-1:0] w_readData;

   /* PERFORMANCE MEASURING */
   logic [31:0]         perf_counter_ff; // free-running clock counter

   // ARISCV CORE
   ariscv #(
      .ARISCV_PARAMS    (ARISCV_PARAMS)
   ) uu_core (
      .rst_async_n      (rst_async_n),

      // INSTR MEM
      .i_inst           (w_inst),
      .o_pc             (w_pc),

      // DATA MEM
      .o_mem_clk        (w_mem_clk),
      .o_writeData      (w_writeData),
      .o_writeAddr      (w_writeAddr),
      .o_memWrite       (w_memWrite),
      .o_writeWidth     (w_writeWidth),
      .i_readData       (w_readData)
   );


   // DATA MEMORY MODEL
   dt_mem_model #(
      `ifdef COREMARK_TEST
      .FILE_NAME     (COREMARK_DATA_FILE_NAME),
      `endif
      .MEM_SIZE      (DT_MEM_SIZE),
      .NBW_DATA      (ARISCV_PARAMS.NBW_REGISTER),
      .NBW_ADDR      (ARISCV_PARAMS.NBW_REGISTER),
      .VERBOSE       (VERBOSE)
   ) uu_dt_mem (
      .aclk          (w_mem_clk),
      .i_writeData   (w_writeData),
      .i_writeAddr   (w_writeAddr),
      .i_memWrite    (w_memWrite),
      .i_writeWidth  (w_writeWidth),
      .o_readData    (w_readData),

      .i_perf_counter(perf_counter_ff)
   );


   // INSTRUCTION MEMORY
   inst_mem_model #(
      `ifdef COREMARK_TEST
      .FILE_NAME  (COREMARK_INST_FILE_NAME),
      .FILE_TYPE  ("bin"),
      `else
      .FILE_NAME  (BASIC_TEST_FILE_NAME),
      .FILE_TYPE  ("txt"),
      `endif
      .MEM_SIZE   (INST_MEM_SIZE),
      .NBW_INST   (ARISCV_PARAMS.NBW_INST),
      .NBW_PC     (ARISCV_PARAMS.NBW_PC),
      .VERBOSE    (VERBOSE)
   ) uu_inst_mem (
      .i_pc       (w_pc),
      .o_inst     (w_inst)
   );


   // FREE-RUNNING CLOCK COUNTER (for performance)
   always_ff @( posedge clk or negedge rst_async_n ) begin : performance_counter
      if(!rst_async_n) begin
         perf_counter_ff <= '0;
      end
      else begin
         perf_counter_ff <= perf_counter_ff + 32'h1;
      end
   end

endmodule
