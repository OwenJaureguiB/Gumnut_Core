module PC_Unit (
	input  logic  		  clk_i,
	input  logic		  ClkEn_e,
	input  logic 		  rst_i,
	input  logic [3:0]  PCoper_c,
	input  logic		  PCEn_c,
	input  logic  		  push_c,
	input  logic 	     pop_c,
	input  logic 		  ccC_e,
	input  logic 		  ccZ_e,
	input  logic 		  int_c,
	input  logic [7:0]  disp_e,
	input  logic [11:0] addr_e,
	output logic [11:0] inst_addr_o,
	output logic 	     intz_o,
	output logic 		  intc_o
);

	logic [11:0] PC_e;
	logic [11:0] stk_e;
	logic [11:0] intPC;
	logic [11:0] PCnew_e;
	
	newPC NewPC (
		.PCoper_i(PCoper_c),
		.carry_i(ccC_e),
		.zero_i(ccZ_e),
		.stackaddr_i(stk_e),
		.intPC_i(intPC),
		.offset_i(disp_e),
		.addr_i(addr_e),
		.PC_i(PC_e),
		.PC_o(PCnew_e)
	);
	
	ProgCounter PC (
		.PC_i(PCnew_e),
		.we(PCEn_c),
		.PC_o(PC_e),
		.clk(clk_i),
		.cen(ClkEn_e),
		.rst(rst_i)
	);
	
	IntReg IntR (
		.pc_o(intPC),
		.c_i(ccC_e),
		.z_i(ccZ_e),
		.we(int_c),
		.pc_i(PC_e),
		.intc_o(intc_o),
		.intz_o(intz_o),
		.clk(clk_i),
		.cen(ClkEn_e),
		.rst(rst_i)
	);
	
	Stack stack (
		.pc_i(PC_e),
		.pop_i(pop_c),
		.push_i(push_c),
		.pc_o(stk_e),
		.clk(clk_i),
		.cen(ClkEn_e),
		.rst(rst_i)
	);
	
	always_comb inst_addr_o = PC_e;

endmodule 