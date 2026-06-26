`timescale 1ns/1ps

module fp_mul_tb;

reg [31:0] a;
reg [31:0] b;

wire [31:0] result;

fp_mul uut(
    .a(a),
    .b(b),
    .result(result)
);

initial begin

    $dumpfile("fp_mul.vcd");
    $dumpvars(0,fp_mul_tb);

// 0 × 5 = 0
a = 32'h00000000;
b = 32'h40A00000;
#20;
$display("0*5 = %h",result);

// Inf × 2 = Inf
a = 32'h7F800000;
b = 32'h40000000;
#20;
$display("Inf*2 = %h",result);

// Inf × 0 = NaN
a = 32'h7F800000;
b = 32'h00000000;
#20;
$display("Inf*0 = %h",result);

// NaN × 1 = NaN
a = 32'h7FC00000;
b = 32'h3F800000;
#20;
$display("NaN*1 = %h",result);




    // 2 × 4 = 8

    a = 32'h40000000;
    b = 32'h40800000;

    #20;

    $display("2*4 = %h",result);

    // -2 × 4 = -8

    a = 32'hC0000000;
    b = 32'h40800000;

    #20;

    $display("-2*4 = %h",result);

    $finish;

end

endmodule
