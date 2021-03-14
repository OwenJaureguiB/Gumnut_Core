module IR (
	input  logic [17:0] 	 inst_e,
	input  logic			     we,
	input  logic				 clk,
	input  logic				 cen,
	input  logic				 rst,
	output logic  [6:0]	 	op_o,
	output logic  [2:0]   func_o,
	output logic [11:0]	 addr_o,
	output logic  [7:0]	 disp_o,
	output logic  [2:0]		rs_o,
	output logic  [2:0]	  rs2_o,
	output logic  [2:0]		rd_o,
	output logic  [7:0]  immed_o,
	output logic  [2:0]	count_o	
);

	logic [17:0] inst_i;
	logic 		   clkg;
	
	always_comb clkg = clk & cen;
	
	always_ff @(posedge clkg) begin
		if (rst)
			inst_i = 17'b0;
		else if (we)
			inst_i = inst_e;
	end

	always_comb begin
		op_o = inst_i[17:11];
		func_o = inst_i[17] ? inst_i[2:0] : inst_i[16:14];
		addr_o = inst_i[11:0];
		disp_o = inst_i[7:0];
		rs_o = inst_i[10:8];
		rs2_o = inst_i[7:5];
		rd_o = inst_i[13:11];
		immed_o = inst_i[7:0];
		count_o = inst_i[7:5];
	end	
	
endmodule