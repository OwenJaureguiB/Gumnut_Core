module Registers (
	input  logic		 clk,
	input  logic		 rst,
	input  logic   	 cen,
	input  logic		 we,
	input  logic [2:0] rs_i,
	input  logic [2:0] rs2_i,
	input  logic [2:0] rd_i,
	input  logic [7:0] dat_i,
	output logic [7:0] rs_o,
	output logic [7:0] rs2_o
);
	
	integer i;
	
	logic clkg;
	
	logic [7:0] mem [7:0];
	
	always_comb clkg = clk & cen;
	
	always_ff @(posedge clkg or posedge rst)
	begin
		if(rst)
			for(i = 0; i < 8; i = i+1)
				mem[i] <= 8'h00;
		else if (we)
			mem[rd_i] <= dat_i;
	end
	
	always_comb 
	begin
		rs_o = mem[rs_i];
		rs2_o = mem[rs2_i];
	end
	
endmodule 