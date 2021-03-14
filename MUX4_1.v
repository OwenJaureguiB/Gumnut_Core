module MUX4_1 (
	input [7:0] I0,
	input [7:0] I1,
	input [7:0] I2,
	input [7:0] I3,
	input [1:0] s,
	output reg [7:0] OUT
);

	always @(*)
	begin
		case(s)
			2'b00: OUT = I0;
			2'b01: OUT = I1;
			2'b10: OUT = I2;
			2'b11: OUT = I3;
			default: OUT = 8'hxx;
		endcase
	end

endmodule 