module SIPO #(parameter WIDTH = 20) 
(
    input  wire clk,
    input  wire rst_n,
    input  wire shift_en,
    input  wire serial_in,
    output reg  [WIDTH-1:0] parallel_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        parallel_out <= '0;
    else if (shift_en)
        parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
    else
        parallel_out <= parallel_out;   
end

endmodule
