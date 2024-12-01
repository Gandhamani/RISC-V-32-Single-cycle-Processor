`timescale 1 ns/1 ns

module tb;


// Testbench Module for RISC-V CPU
// registers to send data

reg clk; // Clock signal
reg reset; // Reset signal
reg Ext_MemWrite; // External Memory Write signal
reg [31:0] Ext_WriteData, Ext_DataAdr; // External Data Write and Address inputs

// Wire Ouputs from Instantiated Modules
wire [31:0] WriteData, DataAdr, ReadData; // External Data Write and Address inputs
wire MemWrite; // Memory Write signal
wire [31:0] PC, Result;  // Program Counter and Result of instructions

// Instantiate the RISC-V CPU (uut: Unit Under Test)
// Initialize Top Module
riscv_cpu_main uut (clk, reset, Ext_MemWrite, Ext_WriteData, Ext_DataAdr, MemWrite, WriteData, DataAdr, ReadData, PC, Result);

// Initialize fault counter, loop counter, and flag
integer fault_instrs = 0, i = 0, fw = 0, flag = 0;

// Test the RISC-V processor:

// Define instruction opcodes (for simplicity, these are placeholders)
localparam ADDI_x0  =   32'h8;
localparam ADDI     =   32'h10;
localparam SLLI     =   32'h14;
localparam SLTI     =   32'h18;
localparam SLTIU    =   32'h1C;
localparam XORI     =   32'h20;
localparam SRLI     =   32'h24;
localparam SRAI     =   32'h28;
localparam ORI      =   32'h2C;
localparam ANDI     =   32'h30;

localparam ADD      =   32'h34;
localparam SUB      =   32'h38;
localparam SLL      =   32'h3C;
localparam SLT      =   32'h40;
localparam SLTU     =   32'h44;
localparam XOR      =   32'h48;
localparam SRL      =   32'h4C;
localparam SRA      =   32'h50;
localparam OR       =   32'h54;
localparam AND      =   32'h58;

localparam LUI      =   32'h5C;
localparam AUIPC    =   32'h60;

localparam SB       =   32'h64;
localparam SH       =   32'h68;
localparam SW       =   32'h6C;

localparam LB       =   32'h70;
localparam LH       =   32'h74;
localparam LW       =   32'h78;
localparam LBU      =   32'h7C;
localparam LHU      =   32'h80;

localparam BLT_IN   =   32'h90;
localparam BLT_OUT  =   32'h9C;

localparam BGE_IN   =   32'hAC;
localparam BGE_OUT  =   32'hB8;

localparam BLTU_IN  =   32'hC8;
localparam BLTU_OUT =   32'hD4;

localparam BGEU_IN  =   32'hE4;
localparam BGEU_OUT =   32'hF0;

localparam BNE_IN   =   32'h100;
localparam BNE_OUT  =   32'h10C;

localparam BEQ_IN   =   32'h11C;
localparam BEQ_OUT  =   32'h128;

localparam JALR     =   32'h134;
localparam JAL      =   32'h138;

// generate clock to sequence tests
// Generate clock signal with 10ns period (5ns high, 5ns low)
always begin
    clk <= 1; # 5; clk <= 0; # 5;
end

// performing standard instructions
// Initial block for reset and initialization of inputs
initial begin
    reset = 1; // Assert reset
    Ext_MemWrite = 0; Ext_DataAdr = 32'b0; Ext_WriteData = 32'b0; #10; // Deassert memory write,  Set data address to 0, set data write to 0
    reset = 0; // Deassert reset after 10ns
end


 always @(negedge clk) begin
     case(PC)
         ADDI_x0 : begin
             i = i + 1'b1; // Increment instruction counter
             if(Result === -3)  $display("1. addi implementation is correct for x0 ");
             else begin
             // If the result is not as expected, display an error message
                 $display("1. addi implementation for x0 is incorrect");
             // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         ADDI    : begin
         // Increment the instruction counter for this case
             i = i + 1'b1;
        // Check if the result matches the expected value for the ADDI instruction
             if(Result === 9) $display("2. addi implementation is correct ");
             else begin
        // If the result is incorrect, display an error message
                 $display("2. addi implementation is incorrect");
        // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault instruction counter when an instruction fails
             end
         end
         SLLI    : begin
             i = i + 1'b1; // Increment instruction counter for SLLI instruction
             if(Result === 64) $display("3. slli implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("3. slli implementation is incorrect");
            // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SLTI    : begin
             i = i + 1'b1; // Increment instruction counter for SLTI instruction
             // Check if the result is correct for SLTI operation (expected result: 0)
             if(Result === 0) $display("4. slti implementation is correct ");
             else begin
              // If the result is incorrect, display an error message
                 $display("4. slti implementation is incorrect");
              // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SLTIU    : begin
             i = i + 1'b1; // Increment instruction counter for SLTIU instruction
             // Check if the result is correct for SLTIU operation (expected result: 1)
             if(Result === 1) $display("5. sltiu implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("5. sltiu implementation is incorrect");
             // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         XORI    : begin
             i = i + 1'b1;
             // Check if the result is correct for XORI operation (expected result: 2)
             if(Result === 2) $display("6. xori implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("6. xori implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SRLI    : begin
             i = i + 1'b1; // Increment instruction counter for SRLI instruction
             // Check if the result is correct for SRLI operation (expected result: 536870911)
             if(Result === 536870911) $display("7. srli implementation is correct ");
             else begin 
             // If the result is incorrect, display an error message
                 $display("7. srli implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SRAI    : begin
             i = i + 1'b1; // Increment instruction counter for SRAI instruction
             // Check if the result is correct for SRAI operation (expected result: -1)
             if(Result === -1) $display("8. srai implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("8. srai implementation is incorrect");
             // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         ORI    : begin
             i = i + 1'b1;
             if(Result === -1) $display("9. ori implementation is correct "); // Increment instruction counter for ORI instruction
             else begin
             // If the result is incorrect, display an error message
                 $display("9. ori implementation is incorrect");
             // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         ANDI    : begin
             i = i + 1'b1; // Increment instruction counter for ANDI instruction
             // Check if the result is correct for ANDI operation (expected result: 1)
             if(Result === 1) $display("10. andi implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("10. andi implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         ADD    : begin
             i = i + 1'b1; // Increment instruction counter for ADD instruction
             // Check if the result is correct for ADD operation (expected result: 17)
             if(Result === 17) $display("11. add implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("11. add implementation is incorrect");
                  // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SUB    : begin
             i = i + 1'b1; // Increment instruction counter for SUB instruction
             // Check if the result is correct for SUB operation (expected result: 15)
             if(Result === 15) $display("12. sub implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("12. sub implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SLL    : begin
             i = i + 1'b1; // Increment instruction counter for SLL (Shift Left Logical) instruction
             // Check if the result is correct for SLL operation (expected result: 32)
             if(Result === 32) $display("13. sll implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("13. sll implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SLT    : begin
             i = i + 1'b1; // Increment instruction counter for SLT (Set Less Than) instruction
             // Check if the result is correct for SLT operation (expected result: 0)   
             if(Result === 0) $display("14. slt implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("14. slt implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SLTU    : begin
             i = i + 1'b1; // Increment instruction counter for SLTU (Set Less Than Unsigned) instruction
             // Check if the result is correct for SLTU operation (expected result: 1)
             if(Result === 1) $display("15. sltu implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("15. sltu implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         XOR    : begin
             i = i + 1'b1; // Increment instruction counter for XOR (Exclusive OR) instruction
             // Check if the result is correct for XOR operation (expected result: 17)
             if(Result === 17) $display("16. xor implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("16. xor implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
             end
         end SRA    : begin
             i = i + 1'b1; // Increment instruction counter for SRA (Shift Right Arithmetic) instruction
             if(Result === 8) $display("18. sra implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("18. sra implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         OR    : begin
             i = i + 1'b1; // Increment instruction counter for OR (Logical OR) instruction
             // Check if the result is correct for OR operation (expected result: 17)
             if(Result === 17) $display("19. or implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("19. or implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         AND    : begin
             i = i + 1'b1; // Increment instruction counter for AND (Logical AND) instruction
             if(Result === 0) $display("20. and implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("20. and implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         LUI    : begin
             i = i + 1'b1;
             if(Result === 32'h02000000) $display("21. lui implementation is correct ");
             // Check if the result is correct for LUI operation (expected result: 32'h02000000)
             else begin
             // If the result is incorrect, display an error message
                 $display("21. lui implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         AUIPC    : begin
             i = i + 1'b1; // Increment instruction counter for AUIPC (Add Upper Immediate to PC) instruction
             // Check if the result is correct for AUIPC operation (expected result: 32'h02000060)
             if(Result === 32'h02000060) $display("22. auipc implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("22. auipc implementation is incorrect");
                  // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SB      : begin
             i = i + 1'b1; // Increment instruction counter for SB (Store Byte) instruction
             // Check if memory write is active and system is not in reset
             if(MemWrite && !reset) begin
                 if(DataAdr === 33 & WriteData === 1) $display ("23. sb implementation is correct");
                 else begin
                 // If t
         SRL    : begin
             i = i + 1'b1; // Increment instruction counter for SRL (Shift Right Logical) instruction
             // Check if the result is correct for SRL operation (expected result: 8)
             if(Result === 8) $display("17. srl implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("17. srl implementation is incorrect");
                 // Increment the fault instruction counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         SRA    : begin
             i = i + 1'b1; // Increment instruction counter for SRA (Shift Right Arithmetic) instruction
             if(Result === 8) $display("18. sra implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("18. sra implementation is incorrect");
                 // Increment the fault counter for incorrect implementation
                 fault_instrs = fault_instrs + 1'b1;
             end
         end
         OR    : begin
             i = i + 1'b1; // Increment instruction counter for OR (Logical OR) instruction
             if(Result === 17) $display("19. or implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("19. or implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         AND    : begin
             i = i + 1'b1; // Increment instruction counter for AND (Logical AND) instruction
             if(Result === 0) $display("20. and implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("20. and implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         LUI    : begin
             i = i + 1'b1; // Increment instruction counter for LUI (Load Upper Immediate) instruction
             if(Result === 32'h02000000) $display("21. lui implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("21. lui implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         AUIPC    : begin
             i = i + 1'b1; // Increment instruction counter for AUIPC (Add Upper Immediate to PC) instruction
             if(Result === 32'h02000060) $display("22. auipc implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("22. auipc implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         SB      : begin
             i = i + 1'b1; // Increment instruction counter for SB (Store Byte) instruction
             if(MemWrite && !reset) begin
                 if(DataAdr === 33 & WriteData === 1) $display ("23. sb implementation is correct");
                 else begin
                 // If the result is incorrect, display an error message
                     $display("23. sb implementation is incorrect");
                     fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
                 end
             end
         end
         SH      : begin
             i = i + 1'b1;// Increment the instruction counter
             if(MemWrite && !reset) begin   
             // Check if the data address and write data match the expected values
                 if(DataAdr === 38 & WriteData === -3) $display ("24. sh implementation is correct");
                 else begin
                 // If the result is incorrect, display an error message
                     $display("24. sh implementation is incorrect");
                     fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
                 end
             end
         end
         SW      : begin
             i = i + 1'b1;
             if(MemWrite && !reset) begin
                 if(DataAdr === 40 & WriteData === 16) $display ("25. sw implementation is correct");
                 else begin
                 // If the result is incorrect, display an error message
                     $display("25. sw implementation is incorrect");
                     fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
                 end
             end
         end
         LB      : begin
             i = i + 1'b1;    // Increment instruction counter
             // Check if the data address matches the expected value and the result is as expected
             if(DataAdr === 33 & Result === 1 ) $display ("26. lb implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("26. lb implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         LH      : begin
             i = i + 1'b1;
              // Validate data address and result for the load half-word operation
             if(DataAdr === 38 & Result === -3 ) $display ("27. lh implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("27. lh implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         LW      : begin
             i = i + 1'b1;
              // Validate data address and result for the load half-word operation
             if(DataAdr === 40 & Result === 16) $display ("28. lw implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("28. lw implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         LBU      : begin
             i = i + 1'b1;
              // Validate data address and result for the load half-word operation
             if(DataAdr === 33 & Result === 1) $display ("29. lbu implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("29. lbu implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         LHU     : begin
             i = i + 1'b1;
              // Validate data address and result for the load half-word operation
             if(DataAdr === 38 & Result === 32'h0000FFFD) $display ("30. lhu implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("30. lhu implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1; // Increment the fault counter
             end
         end
         BLT_IN : begin
            // Check if the branch-less-than (BLT) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (32'hA)
             if(Result <= 32'hA) $display("31. blt is executing"); // Log message indicating BLT is currently executing
             else begin
             // Handle the case where the BLT condition is not satisfied and may cause an infinite loop
                 $display("blt struck in loop"); // Display error message for stuck condition
                 flag = 1;
                 $stop; // Stop simulation to prevent further issues
             end
         end
         BLT_OUT : begin
         // Increment the instruction counter
             i = i + 1'b1;
             // Validate the result after the BLT operation
             // Expect the Result to match the expected value (5) upon successful execution
             if(Result === 5) $display("31. blt implementation is correct ");
             else begin
              // Handle incorrect result for BLT operation
             // If the result is incorrect, display an error message
                 $display("31. blt implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end
         BGE_IN : begin
         // Check if the branch-greater-or-equal (BGE) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (32'hB)
             if(Result <= 32'hB) $display("32. bge is executing");
             else begin
             // Handle the case where the BGE condition is not satisfied and may cause an infinite loop
                 $display("bge struck in loop"); // Display error message for stuck condition
                 flag = 1;
                 $stop; // Stop simulation to prevent further issues
             end
         end

         BGE_OUT : begin
         
             i = i + 1'b1;
                 // Validate the result after the branch-greater-or-equal (BGE) operation
                 // Expect the Result to match the expected value (-6) upon successful execution
             if(Result === -6) $display("32. bge implementation is correct");
             else begin
             // If the result is incorrect, display an error message
                 $display("32. bge implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         BLTU_IN : begin
         // Check if the branch-less-than-unsigned (BLTU) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (4)
             if(Result <= 4) $display("33. bltu is executing"); // Log message indicating BLTU is currently executing
             else begin
                 $display("bltu struck in loop"); // Display error message for stuck condition
                 flag = 1;// Set error flag to indicate a problem
                 $stop; // Stop simulation to prevent further issues
             end
         end

         BLTU_OUT : begin
             i = i + 1'b1;
             // Validate the result after the BLTU operation
    // Expect the Result to match the expected value (5) upon successful execution
             if(Result === 5) $display("33. bltu implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("33. bltu implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         BGEU_IN : begin
         // Check if the branch-greater-or-equal-unsigned (BGEU) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (5)
             if(Result <= 5) $display("34. bgeu is executing");
             else begin
                 $display("bgeu struck in loop"); // Display error message for stuck condition
                 flag = 1;
                 $stop;
             end
         end

         BGEU_OUT : begin
             i = i + 1'b1;
             // Validate the result after the BGEU operation
    // Expect the Result to match the expected value (0) upon successful execution
             if(Result === 0) $display("34. bgeu implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("34. bgeu implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         BNE_IN : begin
         // Check if the branch-not-equal (BNE) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (5)
             if(Result <= 5) $display("35. bne is executing");
             else begin
                 $display("bne struck in loop"); // Display error message for stuck condition
                 flag = 1;// Set error flag to indicate a problem
                 $stop;
             end
         end

         BNE_OUT : begin
             i = i + 1'b1;
             if(Result === 5) $display("35. bne implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("35. bne implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         BEQ_IN : begin
         // Check if the branch-equal (BEQ) condition is being evaluated
    // The condition checks if the Result is less than or equal to the threshold (2)
             if(Result <=2) $display("36. beq is executing"); // Log message indicating BEQ is currently executing
             else begin
                 $display("beq struck in loop"); // Display error message for stuck condition
                 $stop; // Stop simulation to prevent further issues
             end
         end

         BEQ_OUT : begin
             i = i + 1'b1;    // Increment the instruction counter to track progress
             // Check if the result of the branch-equal (BEQ) operation matches the expected value (4)
             if(Result === 4) $display("36. beq implementation is correct ");
             else begin
             // Handle incorrect result for BEQ operation
             // If the result is incorrect, display an error message
                 $display("36. beq implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         JALR: begin
             i = i + 1'b1;// Increment the instruction counter to track progress
               // Check if the result of the jump-and-link-register (JALR) operation matches the expected value (0x130)
             if (Result === 32'h130) $display("37. jalr implementation is correct ");
             else begin
             // If the result is incorrect, display an error message
                 $display("37. jalr implementation is incorrect");
                 fault_instrs = fault_instrs + 1'b1;// Increment the fault counter
             end
         end

         JAL: begin
             i = i + 1'b1; // Increment the instruction counter to track progress
      // Check if the result of the jump-and-link (JAL) operation matches the expected value (0x13C)     
             if (Result === 32'h13C ) $display("38. jal implementation is correct ");
           else begin
           // If the result is incorrect, display an error message
                 $display("38. jal implementation is incorrect");
             end
         end
     endcase
 end

endmodule
