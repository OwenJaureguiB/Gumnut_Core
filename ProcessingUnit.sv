module ProcessingUnit (
	input  logic					clk_i,
	input  logic				 ClkEn_e,
	input  logic					rst_i,
	input  logic				RegWrt_c,
	input  logic [17:0] 	 inst_dat_i,
	input  logic			 inst_ack_i,
	input  logic  [7:0]	 data_dat_i,
	input  logic  [7:0]	 port_dat_i,
	input  logic  [1:0]		RegMux_c,
	input	 logic   			 DPMux_c,
	input  logic					op2_c,
	input  logic  [3:0]		 ALUOp_c,
	input  logic				 ALUEn_c,
	input  logic 			  port_we_c,
	input  logic				 ALUFR_c,
	input	 logic				  reti_c,
	input	 logic				  intz_i,
	input	 logic				  intc_i,	
	output logic  [6:0]	 		 op_e,
	output logic  [2:0]		  func_e,
	output logic [11:0]	 	  addr_e,
	output logic  [7:0]	 	  disp_e,
	output logic  [7:0]	  port_we_o,
	output logic  [7:0]	port_data_o,
	output logic  [7:0]	port_addr_o,
	output logic  [7:0] 		  addr_i,
	output logic  [7:0]			dat_i,
	output logic					ccC_e,
	output logic					ccZ_e
);

	logic [2:0]		rs_e;
	logic [2:0]	rs2_aux;
	logic [2:0]	  rs2_e;
	logic [2:0]		rd_e;
	logic [7:0]   dat_e;
	logic [7:0] immed_e;
	logic [2:0]	count_e;
	logic [7:0]   ALU_i;
	logic [7:0]	  ALU_e;
	
	logic [7:0]	  rsr_e;
	logic [7:0]	 rsr2_e;
	logic [7:0]	  op2_e;
	
	logic [7:0] port_dat_e;
	logic [7:0] data_dat_e;
	
	
	logic carry_e;
	logic zero_e;
	logic cc_i;
	
	IR ir (
		.clk(clk_i),
		.cen(ClkEn_e),
		.rst(rst_i),
		.inst_e(inst_dat_i),
		.we(inst_ack_i),
		.op_o(op_e),
		.func_o(func_e),
		.addr_o(addr_e),
		.disp_o(disp_e),
		.rs_o(rs_e),
		.rs2_o(rs2_aux),
		.rd_o(rd_e),
		.immed_o(immed_e),
		.count_o(count_e)
	);
	
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
			data_dat_e <= 8'hxx;
			port_dat_e <= 8'hxx;
		end
		else if (ClkEn_e) begin
			data_dat_e <= data_dat_i;
			port_dat_e <= port_dat_i;
		end
	end
	
	always_comb begin
		case (RegMux_c)
			2'b00 : dat_e = ALU_e;
			2'b01 : dat_e = data_dat_e;
			2'b10 : dat_e = port_dat_e;
			2'b11 : dat_e = 8'hxx;
			default: dat_e = 8'hxx;
		endcase
		rs2_e = (DPMux_c) ? rd_e : rs2_aux;
	end
	
	Registers RegisterBank (
		.clk(clk_i),
		.cen(ClkEn_e),
		.rst(rst_i),
		.we(RegWrt_c),
		.rs_i(rs_e),
		.rs2_i(rs2_e),
		.rd_i(rd_e),
		.dat_i(dat_e),
		.rs_o(rsr_e),
		.rs2_o(rsr2_e)
	);
	
	always_comb op2_e = (op2_c) ? immed_e : rsr2_e;
	
	always_ff @(posedge clk_i) begin
		if (rst_i)
			ALU_e <= 8'hxx;
		else if (ALUEn_c)
			ALU_e <= ALU_i;
	end
	
	always_ff @(posedge clk_i) begin
		if (rst_i)
			port_we_o <= 1'b0;
		else
			port_we_o <= port_we_c;
	end
	
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
			port_data_o <= 8'h00;
			port_addr_o <= 8'h00;
		end
		else if (port_we_c) begin
			port_data_o <= rs2_e;
			port_addr_o <= ALU_i;
		end
	end
	
	always_comb begin
		addr_i = ALU_i;
		dat_i  = rs2_e;
	end
			
	ALU alu (
		.rs_i(rsr_e),
		.op2_i(op2_e),
		.count_i(count_e),
		.carry_i(cc_i),
		.ALUOp_i(ALUOp_c),
		.zero_o(zero_e),
		.carry_o(carry_e),
		.res_o(ALU_i)
	);
	
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
			ccC_e <= 1'b0;
			ccZ_e <= 1'b0;
		end
		else if (ALUFR_c) begin
			ccC_e <= carry_e;
			ccZ_e <= zero_e;
		end
		else if (reti_c) begin
			ccC_e <= intc_i;
			ccZ_e <= intz_i;
		end
	end
	
	always_comb cc_i = ccC_e;
	
endmodule
