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
		addr_o = inst_i[11:0];
		disp_o = inst_i[7:0];
		rs_o = inst_i[10:8];
		rs2_o = inst_i[7:5];
		rd_o = inst_i[13:11];
		immed_o = inst_i[7:0];
		count_o = inst_i[7:5];
	end	
	
	always_comb begin
		func_o = (op_o[6]   == 1'b0) 		  ? 	 	 inst_i[16:14]  :
					(op_o[6:5] == 2'b10)		  ? {1'b0,inst_i[15:14]} :
					(op_o[6:4] == 3'b110) 	  ? {1'b0,inst_i[1:0]} 	 :
					(op_o[6:3] == 4'b1110) 	  ? 	 	 inst_i[2:0]	 :
					(op_o[6:2] == 5'b11110)   ? {2'b0,inst_i[12]}	 :
					(op_o[6:1] == 6'b111110)  ? {1'b0,inst_i[11:10]} :
					(op_o		  == 7'b1111110) ? 	 	 inst_i[10:8]   : 3'hx;
	end
	
endmodule