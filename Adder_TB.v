`timescale 1 ns / 1 ps

module Adder_TB();

	reg  [7:0] A;
	reg  [7:0] B;
	wire [7:0] C;
	wire       Cout;
	wire       Ov;
	integer    i;
	integer    j;
	
	Adder_8bits adder (
		.A(A),
		.B(B),
		.C(C),
		.cout(Cout),
		.Ov(Ov)
	);
	
	initial begin
		for (i = -128; i < 128; i = i+1) 
		begin
			A = i;
			for (j = -128; j < 128; j = j+1) 
			begin
				B = j;
				#10;
			end
		end
	end
	
endmodule 