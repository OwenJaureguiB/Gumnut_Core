module Stack (
	input  logic		  push_i,
	input  logic		  pop_i,
	input  logic	     clk,
	input  logic		  cen,
	input  logic		  rst,
	input  logic [11:0] pc_i,
	output logic [11:0] pc_o
);

	logic [11:0] stack_reg [7:0];
	logic [2:0]  current 		  = 3'h0;
	logic 		 stkClk;
	logic 		 stkOv;
	logic [2:0]  read;
	int 			 i;
	
	always_ff @(posedge stkClk or posedge rst)
	begin
		if (rst) begin
			pc_o	  <= 12'h000;
			current <= 3'h0;
		end
		else if (push_i) begin
			{stkOv, current}	 <= current + 1'b1;
			stack_reg[current] <= pc_i;
			pc_o 					 <= pc_i;
		end
		else if (pop_i) begin
			{stkOv, current}   <= read;
			pc_o 					 <= stack_reg[read];
		end
		else
			pc_o <= stack_reg[read];
	end
	
	always_comb begin
	   stkClk = clk  & cen;
		{stkOv, read}   = current - 1'b1;
	end

endmodule 