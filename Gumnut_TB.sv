`timescale 1ns/1ps

module Gumnut_TB ();
	
	logic       clk_i;
	logic 		ClkEn_e;
	logic 		rst_i;
	logic		   int_req;
	logic 		port_ack_i;
	logic [7:0] port_dat_i;
	
	logic [7:0] port_data_o;
	logic [7:0] port_addr_o;
	logic		   port_we_o;
	logic		   int_ack;
	
	
	Gumnut_Memoria uut (
		.clk_i(clk_i),
		.ClkEn_e(ClkEn_e),
		.rst_i(rst_i),
		.int_req(int_req),
		.port_ack_i(port_ack_),
		.port_dat_i(port_dat_i),
		.port_data_o(port_data_o),
		.port_addr_o(port_addr_o),
		.port_we_o(port_we_o),
		.int_ack(int_ack)
	);
	
	
	initial begin
		rst_i = 1'b1;
		clk_i = 1'b0;
		
		#25;
		
		rst_i = 1'b0;
		ClkEn_e = 1'b1;
		
	end
	
	initial begin
		forever #10 clk_i = !clk_i;
	end
	
endmodule
