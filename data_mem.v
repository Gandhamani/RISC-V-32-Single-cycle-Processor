module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input                         clk,
    input                         wr_en,
    input        [2:0]            funct3,
    input        [ADDR_WIDTH-1:0] wr_addr,
    input        [DATA_WIDTH-1:0] wr_data,
    output reg   [DATA_WIDTH-1:0] rd_data_mem
);

    // Array of 64 32-bit words for memory
    reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

    // Extract word-aligned address (lower 6 bits for 64-word memory)
    wire [5:0] word_addr = wr_addr[7:2];

    // Synchronous write logic
    always @(posedge clk) begin
        if (wr_en) begin
            case (funct3)
                3'b000: begin // Byte write
                    case (wr_addr[1:0])
                        2'b00: data_ram[word_addr][7:0]   <= wr_data[7:0];
                        2'b01: data_ram[word_addr][15:8]  <= wr_data[7:0];
                        2'b10: data_ram[word_addr][23:16] <= wr_data[7:0];
                        2'b11: data_ram[word_addr][31:24] <= wr_data[7:0];
                        default: ; // No action for invalid case
                    endcase
                end
                3'b010: data_ram[word_addr] <= wr_data; // Word write
                default: ; // No action for unsupported funct3
            endcase
        end
    end

    // Combinational read logic
    always @(*) begin
        case (funct3)
            3'b000: begin // Byte read (sign-extended)
                case (wr_addr[1:0])
                    2'b00: rd_data_mem = {{24{data_ram[word_addr][7]}}, data_ram[word_addr][7:0]};
                    2'b01: rd_data_mem = {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15:8]};
                    2'b10: rd_data_mem = {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23:16]};
                    2'b11: rd_data_mem = {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31:24]};
                    default: rd_data_mem = 32'b0; // Default case for safety
                endcase
            end
            3'b100: begin // Byte read (zero-extended)
                case (wr_addr[1:0])
                    2'b00: rd_data_mem = {24'b0, data_ram[word_addr][7:0]};
                    2'b01: rd_data_mem = {24'b0, data_ram[word_addr][15:8]};
                    2'b10: rd_data_mem = {24'b0, data_ram[word_addr][23:16]};
                    2'b11: rd_data_mem = {24'b0, data_ram[word_addr][31:24]};
                    default: rd_data_mem = 32'b0; // Default case for safety
                endcase
            end
            3'b010: rd_data_mem = data_ram[word_addr]; // Word read
            default: rd_data_mem = 32'b0; // Default for unsupported funct3
        endcase
    end

endmodule
