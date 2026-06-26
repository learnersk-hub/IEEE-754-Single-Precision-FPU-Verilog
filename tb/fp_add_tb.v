`timescale 1ns/1ps

module fp_add_tb;

reg [31:0] a;
reg [31:0] b;

wire [31:0] result;

fp_add uut(
    .a(a),
    .b(b),
    .result(result)
);

initial begin

    $dumpfile("fp_add.vcd");
    $dumpvars(0, fp_add_tb);

    // 2.0 - 1.0 = 1.0

    a = 32'h40000000;
    b = 32'hBF800000;

    #20;

    $display("A=%h",a);
    $display("B=%h",b);
    $display("RESULT=%h",result);
// -2 - 4 = -6
a = 32'hC0000000;
b = 32'h40400000;
#20;
$display("-2 + 3 = %h",result);

// Inf + 1 = Inf
a = 32'h7F800000;
b = 32'h3F800000;
#20;
$display("Inf+1 = %h",result);

// Inf + Inf = Inf
a = 32'h7F800000;
b = 32'h7F800000;
#20;
$display("Inf+Inf = %h",result);

// Inf + (-Inf) = NaN
a = 32'h7F800000;
b = 32'hFF800000;
#20;
$display("Inf+(-Inf) = %h",result);

// NaN + 1 = NaN
a = 32'h7FC00000;
b = 32'h3F800000;
#20;
$display("NaN+1 = %h",result);

    $finish;

end

endmodule
