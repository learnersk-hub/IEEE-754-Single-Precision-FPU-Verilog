module special_case(
    input  [31:0] in,

    output is_zero,
    output is_inf,
    output is_nan,
    output is_subnormal,
    output is_normal
);

wire [7:0] exp;
wire [22:0] frac;

assign exp  = in[30:23];
assign frac = in[22:0];

assign is_zero      = (exp == 8'h00) && (frac == 23'h000000);
assign is_inf       = (exp == 8'hFF) && (frac == 23'h000000);
assign is_nan       = (exp == 8'hFF) && (frac != 23'h000000);
assign is_subnormal = (exp == 8'h00) && (frac != 23'h000000);
assign is_normal    = (exp != 8'h00) && (exp != 8'hFF);

endmodule
