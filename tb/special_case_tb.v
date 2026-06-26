`timescale 1ns/1ps

module special_case_tb;

reg [31:0] in;

wire is_zero;
wire is_inf;
wire is_nan;
wire is_subnormal;
wire is_normal;

special_case uut (
    .in(in),
    .is_zero(is_zero),
    .is_inf(is_inf),
    .is_nan(is_nan),
    .is_subnormal(is_subnormal),
    .is_normal(is_normal)
);

initial begin

    $dumpfile("special_case.vcd");
    $dumpvars(0, special_case_tb);

    // Zero
    in = 32'h00000000;
    #10;
    $display("ZERO      : %b %b %b %b %b",
             is_zero,is_inf,is_nan,is_subnormal,is_normal);

    // Infinity
    in = 32'h7F800000;
    #10;
    $display("INFINITY  : %b %b %b %b %b",
             is_zero,is_inf,is_nan,is_subnormal,is_normal);

    // NaN
    in = 32'h7FC00000;
    #10;
    $display("NAN       : %b %b %b %b %b",
             is_zero,is_inf,is_nan,is_subnormal,is_normal);

    // Subnormal
    in = 32'h00000001;
    #10;
    $display("SUBNORMAL : %b %b %b %b %b",
             is_zero,is_inf,is_nan,is_subnormal,is_normal);

    // Normal (1.0)
    in = 32'h3F800000;
    #10;
    $display("NORMAL    : %b %b %b %b %b",
             is_zero,is_inf,is_nan,is_subnormal,is_normal);

    $finish;

end

endmodule
