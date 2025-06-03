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
   input  logic [2:0]            i_writeWidth,
   output logic [NBW_DATA-1:0]   o_readData
);

   /* Local signals and parameters */
   logic [NBW_DATA-1:0] mem [MEM_SIZE-1:0];
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
                  2'b00:   mem[word_addr_w][7:0]   <= i_writeData[7:0];
                  2'b01:   mem[word_addr_w][15:8]  <= i_writeData[7:0];
                  2'b10:   mem[word_addr_w][23:16] <= i_writeData[7:0];
                  default: mem[word_addr_w][31:24] <= i_writeData[7:0];
               endcase
            end
            3'b001: begin //SH
               case(half_word_addr_w)
                  1'b0:    mem[word_addr_w][15:0]  <= i_writeData[15:0];
                  default: mem[word_addr_w][31:16] <= i_writeData[15:0];
               endcase
            end
            3'b010: mem[word_addr_w] <= i_writeData; //SW
            default: mem[word_addr_w] <= '0;
         endcase
      end
   end

   always_comb begin
      case(i_writeWidth)
         3'b000: begin //LB
            case({half_word_addr_w, byte_addr_w})
               2'b00: o_readData <= {{24{mem[word_addr_w][7]}}, mem[word_addr_w][7:0]};
               2'b01: o_readData <= {{24{mem[word_addr_w][15]}}, mem[word_addr_w][15:8]};
               2'b10: o_readData <= {{24{mem[word_addr_w][23]}}, mem[word_addr_w][23:16]};
               default: o_readData <= {{24{mem[word_addr_w][31]}}, mem[word_addr_w][31:24]};
            endcase
         end
         3'b001: begin //LH
            case(half_word_addr_w)
               1'b0:    o_readData <= {{16{mem[word_addr_w][15]}},mem[word_addr_w][15:0]};
               default: o_readData <= {{16{mem[word_addr_w][31]}},mem[word_addr_w][31:16]};
            endcase
         end
         3'b100: begin //LBU
            case({half_word_addr_w, byte_addr_w})
               2'b00: o_readData <= {{24{1'b0}}, mem[word_addr_w][7:0]};
               2'b01: o_readData <= {{24{1'b0}}, mem[word_addr_w][15:8]};
               2'b10: o_readData <= {{24{1'b0}}, mem[word_addr_w][23:16]};
               default: o_readData <= {{24{1'b0}}, mem[word_addr_w][31:24]};
            endcase
         end
         3'b101: begin //LHU
            case(half_word_addr_w)
               1'b0:    o_readData <= {{16{1'b0}},mem[word_addr_w][15:0]};
               default: o_readData <= {{16{1'b0}},mem[word_addr_w][31:16]};
            endcase
         end
         default: o_readData = mem[word_addr_w]; //LW
      endcase
   end
      
   assign o_readData = mem[word_addr_w];

endmodule
