module ALU (
	input  [7:0] rs_i,
	input  [7:0] op2_i,
	input  [3:0] ALUOp_i,
	input 		 carry_i,
	input  [2:0] count_i,
	output [7:0] res_o,
	output reg	 carry_o,
	output 		 zero_o
);

	wire couta;
	wire couts;
	wire [7:0] a;
	wire [7:0] l;
	wire [7:0] s;
	
	ALUA alua (
		.rs_i(rs_i),
		.op2_i(op2_i),
		.ALUOp_i(ALUOp_i[1:0]),
		.res(a),
		.cout(couta),
		.carry_i(carry_i)
	);
	
	ALUL alul (
		.rs_i(rs_i),
		.op2_i(op2_i),
		.ALUOp_i(ALUOp_i[1:0]),
		.res(l)
	);
	
	ALUS alus (
		.rs_i(rs_i),
		.count_i(count_i),
		.ALUOp_i(ALUOp_i[1:0]),
		.res(s),
		.cout(couts)
	);
	
	MUX4_1 selector (
		.I0(a),
		.I1(l),
		.I2(s),
		.I3(8'h00),
		.s(ALUOp_i[3:2]),
		.OUT(res_o)
	); 
	
	always @(*) begin
		case (ALUOp_i[3:2])
			2'b00: carry_o = couta;
			2'b01: carry_o = 1'b0;
			2'b10: carry_o = couts;
			2'b11: carry_o = 1'b0;
			default: carry_o = 1'bx;
		endcase
	end
	
	assign zero_o = ~(| res_o);
	
endmodule 