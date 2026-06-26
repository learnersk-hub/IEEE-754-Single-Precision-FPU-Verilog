`timescale 1ns/1ps

module fp_div_tb;

reg [31:0] a;
reg [31:0] b;

wire [31:0] result;

fp_div uut(
    .a(a),
    .b(b),
    .result(result)
);

initial begin

    $dumpfile("fp_div.vcd");
    $dumpvars(0,fp_div_tb);

    // 8 / 2 = 4

    a = 32'h41000000;
    b = 32'h40000000;

    #20;

    $display("8/2 = %h",result);



    // -8 / 2 = -4

    a = 32'hC1000000;
    b = 32'h40000000;

    #20;

    $display("-8/2 = %h",result);


// 0 / 5 = 0
a = 32'h00000000;
b = 32'h40A00000;
#20;
$display("0/5 = %h",result);

// 5 / 0 = Inf
a = 32'h40A00000;
b = 32'h00000000;
#20;
$display("5/0 = %h",result);

// Inf / 2 = Inf
a = 32'h7F800000;
b = 32'h40000000;
#20;
$display("Inf/2 = %h",result);

// 2 / Inf = 0
a = 32'h40000000;
b = 32'h7F800000;
#20;
$display("2/Inf = %h",result);

// Inf / Inf = NaN
a = 32'h7F800000;
b = 32'h7F800000;
#20;
$display("Inf/Inf = %h",result);

// 0 / 0 = NaN
a = 32'h00000000;
b = 32'h00000000;
#20;
$display("0/0 = %h",result);

// NaN / 2 = NaN
a = 32'h7FC00000;
b = 32'h40000000;
#20;
$display("NaN/2 = %h",result);

    $finish;

end

endmodule
