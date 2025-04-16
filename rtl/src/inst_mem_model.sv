module inst_mem_model #(
   /* PARAMETERS */
   parameter FILE_NAME = "../mem/inst_mem",
   parameter NBW_INST = 32,
   parameter NBW_PC = 32,
   parameter MEM_SIZE = 256
)(
   /* INTERFACE */
   input  logic [NBW_PC-1:0]     i_pc,
   output logic [NBW_INST-1:0]   o_inst
);

   /* Local signals and parameters */
   logic [NBW_INST-1:0] memory [MEM_SIZE-1:0];

   always_comb begin
      o_inst = memory[i_pc[$clog2(MEM_SIZE)+1:2]];
      if(i_pc!=32'hfffffffc) begin
         $display("\n------ Inst-Mem access ------");
         $display("==> PC: %h", i_pc);
         $display("==> Loaded instruction: %h", memory[i_pc[$clog2(MEM_SIZE)+1:2]]);
      end
   end

   initial begin
      $display("=> Loading Instruction memory file: %s", FILE_NAME);
      $readmemb(FILE_NAME, memory);
   end
   

endmodule
