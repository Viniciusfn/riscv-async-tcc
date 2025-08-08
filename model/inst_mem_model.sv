module inst_mem_model #(
   /* PARAMETERS */
   parameter FILE_NAME = "../mem/inst_mem",
   parameter FILE_TYPE = "txt",
   parameter NBW_INST = 32,
   parameter NBW_PC = 32,
   parameter MEM_SIZE = 256,
   parameter bit VERBOSE = 1
)(
   /* INTERFACE */
   input  logic [NBW_PC-1:0]     i_pc,
   output logic [NBW_INST-1:0]   o_inst
);

   /* Local signals and parameters */
   logic [NBW_INST-1:0] memory [MEM_SIZE-1:0];

   always_comb begin
      o_inst = memory[i_pc[$clog2(MEM_SIZE)+1:2]];
      if (VERBOSE) begin
         if(i_pc!=32'hfffffffc) begin
            $display("\n------ Inst-Mem access ------");
            $display("==> PC: %h", i_pc);
            $display("==> Loaded instruction: %h", memory[i_pc[$clog2(MEM_SIZE)+1:2]]);
         end
      end
   end

   initial begin
      integer fd;                 // File descriptor
      integer bytes_read;         // Number of bytes read
      byte byte0, byte1, byte2, byte3;

      if (VERBOSE) begin
         $display("=> Loading Instruction memory file: %s", FILE_NAME);
      end
      
      if (FILE_TYPE == "bin") begin
         // Open the binary file in read mode
         fd = $fopen(FILE_NAME, "rb");
         if (fd == 0) begin
            $display("Error: Unable to open file.");
            $finish;
         end

         // Read data from the file into the memory array
         for (int i = 0; i < MEM_SIZE; i++) begin
            bytes_read =  $fread(byte0, fd);
            bytes_read += $fread(byte1, fd);
            bytes_read += $fread(byte2, fd);
            bytes_read += $fread(byte3, fd);

            if (bytes_read < 4) begin
               if (VERBOSE) $display("End of file reached or error occurred.");
               break;
            end

            memory[i] = {byte3, byte2, byte1, byte0};
         end

         // Close the file
         $fclose(fd);
      end
      else begin //txt
         $readmemb(FILE_NAME, memory);
      end
   end
   

endmodule
