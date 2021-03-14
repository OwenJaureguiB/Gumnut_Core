module Gumnut_Memoria (
	input  logic        clk_i,
	input  logic 		  ClkEn_e,
	input  logic 		  rst_i,
	input	 logic		  int_req,
	input  logic 		  port_ack_i,
	input  logic [7:0]  port_dat_i,
	output logic [7:0]  port_data_o,
	output logic [7:0]  port_addr_o,
	output logic		  port_we_o,
	output logic		  int_ack
);

	logic [17:0] inst_dat;
	logic [7:0]  data_dat;
	logic 		 inst_ack;
	logic 		 data_ack;
	logic [11:0] inst_addr;
	logic [7:0]  data_data;
	logic [7:0]  data_addr;
	logic		    inst_stb;
	logic		    inst_cyc;
	logic		    data_we;
	logic		    data_stb;
	logic		    data_cyc;

	inst_mem inst (
		.clk_i(clk_i),
		.cyc_i(inst_cyc),
	   .stb_i(inst_stb),
	   .ack_o(inst_ack),
	   .adr_i(inst_addr),
	   .dat_o(inst_dat)
	);
	
	data_mem data (
		.cyc_i(data_cyc),
      .stb_i(data_stb),
      .we_i(data_we),
		.clk_i(clk_i),
      .ack_o(data_ack),
      .adr_i(data_addr),
      .dat_i(data_data),
      .dat_o(data_dat) 
	);
	
	Gumnut_Core (
		.clk_i(clk_i),
		.ClkEn_e(ClkEn_e),
		.rst_i(rst_i),
		.inst_dat_i(inst_dat),
		.data_dat_i(data_dat),
		.port_dat_i(port_dat_i),
		.int_req(int_req),
		.inst_ack_i(inst_ack),
		.data_ack_i(data_ack),
		.port_ack_i(port_ack_i),
		.inst_addr_o(inst_addr),
		.data_data_o(data_data),
		.port_data_o(port_data_o),
		.data_addr_o(data_addr),
		.port_addr_o(port_addr_o),
		.int_ack(int_ack),
		.inst_stb_c(inst_stb),
		.inst_cyc_c(inst_cyc),
		.port_we_o(port_we_o),
		.data_we_c(data_we),
		.data_stb_c(data_stb),
	 	.data_cyc_c(data_cyc)
);

endmodule 