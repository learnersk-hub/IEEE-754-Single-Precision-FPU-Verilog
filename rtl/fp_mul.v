module fp_mul(
    input  [31:0] a,
    input  [31:0] b,

    output reg [31:0] result
);

//-----------------------------------------
// Unpack
//-----------------------------------------

wire sign_a;
wire sign_b;

wire [7:0] exp_a;
wire [7:0] exp_b;

wire [23:0] mant_a;
wire [23:0] mant_b;

unpack ua(
    .in(a),
    .sign(sign_a),
    .exp(exp_a),
    .mant(mant_a)
);

unpack ub(
    .in(b),
    .sign(sign_b),
    .exp(exp_b),
    .mant(mant_b)
);

//-----------------------------------------
// Special Cases
//-----------------------------------------

wire is_zero_a;
wire is_inf_a;
wire is_nan_a;
wire is_subnormal_a;
wire is_normal_a;

wire is_zero_b;
wire is_inf_b;
wire is_nan_b;
wire is_subnormal_b;
wire is_normal_b;

special_case sca(
    .in(a),
    .is_zero(is_zero_a),
    .is_inf(is_inf_a),
    .is_nan(is_nan_a),
    .is_subnormal(is_subnormal_a),
    .is_normal(is_normal_a)
);

special_case scb(
    .in(b),
    .is_zero(is_zero_b),
    .is_inf(is_inf_b),
    .is_nan(is_nan_b),
    .is_subnormal(is_subnormal_b),
    .is_normal(is_normal_b)
);

//-----------------------------------------
// Core Multiply
//-----------------------------------------

wire sign_result;

assign sign_result = sign_a ^ sign_b;

wire [47:0] product;

assign product = mant_a * mant_b;

reg [7:0] exp_result;
reg [22:0] frac_result;

always @(*) begin

    if(product[47]) begin
        exp_result  = exp_a + exp_b - 8'd127 + 1;
        frac_result = product[46:24];
    end
    else begin
        exp_result  = exp_a + exp_b - 8'd127;
        frac_result = product[45:23];
    end

    //-----------------------------------------
    // Special Case Handling
    //-----------------------------------------

    // NaN

    if(is_nan_a || is_nan_b)
        result = 32'h7FC00000;

    // Inf × 0 = NaN

    else if((is_inf_a && is_zero_b) ||
            (is_inf_b && is_zero_a))
        result = 32'h7FC00000;

    // Infinity

    else if(is_inf_a || is_inf_b)
        result = {
            sign_result,
            8'hFF,
            23'd0
        };

    // Zero

    else if(is_zero_a || is_zero_b)
        result = {
            sign_result,
            8'd0,
            23'd0
        };

    // Normal Result

    else
        result = {
            sign_result,
            exp_result,
            frac_result
        };

end

endmodule