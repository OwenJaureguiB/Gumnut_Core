module Gumnut_Core (
	input  logic        clk_i,
	input  logic 		  ClkEn_e,
	input  logic 		  rst_i,
	input  logic [17:0] inst_dat_i,
	input  logic [7:0]  data_dat_i,
	input  logic [7:0]  port_dat_i,
	input  logic 		  int_req,
	input	 logic 		  inst_ack_i,
	input  logic 		  data_ack_i,
	input  logic 		  port_ack_i,
	output logic [11:0] inst_addr_o,
	output logic [7:0]  data_data_o,
	output logic [7:0]  port_data_o,
	output logic [7:0]  data_addr_o,
	output logic [7:0]  port_addr_o,
	output logic		  int_ack,
	output logic		  inst_stb_c,
	output logic		  inst_cyc_c,
	output logic		  port_we_o,
	output logic		  data_we_c,
	output logic		  data_stb_c,
	output logic		  data_cyc_c
);

	logic [6:0]  op_e;
	logic [2:0]  func_e;
	logic 	    op2_c;
	logic [3:0]  ALUOp_c;
	logic 		 ALUFR_c;
	logic			 ALUEn_c;
	logic			 RegWrt_c;
	logic [1:0]  RegMux_c;
	logic 		 PCEn_c;
	logic	[3:0]	 PCoper_c;
	logic 		 pop_c;
	logic 		 push_c;
	logic 		 StmMux_c;
	logic			 reti_c;
	logic 		 int_c;
	logic 		 port_we_c;
	logic			 ccC_e;
	logic			 ccZ_e;
	logic [7:0]  disp_e;
	logic	[11:0] addr_e;
	logic			 intz_c;
	logic			 intc_c;

	Control_Unit CU (
		.op_i(op_e),
		.func_i(func_e),
		.inst_ack_i(inst_ack_i),
		.int_req(int_req),
		.data_ack_i(data_ack_i),
		.port_ack_i(port_ack_i),
		.clk(clk_i),
		.rst(rst_i),
		.op2_o(op2_c),
		.ALUOp_o(ALUOp_c),
		.ALUFR_o(ALUFR_c),
		.ALUEn_o(ALUEn_c),
		.RegWrt_o(RegWrt_c),
		.RegMux_o(RegMux_c),
		.PCEn_o(PCEn_c),
		.PCoper_o(PCoper_c),
		.ret_o(pop_c),
		.jsb_o(push_c),
		.reti_o(reti_c),
		.int_o(int_c),
		.stb_o(inst_stb_c),
		.cyc_o(inst_cyc_c),
		.port_we_o(port_we_c),
		.data_we_o(data_we_c),
		.data_stb_o(data_stb_c),
		.data_cyc_o(data_cyc_c),
		.int_ack(int_ack),
		.StmMux_o(StmMux_c)
	);
	
	PC_Unit PCU (
		.clk_i(clk_i),
		.ClkEn_e(ClkEn_e),
		.rst_i(rst_i),
		.PCoper_c(PCoper_c),
		.PCEn_c(PCEn_c),
		.push_c(push_c),
		.pop_c(pop_c),
		.ccC_e(ccC_e),
		.ccZ_e(ccZ_e),
		.int_c(int_c),
		.disp_e(disp_e),
		.addr_e(addr_e),
		.inst_addr_o(inst_addr_o),
		.intz_o(intz_c),
		.intc_o(intc_c)
	);
	
	ProcessingUnit PU (
		.clk_i(clk_i),
		.ClkEn_e(ClkEn_e),
		.rst_i(rst_i),
		.RegWrt_c(RegWrt_c),
		.inst_dat_i(inst_dat_i),
		.inst_ack_i(inst_ack_i),
		.data_dat_i(data_dat_i),
		.port_dat_i(port_dat_i),
		.RegMux_c(RegMux_c),
		.DPMux_c(StmMux_c),
		.op2_c(op2_c),
		.ALUOp_c(ALUOp_c),
		.ALUEn_c(ALUEn_c),
		.port_we_c(port_we_c),
		.ALUFR_c(ALUFR_c),
		.reti_c(reti_c),
		.intz_i(intz_c),
		.intc_i(intc_c),	
		.op_e(op_e),
		.func_e(func_e),
		.addr_e(addr_e),
		.disp_e(disp_e),
		.port_we_o(port_we_o),
		.port_data_o(port_data_o),
		.port_addr_o(port_addr_o),
		.addr_i(data_addr_o),
		.dat_i(data_data_o),
		.ccC_e(ccC_e),
		.ccZ_e(ccZ_e)
	);

endmodule 