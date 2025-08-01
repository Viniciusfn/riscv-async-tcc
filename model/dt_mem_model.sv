module dt_mem_model #(
   /* PARAMETERS */
   parameter FILE_NAME     = "none",
   parameter MEM_SIZE      = 256,
   parameter NBW_DATA      = 32,
   parameter NBW_ADDR      = 32,
   parameter VERBOSE       = 0
)(
   /* INTERFACE */
   input  logic                  aclk,
   input  logic [NBW_DATA-1:0]   i_writeData,
   input  logic [NBW_ADDR-1:0]   i_writeAddr,
   input  logic                  i_memWrite,
   input  logic [2:0]            i_writeWidth,
   output logic [NBW_DATA-1:0]   o_readData
);

   /* Local signals and parameters */
   logic [NBW_DATA-1:0] memory [MEM_SIZE-1:0];
   logic [$clog2(MEM_SIZE)-1:0]  word_addr_w;
   logic                         half_word_addr_w;
   logic                         byte_addr_w;

   /* Assignments */
   assign word_addr_w = i_writeAddr[$clog2(MEM_SIZE)+1:2];
   assign half_word_addr_w = i_writeAddr[1];
   assign byte_addr_w = i_writeAddr[0];

   /* Memory */
   always_ff @(posedge aclk) begin
      if (i_memWrite) begin
         case(i_writeWidth)
            3'b000: begin //SB
               case({half_word_addr_w, byte_addr_w})
                  2'b00:   memory[word_addr_w][7:0]   <= i_writeData[7:0];
                  2'b01:   memory[word_addr_w][15:8]  <= i_writeData[7:0];
                  2'b10:   memory[word_addr_w][23:16] <= i_writeData[7:0];
                  default: memory[word_addr_w][31:24] <= i_writeData[7:0];
               endcase
            end
            3'b001: begin //SH
               case(half_word_addr_w)
                  1'b0:    memory[word_addr_w][15:0]  <= i_writeData[15:0];
                  default: memory[word_addr_w][31:16] <= i_writeData[15:0];
               endcase
            end
            3'b010: memory[word_addr_w] <= i_writeData; //SW
            default: memory[word_addr_w] <= '0;
         endcase
      end
   end

   always_comb begin
      case(i_writeWidth)
         3'b000: begin //LB
            case({half_word_addr_w, byte_addr_w})
               2'b00: o_readData = {{24{memory[word_addr_w][7]}}, memory[word_addr_w][7:0]};
               2'b01: o_readData = {{24{memory[word_addr_w][15]}}, memory[word_addr_w][15:8]};
               2'b10: o_readData = {{24{memory[word_addr_w][23]}}, memory[word_addr_w][23:16]};
               default: o_readData = {{24{memory[word_addr_w][31]}}, memory[word_addr_w][31:24]};
            endcase
         end
         3'b001: begin //LH
            case(half_word_addr_w)
               1'b0:    o_readData = {{16{memory[word_addr_w][15]}},memory[word_addr_w][15:0]};
               default: o_readData = {{16{memory[word_addr_w][31]}},memory[word_addr_w][31:16]};
            endcase
         end
         3'b100: begin //LBU
            case({half_word_addr_w, byte_addr_w})
               2'b00: o_readData = {{24{1'b0}}, memory[word_addr_w][7:0]};
               2'b01: o_readData = {{24{1'b0}}, memory[word_addr_w][15:8]};
               2'b10: o_readData = {{24{1'b0}}, memory[word_addr_w][23:16]};
               default: o_readData = {{24{1'b0}}, memory[word_addr_w][31:24]};
            endcase
         end
         3'b101: begin //LHU
            case(half_word_addr_w)
               1'b0:    o_readData = {{16{1'b0}},memory[word_addr_w][15:0]};
               default: o_readData = {{16{1'b0}},memory[word_addr_w][31:16]};
            endcase
         end
         default: o_readData = memory[word_addr_w]; //LW
      endcase
   end

   // Load memory
   initial begin
      integer fd;                 // File descriptor
      integer bytes_read;         // Number of bytes read
      logic [NBW_DATA-1:0] temp_word;

      if (FILE_NAME != "none") begin
         if (VERBOSE) begin
            $display("=> Loading Data memory file: %s", FILE_NAME);
         end

         // Open the binary file in read mode
         fd = $fopen(FILE_NAME, "rb");
         if (fd == 0) begin
            $display("Error: Unable to open file.");
            $finish;
         end

         // Read data from the file into the memory array
         for (int i = 0; i < MEM_SIZE; i++) begin
            bytes_read = $fread(temp_word, fd);
            if (bytes_read == 0) begin
               $display("End of file reached or error occurred.");
               break;
            end
            memory[i] = temp_word;
         end

         // Close the file
         $fclose(fd);
      end
   end

endmodule
