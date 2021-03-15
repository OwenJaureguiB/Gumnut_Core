module ALUA (
	input  [7:0] rs_i,
	input  [7:0] op2_i,
	input  [1:0] ALUOp_i,
	input 		 carry_i,
	output [7:0] res,
	output 		 cout
);

	wire [7:0] OPA;
	wire [7:0] OPB;
	wire cin;
	wire cout_;

	ALUEXT ext (
		.rs_i(rs_i),
		.op2_i(op2_i),
		.ALUOp_i(ALUOp_i),
		.OPA(OPA),
		.OPB(OPB),
		.carry_i(carry_i),
		.c(cin)
	);
	
	Adder_8bits add (
		.A(OPA),
		.B(OPB),
		.cin(cin),
		.res(res),
		.cout(cout_)
	);

	assign cout = cout_ ^ ALUOp_i[1];

endmodule 
