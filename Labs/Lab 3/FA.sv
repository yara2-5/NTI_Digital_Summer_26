module FA (
    input  logic A,
    input  logic B,
    input  logic Cin,
    output logic Sum,
    output logic Cout
);

    assign Sum  = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));

endmodule

module FA_parametrized #(parameter WIDTH =8)
(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic Cin,
    output logic [WIDTH-1:0] Sum,
    output logic Cout
);

    logic [WIDTH:0] C;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign Sum[i] = A[i] ^ B[i] ^ C[i];
            assign C[i+1] = (A[i] & B[i]) | (C[i] & (A[i] ^ B[i]));
        end
    endgenerate

    assign Cout = C[WIDTH];

endmodule


