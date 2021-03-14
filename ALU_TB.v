`timescale 1ns / 1ps

module ALU_TB;

	reg  [7:0]  A;
	reg  [7:0]  B;
	reg	 	   X;
	reg	 	   Y;
	reg	 	   Z;
	
	wire [7:0]  C;
	wire		cout;
	wire		  Ov;
	wire		 Neg;
	wire		Zero;
	
	integer i;
	integer j;
	integer k;
	integer l;
	integer m;
	
	
	ALU uut (
		.A(A),
		.B(B),
		.X(X),
		.Y(Y),
		.Z(Z),
		.C(C),
		.cout(cout),
		.Ov(Ov),
		.Neg(Neg),
		.Zero(Zero)
	);
	
	initial begin
		
		A = 0;
		B = 0;
		X = 0;
		Y = 0;
		Z = 0;
		
		#100;

		A = 15;
		B = 20;
		X = 0;
		Y = 0;
		Z = 0;
		
		#100;

		A = 20;
		B = 15;
		X = 0;
		Y = 0;
		Z = 1;
		
		#100;

		A = 15;
		B = 20;
		X = 0;
		Y = 1;
		Z = 0;
		
		#100;

		A = 15;
		B = 20;
		X = 0;
		Y = 1;
		Z = 1;
		
		#100;

		A = 3;
		B = 2;
		X = 1;
		Y = 0;
		Z = 0;
		
		#100;

		A = 3;
		B = 12;
		X = 1;
		Y = 0;
		Z = 1;
		
		#100;

		A = 1;
		B = 2;
		X = 1;
		Y = 1;
		Z = 0;
		
		#100;

		A = 1;
		B = 2;
		X = 1;
		Y = 1;
		Z = 1;
		
		#100;

		A = -100;
		B = -50;
		X = 0;
		Y = 0;
		Z = 0;
		
		#100;

		A = 25;
		B = 50;
		X = 0;
		Y = 0;
		Z = 1;
		
		#100;

		A = 125;
		B = 100;
		X = 0;
		Y = 0;
		Z = 1;
		
		#100;
		
		for (i = 0; i < 2; i = i + 1) begin
			X = i;
			
			for (j = 0; j < 2; j = j + 1) begin
			Y = j;
				
				for (k = 0; k < 2; k = k + 1) begin
					Z = k;
					
					for (l = -128; l < 128; l = l + 1) begin
						A = l;
						
						for (m = -128; m < 128; m = m + 1) begin
							if (Y & ((~X & ~Z) | Z))
								m = 128;
							else
								B = m;
								
							#100;
					
						end
						
					end
				
				end
			
			end
			
		end
		
		
	end
	
	
endmodule
