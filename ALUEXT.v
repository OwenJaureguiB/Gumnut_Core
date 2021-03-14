module ALUEXT (
	input  [7:0] rs_i,
	input  [7:0] op2_i,
	input  [1:0] ALUOp_i,
	input        carry_i,
	output [7:0] OPA,
	output [7:0] OPB,
	output c
);

	assign OPA = rs_i;
	assign OPB = (ALUOp_i[1])?~op2_i:op2_i;
	assign c = (ALUOp_i[0])?
				  (carry_i^ALUOp_i[1]):
				  ALUOp_i[1];

endmodule 