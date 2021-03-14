module IntReg (
	input  logic [11:0] pc_i,
	input  logic 		  c_i,
	input  logic 		  z_i,
	input  logic 		  clk,
	input  logic 		  cen,
	input  logic 		  rst,
	input  logic 		  we,
	output logic [11:0] pc_o,
	output logic 		  intc_o,
	output logic 		  intz_o
);

	logic ClkPC;
	
	always_ff @(posedge ClkPC or posedge rst) 
	begin
			if (rst) begin
				pc_o   <= 12'h000;
				intc_o <= 1'b0;
				intz_o <= 1'b0;
			end
			else if (we) begin
				pc_o   <= pc_i;
				intc_o <= c_i;
				intz_o <= z_i;
			end
	end

	always_comb begin
		ClkPC = clk & cen;
	end
endmodule 