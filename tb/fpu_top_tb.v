`timescale 1ns/1ps

module fpu_top_tb;

reg [31:0] a;
reg [31:0] b;
reg [1:0] op;

wire [31:0] result;

fpu_top uut(
    .a(a),
    .b(b),
    .op(op),
    .result(result)
);

initial begin

    $dumpfile("fpu_top.vcd");
    $dumpvars(0,fpu_top_tb);

    $display("\n========== ADD ==========");

    op = 2'b00;

    a = 32'h40000000; b = 32'h3F800000; #20;
    $display("2 + 1        = %h", result);

    a = 32'h40000000; b = 32'hBF800000; #20;
    $display("2 + (-1)     = %h", result);

    a = 32'h7F800000; b = 32'h7F800000; #20;
    $display("Inf + Inf    = %h", result);

    a = 32'h7F800000; b = 32'hFF800000; #20;
    $display("Inf + -Inf   = %h", result);

    a = 32'h7FC00000; b = 32'h3F800000; #20;
    $display("NaN + 1      = %h", result);

    $display("\n========== SUB ==========");

    op = 2'b01;

    a = 32'h40000000; b = 32'h3F800000; #20;
    $display("2 - 1        = %h", result);

    a = 32'h40000000; b = 32'hBF800000; #20;
    $display("2 - (-1)     = %h", result);

    $display("\n========== MUL ==========");

    op = 2'b10;

    a = 32'h40000000; b = 32'h40800000; #20;
    $display("2 * 4        = %h", result);

    a = 32'hC0000000; b = 32'h40800000; #20;
    $display("-2 * 4       = %h", result);

    a = 32'h7F800000; b = 32'h00000000; #20;
    $display("Inf * 0      = %h", result);

    a = 32'h7FC00000; b = 32'h3F800000; #20;
    $display("NaN * 1      = %h", result);

    $display("\n========== DIV ==========");

    op = 2'b11;

    a = 32'h41000000; b = 32'h40000000; #20;
    $display("8 / 2        = %h", result);

    a = 32'hC1000000; b = 32'h40000000; #20;
    $display("-8 / 2       = %h", result);

    a = 32'h40A00000; b = 32'h00000000; #20;
    $display("5 / 0        = %h", result);

    a = 32'h00000000; b = 32'h00000000; #20;
    $display("0 / 0        = %h", result);

    a = 32'h7F800000; b = 32'h7F800000; #20;
    $display("Inf / Inf    = %h", result);

    a = 32'h40000000; b = 32'h7F800000; #20;
    $display("2 / Inf      = %h", result);

    $display("\n==============================");
    $display("      ALL TESTS COMPLETED");
    $display("==============================");

    $finish;

end

endmodule