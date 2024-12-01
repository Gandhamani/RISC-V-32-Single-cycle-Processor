
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero,res31                  // zero flag
);
//reg cout;
//reg [31:0]sum;
//always @(a, b, alu_ctrl) begin
//    case (alu_ctrl)
//        4'b0000: begin 
//        {cout,sum} = a + b;
//x        alu_out<=sum;
//        end 
//            // ADD
//        4'b0001:begin
//              {cout,sum} <= a + ~b + 1; 
//              alu_out<=sum;
//        end // SUB
//        3'b010:  alu_out <= a & b;       // AND
//        3'b011:  alu_out <= a | b;       // OR
//        3'b101:  begin                   // SLT
//                     if (a[31] != b[31]) alu_out <= a[31] ? 0 : 1;
//                     else alu_out <= a < b ? 1 : 0;
//                 end
//        default: alu_out = 0;
//    endcase
//end
//assign negative=alu_out[31];
//assign overflow=((sum[31]^a[31])&(~(alu_ctrl[0]^b[31]^a[31]))&(~alu_ctrl[1]));
//assign carry=((~alu_ctrl[1])& cout);
//assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

   wire [31:0]		      temp,Sum;
   wire			      V,slt, sltu; //overflow

   //~B if alu_ctrl[0] is set 1 for subtraction (R Type]
   assign temp = alu_ctrl[0] ? ~b:b;
   //Sum is addition of A + B + 0 or
   //Sum is subtraction of A + ~B + 1 <2's complement>
   assign Sum = a + temp + alu_ctrl[0]; 
   //checks for overflow if result has different sign than operands
   assign V = (alu_ctrl[0]) ? 
              (~(a[31] ^ b[31]) & (a[31] ^ Sum[31])) : // to check for addition - (operands same sign)&(result has diff sign than A)
              ((a[31] ^ b[31]) & (~(a[31] ^ Sum[31]))); // to check for subtraction - (operands have diff sign)&(result has same sign as A)  
   assign slt = (a[31] == b[31]) ? (a < b) : a[31]; // because for signed numbers, of both are of same sign, we can compare A and B, but if they are of different sign we can take the MSB of A
   //if A is positive and B is negative => A is not less than B, slt = 0 ie. A[31]
   //if A is negative and B is positive -> A is definitely lass than B, so slt = 1 ie. A[31]
   
   assign sltu = a < b; //for unsigned number comparison, this will give a boolean output (true - 1, false - 0)
   

   always@(a,b,alu_ctrl,Sum, slt,sltu)begin  
     case(alu_ctrl)
       4'b0000: alu_out <= Sum; //add
       4'b0001: alu_out <= Sum; //sub
       4'b0010: alu_out <= a&b; //and
       4'b0011: alu_out <= a|b; //or
       4'b0100: alu_out <= a^b; //xor
       
       4'b0101: alu_out <= {31'b0,slt}; //slt
       4'b0110: alu_out <= {31'b0,sltu}; // sltu
       //4'b0111: alu_out <= {a[31:12],12'b0}; //lui
       4'b1000: alu_out <= a + {b[31:12],12'b0}; // AUIPC
       4'b1001: alu_out <= {b[31:12],12'b0}; // LUI
       
       4'b1010: alu_out <= a << b; // sll, slli
       4'b1011: alu_out <= $signed(a) >>> b[4:0]; // sra
       4'b1100: alu_out <= a >> b; // srl
       
       //to add sll, slli,
       //to add sra
       default:  alu_out <= 'bx;
     endcase
   end
   assign res31=alu_out[31];
   assign zero = (alu_out == 32'b0);
endmodule

