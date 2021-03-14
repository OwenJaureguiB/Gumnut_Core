module newPC(
	input logic [3:0] PCoper_i,
	input logic carry_i,
	input logic zero_i,
	input logic [11:0] stackaddr_i,
	input logic [7:0] offset_i,
	input logic [11:0]addr_i,
	input logic [11:0] PC_i,
	input logic [11:0] intPC_i,
	output logic [11:0] PC_o
);

logic [11:0] off; 

always_comb begin
	off = {offset_i[7], offset_i[7], offset_i[7], offset_i[7], offset_i};

	case(PCoper_i)
		4'b0000 : PC_o = PC_i + 1'b1;
		4'b0001 : PC_o = 12'h001;
		4'b0100 : PC_o = (zero_i) ? PC_i + off : PC_i + 1'b1;
		4'b0101 : PC_o = (~zero_i) ? PC_i + off : PC_i + 1'b1;
		4'b0110 : PC_o = (carry_i) ? PC_i + off : PC_i + 1'b1;
		4'b0111 : PC_o = (~carry_i) ? PC_i + off : PC_i + 1'b1;
		4'b1000 : PC_o = addr_i;
		4'b1100 : PC_o = intPC_i;
		4'b1010 : PC_o = stackaddr_i;
		default : PC_o = 12'hxxx;
	endcase
end

endmodule
