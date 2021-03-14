module Control_Unit (
	input  logic [6:0] op_i,
	input  logic [2:0] func_i,
	input  logic   	 inst_ack_i,
	input  logic		 int_i,
	input  logic       data_ack_i,
	input  logic       port_ack_i,
	input  logic       clk,
	input  logic		 rst,
	output logic 		 op2_o,
	output logic [3:0] ALUOp_o,
	output logic 		 ALUFR_o,
	output logic 		 ALUEn_o,
	output logic 		 RegWrt_o,
	output logic [1:0] RegMux_o,
	output logic 		 PCEn_o,
	output logic [3:0] PCoper_o,
	output logic       ret_o,
	output logic 		 jsb_o,
	output logic 		 reti_o,
	output logic       int_o,
	output logic 		 stb_o,
	output logic 		 cyc_o,
	output logic 		 data_we_o,
	output logic 		 data_stb_o,
	output logic 		 data_cyc_o,
	output logic 		 int_ack,
	output logic       StmMux_o
);

	parameter fetch_state		= 3'h0;
	parameter decode_state		= 3'h1;
	parameter int_state			= 3'h2;
	parameter execute_state		= 3'h3;
	parameter mem_state			= 3'h4;
	parameter write_back_state	= 3'h5;
	
	logic [2:0] state;
	logic [2:0] nxt_state;
	logic 		alu_immed;
	logic 		mem;
	logic 		shift;
	logic 		alu_reg;
	logic 		jump;
	logic 		branch;
	logic 		misc;
	logic 		ldm;
	logic 		stm;
	logic 		inp;
	logic 		out;
	logic 		wait_;
	logic 		stby;
	logic 		intEn = 1'b0;
	logic 		intEn_;
	logic 		intReg;
	logic       intClk;
	
	always_ff @(posedge clk or posedge rst) begin
		if(rst) state <= fetch_state;
		else    state <= nxt_state;
	end
	
	always_ff @(posedge intClk or posedge rst) begin
		if(rst) intEn <= 1'b0;
		else    intEn <= intEn_;
	end
	
	always_comb begin
		alu_immed = op_i[6]     == 1'b0;
		mem	 	 = op_i[6:5]   == 2'b10;
		shift	    = op_i[6:4]   == 3'b110;
		alu_reg   = op_i[6:3]   == 7'b1110;
		jump	 	 = op_i[6:2]   == 7'b11110;
		branch 	 = op_i[6:1]   == 7'b111110;
		misc	 	 = op_i        == 7'b1111110;
		ldm   	 = func_i[1:0] == 2'h0;
		stm   	 = func_i[1:0] == 2'h1;
		inp   	 = func_i[1:0] == 2'h2;
		out   	 = func_i[1:0] == 2'h3;
		wait_ 	 = func_i	   == 3'h4;
		stby   	 = func_i 	   == 3'h5;
		intClk    = intReg & clk;
	
		case (state)
			fetch_state: begin
				if(~inst_ack_i) 
					nxt_state = fetch_state;
				else				 
					nxt_state = decode_state;
			end
			decode_state: begin
				if((int_i & intEn) & (branch | jump | misc))
					nxt_state = int_state;
				else if(misc & (wait_ | stby) & ~(int_i & intEn))
					nxt_state = decode_state;
				else if (alu_immed | alu_reg | shift | mem)
					nxt_state = execute_state;
				else
					nxt_state = fetch_state;
			end
			int_state: nxt_state = fetch_state;
			execute_state: begin
				if ((int_i & intEn) & mem & ((stm & data_ack_i) | (out & port_ack_i)))
					nxt_state = int_state;
				else if (~(int_i & intEn) & mem & ((stm & data_ack_i) | (out & port_ack_i)))
					nxt_state = fetch_state;
				else if ((mem & ((ldm & data_ack_i)|(inp & port_ack_i))) | ~mem)
					nxt_state = write_back_state;
				else 
					nxt_state = mem_state;
			end
			write_back_state: begin
				if (int_i & intEn)
					nxt_state = int_state;
				else 
					nxt_state = fetch_state;
			end
			mem_state: begin
				if (((stm & data_ack_i) | (out & port_ack_i)) & (int_i & intEn))
					nxt_state = int_state;
				else if (((stm & data_ack_i) | (out & port_ack_i)) & ~(int_i & intEn))
					nxt_state = fetch_state;
				else if ((ldm & data_ack_i) | (inp & port_ack_i))
					nxt_state = write_back_state;
				else 
					nxt_state = mem_state;
			end
			default: nxt_state = 3'hx;
		endcase 
		
		case (state)
			fetch_state: begin
				int_ack    = 1'b0;
				op2_o      = 1'bz;
				ALUOp_o    = 4'hz;
				ALUFR_o    = 1'b0;
				ALUEn_o    = 1'b0;
				RegWrt_o   = 1'b0;
				RegMux_o   = 2'hz;
				PCEn_o     = 1'b0;
				PCoper_o   = 4'hz;
				ret_o      = 1'b0;
				jsb_o      = 1'b0;
				reti_o     = 1'b0;
				int_o      = 1'b0;
				stb_o      = 1'b1;
				cyc_o      = 1'b1;
				data_we_o  = 1'b0;
				data_stb_o = 1'b0;
				data_cyc_o = 1'b0;
				intEn_     = 1'bz;
				intReg     = 1'b0;
				StmMux_o   = 1'bz;
			end
			decode_state: begin
				int_ack	  = 1'b0;
				stb_o 	  = 1'b0;
				cyc_o  	  = 1'b0;
				op2_o      = 1'bz;
				ALUOp_o    = 4'hz;
				ALUFR_o    = 1'b0;
				ALUEn_o    = 1'b0;
				RegWrt_o   = 1'b0;
				RegMux_o   = 2'hz;
				int_o      = 1'b0;
				data_we_o  = 1'b0;
				data_stb_o = 1'b0;
				data_cyc_o = 1'b0;
				StmMux_o   = 1'bz;
				if (~(branch | jump | (misc & ~func_i[1]))) begin
					PCoper_o = 4'h0;
					PCEn_o   = 1'b1;
					jsb_o    = 1'b0;
					ret_o    = 1'b0;
					intEn_	= ~func_i[0];
					reti_o   = 1'b0;
					intReg   = misc;
				end
				else if (branch) begin
					PCoper_o = {2'b01, func_i[1:0]};
					PCEn_o   = 1'b1;
					jsb_o    = 1'b0;
					ret_o    = 1'b0;
					intEn_   = 1'bz;
					reti_o   = 1'b0;
					intReg   = 1'b0;
				end
				else if (jump) begin
					PCoper_o = 4'h8;
					PCEn_o   = 1'b1;
					jsb_o    = func_i[0];
					ret_o    = 1'b0;
					intEn_   = 1'bz;
					reti_o   = 1'b0;
					intReg   = 1'b0;
				end 
				else if (func_i[2:0] == 3'h0) begin
					PCoper_o = 4'hA;
					PCEn_o   = 1'b1;
					jsb_o    = 1'b0;
					ret_o    = 1'b1;
					intEn_   = 1'bz;
					reti_o   = 1'b0;
					intReg   = 1'b0;
				end
				else if (func_i[2:0] == 3'h1) begin
					PCoper_o = 4'hC;
					PCEn_o   = 1'b1;
					jsb_o    = 1'b0;
					ret_o    = 1'b0;
					intEn_   = 1'b1;
					reti_o   = 1'b1;
					intReg   = 1'b1;
				end
				else begin
					PCoper_o = 4'hz;
					PCEn_o   = 1'b0;
					jsb_o    = 1'b0;
					ret_o    = 1'b0;
					intEn_   = 1'bz;
					reti_o   = 1'b0;
					intReg   = 1'b0;
				end
			end
			int_state: begin
				op2_o      = 1'bz;
				ALUOp_o    = 4'hz;
				PCEn_o     = 1'b1;
				PCoper_o   = 4'h1;
				ret_o      = 1'b0;
				jsb_o      = 1'b0;
				intEn_     = 1'b0;
				intReg     = 1'b1;
				int_o      = 1'b1;
				int_ack    = 1'b1;
				ALUFR_o    = 1'b0;
				ALUEn_o    = 1'b0;
				RegWrt_o   = 1'b0;
				RegMux_o   = 2'hz;
				reti_o     = 1'b0;
				stb_o      = 1'b0;
				cyc_o		  = 1'b0;
				data_we_o  = 1'b0;
				data_stb_o = 1'b0;
				data_cyc_o = 1'b0;
				StmMux_o   = 1'bz;
			end
			execute_state: begin
				int_ack    = 1'b0;
				op2_o   	  = alu_immed | mem;
				if (mem)
					ALUOp_o = 4'h1;
				else if (shift)
					ALUOp_o = {2'b10,func_i[1:0]};
				else
					ALUOp_o = {1'b0, func_i};
				ALUFR_o    = ~mem;
				ALUEn_o    = ~mem;
				RegWrt_o   = 1'b0;
				RegMux_o   = 2'hz;
				PCEn_o     = 1'b0;
				PCoper_o   = 4'hz;
				ret_o      = 1'b0;
				jsb_o		  = 1'b0;
				reti_o  	  = 1'b0;
				int_o		  = 1'b0;
				stb_o		  = 1'b0;
				cyc_o		  = 1'b0;
				data_we_o  = mem & (stm | out);
				data_stb_o = mem;
				data_cyc_o = mem;
				intEn_     = 1'bz;
				intReg     = 1'b0;
				StmMux_o   = mem & (stm | out);
			end
			write_back_state: begin
				int_ack	  = 1'b0;
				op2_o		  = alu_immed | mem;
				ALUOp_o	  = (mem)?4'h1:4'hz;
				ALUFR_o    = 1'b0;
				ALUEn_o    = 1'b0;
				RegWrt_o   = 1'b1;
				if (mem & inp)
					RegMux_o = 2'h2;
				else if (mem)
					RegMux_o = 2'h1;
				else
					RegMux_o = 2'h0;
				PCEn_o 	  = 1'b0;
				PCoper_o	  = 4'hz;
				ret_o      = 1'b0;
				jsb_o		  = 1'b0;
				reti_o  	  = 1'b0;
				int_o		  = 1'b0;
				stb_o		  = 1'b0;
				cyc_o		  = 1'b0;
				data_we_o  = 1'b0;
				data_stb_o = mem;
				data_cyc_o = mem;
				intEn_     = 1'bz;
				intReg     = 1'b0;
				StmMux_o   = 1'b0;
			end
			mem_state: begin
				int_ack    = 1'b0;
				op2_o   	  = 1'b1;
				ALUOp_o    = 4'h1;
				ALUFR_o    = 1'b0;
				ALUEn_o    = 1'b0;
				RegWrt_o   = 1'b0;
				RegMux_o   = 2'h0;
				PCEn_o     = 1'b0;
				PCoper_o   = 4'hz;
				ret_o      = 1'b0;
				jsb_o		  = 1'b0;
				reti_o  	  = 1'b0;
				int_o		  = 1'b0;
				stb_o		  = 1'b0;
				cyc_o		  = 1'b0;
				data_we_o  = stm | out;
				data_stb_o = 1'b1;
				data_cyc_o = 1'b1;
				intEn_     = 1'bz;
				intReg     = 1'b0;
				StmMux_o   = stm | out;
			end
			default: begin
				int_ack    = 1'bx;
				op2_o      = 1'bx;
				ALUOp_o    = 1'bx;
				ALUFR_o    = 1'bx;
				ALUEn_o    = 1'bx;
				RegWrt_o   = 1'bx;
				RegMux_o   = 1'bx;
				PCEn_o     = 1'bx;
				PCoper_o   = 1'bx;
				ret_o      = 1'bx;
				jsb_o      = 1'bx;
				reti_o     = 1'bx;
				int_o      = 1'bx;
				stb_o      = 1'bx;
				cyc_o      = 1'bx;
				data_we_o  = 1'bx;
				data_stb_o = 1'bx;
				data_cyc_o = 1'bx;
				intEn_     = 1'bx;
				intReg     = 1'bx;
			end
		endcase
	end
endmodule 