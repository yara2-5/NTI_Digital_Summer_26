module top_1 #(
    parameter AWIDTH = $clog2(32),
    parameter ram_DEPTH = 2**AWIDTH,
    parameter DATA_WIDTH = 20,
    parameter WIDTH = 8
) (
    // inputs
    input wire                  clk,
    input wire                  rst_n,
    input wire                  wr,
    input wire                  rd,
    input wire [AWIDTH-1:0]     addr,
    input wire [DATA_WIDTH-1:0] data_in,

    // outputs
    output logic [WIDTH-1:0]    alu_out,
    output logic                a_is_zero
);

    wire [DATA_WIDTH-1:0] ram_data_out;
    wire ram_valid;

    wire piso_serial_out;
    wire piso_valid;

    wire [DATA_WIDTH-1:0] sipo_parallel_out;

    wire [WIDTH-1:0] alu_in_a;
    wire [WIDTH-1:0] alu_in_b;
    wire [2:0] alu_opcode;
    wire alu_en;

    mem #(
        .AWIDTH(AWIDTH),
        .ram_DEPTH(ram_DEPTH),
        .DWIDTH(DATA_WIDTH)
    ) ram_inst (
        .clk(clk),
        .rst_n(rst_n),
        .wr(wr),
        .rd(rd),
        .addr(addr),
        .data_in(data_in),
        .Valid(ram_valid),
        .data_out(ram_data_out)
    );


    PISO #(
        .WIDTH(DATA_WIDTH)
    ) piso_inst (
        .clk(clk),
        .rst_n(rst_n),
        .parallel_in(ram_data_out),
        .en(ram_valid),
        .serial_out(piso_serial_out),
        .valid(piso_valid)
    );


    SIPO #(
        .WIDTH(DATA_WIDTH)
    ) sipo_inst (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(piso_valid),
        .serial_in(piso_serial_out),
        .parallel_out(sipo_parallel_out)
    );

    assign alu_en     = sipo_parallel_out[19];
    assign alu_opcode = sipo_parallel_out[18:16];
    assign alu_in_a   = sipo_parallel_out[15:8];
    assign alu_in_b   = sipo_parallel_out[7:0];


    alu #(
        .WIDTH(WIDTH)
    ) alu_inst (
        .alu_en(alu_en),
        .in_a(alu_in_a),
        .in_b(alu_in_b),
        .opcode(alu_opcode),
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );

endmodule


