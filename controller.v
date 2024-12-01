
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        zero,res31,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump,Jalr,
    output [1:0] ImmSrc,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;
wire       Branch;

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump,Jalr, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch
assign PCSrc = Jump | (Branch & (
(funct3 == 3'b000 && zero) |//beq
(funct3 == 3'b001 && ~zero) |//bnq
(funct3 == 3'b100 && res31) |//blt
(funct3 == 3'b101 && (~res31 | zero)) |//bge
(funct3 == 3'b110 && res31) |//bltu 
(funct3 == 3'b111 && (~res31 | zero))
//bgeu
));

endmodule

