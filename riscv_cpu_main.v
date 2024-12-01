
// riscv_cpu_main.v - Top Module to test riscv_cpu

module riscv_cpu_main (
    input         clk, reset, // Clock input signal // Reset input signal         
    input         Ext_MemWrite, // External memory write control signal
    input  [31:0] Ext_WriteData, Ext_DataAdr, // External data to be written to memory
    output        MemWrite, // Memory write control signal
    output [31:0] WriteData, DataAdr, ReadData, // Data to be written to memory, Address for memory access
    output [31:0] PC, Result  // Program Counter value, Result of the CPU's computation
);
// Internal wires for connecting processor and memory modules

wire [31:0] Instr; // Instruction output from instruction memory
wire [31:0] DataAdr_rv32, WriteData_rv32; // Data address and data to write for the RV32 processor
wire        MemWrite_rv32; // Memory write control for RV32 processor

     // Instantiate the RISC-V CPU module (riscv_cpu)
     // The RISC-V CPU takes the clock, reset, program counter (PC), instruction (Instr),
     // memory write signal (MemWrite_rv32), memory address (DataAdr_rv32), data to write (WriteData_rv32),
    // and outputs the read data (ReadData) and the result (Result).
   // instantiate processor and memories
riscv_cpu rvcpu    (clk, reset, PC, Instr, // Clock input, reset input, program counter input
                    MemWrite_rv32, DataAdr_rv32, // Memory write signal from CPU
                    WriteData_rv32, ReadData, Result); // Data to be written to memory
                    
    // Instantiate the instruction memory module (instr_mem)
    // The instruction memory takes the program counter (PC) as input and provides the instruction (Instr)
    
    // Instantiate the data memory module (data_mem)
    // The data memory takes the clock (clk), memory write signal (MemWrite), 
    // instruction slice (Instr[14:12]), data address (DataAdr), data to write (WriteData),
    // and outputs the data read (ReadData)
                    
instr_mem instrmem (PC, Instr);
data_mem  datamem  (clk, MemWrite,Instr[14:12], DataAdr, WriteData, ReadData);

     // Assign logic for controlling memory write, write data, and data address
    // MemWrite will be externally controlled if Ext_MemWrite is high and reset is active

assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32; // Control memory write based on external signal
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32; // Select external data to write if Ext_MemWrite is active
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32; // Select external address if reset is active

endmodule

