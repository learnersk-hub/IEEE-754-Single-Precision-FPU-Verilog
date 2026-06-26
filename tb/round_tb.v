`timescale 1ns/1ps

module round_tb;

reg [23:0] mant_in;
reg [7:0]  exp_in;

reg guard;
reg round_bit;
reg sticky;

wire [23:0] mant_out;
wire [7:0] exp_out;

round uut(
    .mant_in(mant_in),
    .exp_in(exp_in),
    .guard(guard),
    .round_bit(round_bit),
    .sticky(sticky),
    .mant_out(mant_out),
    .exp_out(exp_out)
);

initial begin

    $dumpfile("round.vcd");
    $dumpvars(0,round_tb);

    // No rounding
    mant_in = 24'h800000;
    exp_in  = 8'd127;
    guard = 0;
    round_bit = 0;
    sticky = 0;
    #10;
    $display("Case1 Mant=%h Exp=%d",mant_out,exp_out);

    // Round up
    mant_in = 24'h800000;
    exp_in  = 8'd127;
    guard = 1;
    round_bit = 1;
    sticky = 0;
    #10;
    $display("Case2 Mant=%h Exp=%d",mant_out,exp_out);

    // Tie to even
    mant_in = 24'h800001;
    exp_in  = 8'd127;
    guard = 1;
    round_bit = 0;
    sticky = 0;
    #10;
    $display("Case3 Mant=%h Exp=%d",mant_out,exp_out);

    // Mantissa overflow after rounding
    mant_in = 24'hFFFFFF;
    exp_in  = 8'd127;
    guard = 1;
    round_bit = 1;
    sticky = 1;
    #10;
    $display("Case4 Mant=%h Exp=%d",mant_out,exp_out);

    $finish;

end

endmodule