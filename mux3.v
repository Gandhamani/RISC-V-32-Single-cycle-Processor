
// mux3.v - logic for 3-to-1 multiplexer

// 3-to-1 Multiplexer Module (mux3)
// This module selects one of three input data lines (d0, d1, or d2) based on the 
// control signal 'sel' and outputs the selected data.

module mux3 #(parameter WIDTH = 8) (
    input       [WIDTH-1:0] d0, d1, d2,  // First, second, third data input (WIDTH bits wide)
    input       [31:0] sel, // Select signal (32 bits wide, uses the first two bits)
    output      [WIDTH-1:0] y // Output (WIDTH bits wide), the selected data
);

// The output y is determined by the 'sel' signal.
    // sel[1] is used for the highest level of selection (d2), and sel[0] is used for the second level (d1).
    // If sel[1] is 1, then d2 is selected. If sel[1] is 0, the value of sel[0] determines whether d1 or d0 is selected.
    // This logic is implemented using a ternary (conditional) operator.

assign y = sel[1] ? d2: (sel[0] ? d1 : d0);

endmodule

