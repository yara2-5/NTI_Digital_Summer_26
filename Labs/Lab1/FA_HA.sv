module HA (
    input  logic A,
    input  logic B,
    output logic Sum,
    output logic Cout
);

    assign Sum  = A ^ B;
    assign Cout = A & B;

endmodule

module FA_from_HA (
    input  logic A,
    input  logic B,
    input  logic Cin,
    output logic Sum,
    output logic Cout
);
    logic sum1, carry1, carry2;
    HA ha0 (.A(A), .B(B), .Sum(sum1), .Cout(carry1));
    HA ha1 (.A(sum1), .B(Cin), .Sum(Sum), .Cout(carry2));
    assign Cout = carry1 | carry2;

endmodule




