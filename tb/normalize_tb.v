`timescale 1ns/1ps

module normalize_tb;

reg [24:0] mant_in;
reg [7:0] exp_in;

wire [23:0] mant_out;
wire [7:0] exp_out;

normalize uut(
    .mant_in(mant_in),
    .exp_in(exp_in),
    .mant_out(mant_out),
    .exp_out(exp_out)
);

initial begin

    $dumpfile("normalize.vcd");
    $dumpvars(0,normalize_tb);

    // Overflow
    mant_in = 25'h1800000;
    exp_in  = 8'd127;
    #10;
    $display("Overflow : Mant=%h Exp=%d",mant_out,exp_out);

    // Zero
    mant_in = 25'd0;
    exp_in  = 8'd127;
    #10;
    $display("Zero     : Mant=%h Exp=%d",mant_out,exp_out);

    // Already normalized
    mant_in = 25'h0800000;
    exp_in  = 8'd130;
    #10;
    $display("Normal   : Mant=%h Exp=%d",mant_out,exp_out);

    // Needs left shift
    mant_in = 25'h0400000;
    exp_in  = 8'd130;
    #10;
    $display("Shift1   : Mant=%h Exp=%d",mant_out,exp_out);

    // Needs multiple shifts
    mant_in = 25'h0100000;
    exp_in  = 8'd130;
    #10;
    $display("Shift2   : Mant=%h Exp=%d",mant_out,exp_out);

    $finish;

end

endmodule
