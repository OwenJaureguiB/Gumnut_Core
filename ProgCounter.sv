module ProgCounter (
	input  logic [11:0] PC_i,
	input  logic 		  we,
	input  logic 		  clk,
	input  logic 		  cen,
	input  logic 		  rst,
	output logic [11:0] PC_o
);
	
	logic ClkPC;
	
	always_ff @(posedge ClkPC or posedge rst) 
	begin
			if (rst) 	 PC_o <= 12'h000;
			else if (we) PC_o <= PC_i;
	end

	always_comb begin
		ClkPC = clk & cen;
	end
	
endmodule 