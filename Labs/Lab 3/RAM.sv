module mem #(parameter AWIDTH = $clog2(32),
					   ram_DEPTH = 2**AWIDTH,
					   DWIDTH = 8
) (

	// inputs
	input wire clk,
	input wire rst_n,
	input wire wr,
	input wire rd,
	input wire [AWIDTH-1:0] addr,
	input wire [DWIDTH-1:0] data_in,

	// outputs
	output reg Valid,
	output reg [DWIDTH-1:0] data_out

);

reg [DWIDTH-1:0] ram [0:ram_DEPTH-1];

integer i;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i< ram_DEPTH ; i = i + 1)begin
			ram[i] <='b0;
		end

		data_out <= 'b0;
		Valid 	 <= 1'b0;
	end
	else if (wr) begin
		ram[addr] <= data_in;
		Valid 	 <= 1'b0;
	end
	else if (rd) begin
		data_out <= ram[addr];
		Valid <= 1'b1;
	end
	else begin
		Valid <= 1'b0;
	end
end



endmodule
