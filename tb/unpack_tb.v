`timescale 1ns/1ps

module unpack_tb;

reg  [31:0] in;

wire        sign;
wire [7:0]  exp;
wire [23:0] mant;

unpack uut (
    .in(in),
    .sign(sign),
    .exp(exp),
    .mant(mant)
);

initial begin

    $dumpfile("unpack.vcd");
    $dumpvars(0, unpack_tb);

    // 1.0
    in = 32'h3F800000;
    #10;
    $display("Input=%h Sign=%b Exp=%h Mant=%h",
              in, sign, exp, mant);

    // 2.0
    in = 32'h40000000;
    #10;
    $display("Input=%h Sign=%b Exp=%h Mant=%h",
              in, sign, exp, mant);

    // -1.0
    in = 32'hBF800000;
    #10;
    $display("Input=%h Sign=%b Exp=%h Mant=%h",
              in, sign, exp, mant);

    $finish;

end

endmodule
