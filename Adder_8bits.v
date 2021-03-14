module Adder_8bits (
	input  		 cin,
	input  [7:0] A,
	input  [7:0] B,
	output 		 cout,
	output [7:0] res
);

	assign {cout, res} = A + B + cin;

endmodule 