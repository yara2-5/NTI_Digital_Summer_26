module PISO #(
    parameter WIDTH = 20
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] parallel_in,
    input  wire             en,
    output reg              serial_out,
    output reg              valid
);

    reg [WIDTH-1:0] shift_reg;
    reg [$clog2(WIDTH+1)-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg  <= '0;
            serial_out <= 1'b0;
            valid      <= 1'b0;
            count      <= '0;
        end

        // RAM has provided a new parallel word
        else if (en) begin
            shift_reg  <= parallel_in;
            serial_out <= parallel_in[WIDTH-1];  // MSB first
            valid      <= 1'b1;
            count      <= 1;
        end

        // Continue shifting the current word
        else if (valid) begin
            if (count < WIDTH) begin
                shift_reg  <= {shift_reg[WIDTH-2:0], 1'b0};
                serial_out <= shift_reg[WIDTH-2];
                count      <= count + 1;
            end
            else begin
                shift_reg  <= '0;
                serial_out <= 1'b0;
                valid      <= 1'b0;
                count      <= '0;
            end
        end

        // Nothing to send
        else begin
            serial_out <= 1'b0;
            valid      <= 1'b0;
        end
    end

endmodule
