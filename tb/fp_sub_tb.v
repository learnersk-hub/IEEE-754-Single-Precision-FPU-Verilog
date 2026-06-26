`timescale 1ns/1ps

module fp_sub_tb;

reg [31:0] a;
reg [31:0] b;

wire [31:0] result;

fp_sub uut(
    .a(a),
    .b(b),
    .result(result)
);

initial begin

    $dumpfile("fp_sub.vcd");
    $dumpvars(0,fp_sub_tb);

    // 2 - 1 = 1

    a = 32'h40000000;
    b = 32'h3F800000;

    #20;

    $display("2-1 = %h",result);

    // 2 - (-1) = 3

    a = 32'h40000000;
    b = 32'hBF800000;

    #20;

    $display("2-(-1) = %h",result);

    $finish;

end

endmodule