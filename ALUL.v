module ALUL (
	input [7:0] rs_i,
	input [7:0] op2_i,
	input [1:0] ALUOp_i,
	output [7:0] res
);

	wire [7:0] AND;
	wire [7:0] OR;
	wire [7:0] XOR;
	wire [7:0] MASK;
	
	assign AND = rs_i & op2_i;
	assign OR = rs_i | op2_i;
	assign XOR = rs_i ^ op2_i;
	assign MASK = rs_i & ~op2_i;
	
	MUX4_1 mux (
		.I0(AND),
		.I1(OR),
		.I2(XOR),
		.I3(MASK),
		.s(ALUOp_i),
		.OUT(res)
	);
	
endmodule 