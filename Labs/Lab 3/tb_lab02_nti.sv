module top_1_tb;

    parameter AWIDTH     = $clog2(32);
    parameter DATA_WIDTH = 20;
    parameter WIDTH      = 8;

    reg                   clk;
    reg                   rst_n;
    reg                   wr;
    reg                   rd;
    reg  [AWIDTH-1:0]     addr;
    reg  [DATA_WIDTH-1:0] data_in;
    wire [WIDTH-1:0]      alu_out;
    wire                  a_is_zero;

    top_1 #(
        .AWIDTH(AWIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr(wr),
        .rd(rd),
        .addr(addr),
        .data_in(data_in),
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk;

    // reset task
    task do_reset;
        begin
            rst_n = 0;
            wr    = 0;
            rd    = 0;
            addr  = 0;
            data_in = 0;
            @(posedge clk);
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
    endtask

    // write one word into mem
    task write_mem(input [AWIDTH-1:0] a, input [DATA_WIDTH-1:0] d);
        begin
            @(posedge clk);
            wr      = 1;
            addr    = a;
            data_in = d;
            @(posedge clk);
            wr      = 0;
        end
    endtask

    // read one word from mem (starts PISO -> SIPO -> ALU pipeline)
    task read_mem(input [AWIDTH-1:0] a);
        begin
            @(posedge clk);
            rd   = 1;
            addr = a;
            @(posedge clk);
            rd   = 0;
        end
    endtask

    // wait n clock cycles
    task wait_cycles(input integer n);
        integer i;
        begin
            for (i = 0; i < n; i = i + 1)
                @(posedge clk);
        end
    endtask

    // check alu_out against expected value
    task check_alu(input [WIDTH-1:0] expected);
        begin
            if (alu_out !== expected)
                $display("FAIL: expected alu_out=%0h, got=%0h at time %0t", expected, alu_out, $time);
            else
                $display("PASS: alu_out=%0h at time %0t", alu_out, $time);
        end
    endtask

    initial begin
        do_reset;

        // word format: {alu_en, opcode[2:0], in_a[7:0], in_b[7:0]}
        // example: en=1, opcode=010 (add), in_a=8'h05, in_b=8'h03
        write_mem(0, {1'b1, 3'b010, 8'h05, 8'h03});
        read_mem(0);

        // wait for PISO/SIPO shifting to finish (DATA_WIDTH cycles) plus margin
        wait_cycles(DATA_WIDTH + 2);

        check_alu(8'h08);

        $finish;
    end

endmodule
