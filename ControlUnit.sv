module ControlUnit (
	input  logic					clk_i,
	input  logic				 ClkEn_e,
	input  logic					rst_i,
	input  logic				RegWrt_c,
	input  logic [17:0] 	 inst_dat_i,
	input  logic			 inst_ack_i,
	input  logic  [7:0]	 data_dat_i,
	input  logic  [7:0]	 port_dat_i,
	input  logic  [1:0]		RegMux_c,
	input  logic					op2_c,
	input  logic  [3:0]		 ALUOp_c,
	output logic  [2:0]	 		 op_e,
	output logic  [2:0]		  func_e,
	output logic [11:0]	 	  addr_e,
	output logic  [7:0]	 	  disp_e,
	output logic  [7:0] 		offset_e,
	output logic				 carry_e,
	output logic				  zero_e
);

	logic [2:0]		rs_e;
	logic [2:0]	  rs2_e;
	logic [2:0]		rd_e;
	logic [7:0] immed_e;
	logic [2:0]	count_e;
	logic	[7:0]	  dat_e;
	logic [7:0]	  ALU_e;
	
	
	IR ir (
		.inst_i(inst_dat_i),
		.ack_i(inst_ack_i),
		.op_o(op_e),
		.func_o(func_e),
		.addr_o(addr_e),
		.disp_o(disp_e),
		.offset_o(offset_e),
		.rs_o(rs_e),
		.rs2_o(rs2_e),
		.rd_o(rd_e),
		.immed_o(immed_e),
		.count_o(count_e)
	);
	
	
	always_comb begin
		case (RegMux_c)
			2'b00 : dat_e = ALU_e;
			2'b01 : dat_e = data_dat_i;
			2'b10 : dat_e = port_dat_i;
			default: dat_e = 8'hxx;
		endcase
	end
	
endmodule
