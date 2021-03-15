module ALUS (
	input  	  [7:0] rs_i,
	input  	  [1:0] ALUOp_i,
	input  	  [2:0] count_i,
	output reg [7:0] res,
	output reg       cout
);
	
	always @(*) begin
		case(ALUOp_i)
			2'b00: {cout, res} = {1'b0, rs_i} << count_i;
			2'b01: {res, cout} = {rs_i, 1'b0} >> count_i;
			2'b10: {cout, res} = {1'b0, rs_i << count_i} | {1'b0, rs_i >> 4'h8-count_i};
			2'b11: {res, cout} = {rs_i >> count_i, 1'b0} | {rs_i << 4'h8-count_i, 1'b0};
			default: {res, cout} = {8'hxx, 1'bx};
		endcase
	end

endmodule 