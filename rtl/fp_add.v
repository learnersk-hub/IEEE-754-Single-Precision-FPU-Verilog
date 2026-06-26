module fp_add(
    input  [31:0] a,
    input  [31:0] b,

    output reg [31:0] result
);

//--------------------------------------------------
// Unpack operands
//--------------------------------------------------

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

//--------------------------------------------------
// Special case detection
//--------------------------------------------------

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

//--------------------------------------------------
// Arithmetic core
//--------------------------------------------------

reg [23:0] mant_big;
reg [23:0] mant_small;

reg [7:0] exp_big;
reg sign_result;

reg [24:0] mant_result;

integer shift;

always @(*) begin

    mant_big    = 0;
    mant_small  = 0;
    exp_big     = 0;
    sign_result = 0;
    mant_result = 0;
    shift       = 0;

    // Exponent alignment

    if(exp_a >= exp_b) begin

        shift      = exp_a - exp_b;
        exp_big    = exp_a;

        mant_big   = mant_a;
        mant_small = mant_b >> shift;

        sign_result = sign_a;

    end
    else begin

        shift      = exp_b - exp_a;
        exp_big    = exp_b;

        mant_big   = mant_b;
        mant_small = mant_a >> shift;

        sign_result = sign_b;

    end

    // Same sign => Add

    if(sign_a == sign_b) begin

        mant_result = mant_big + mant_small;
        sign_result = sign_a;

    end

    // Different signs => Subtract

    else begin

        if(mant_big >= mant_small) begin

            mant_result = mant_big - mant_small;

        end
        else begin

            mant_result = mant_small - mant_big;
            sign_result = ~sign_result;

        end

    end

end

//--------------------------------------------------
// Normalize
//--------------------------------------------------

wire [23:0] norm_mant;
wire [7:0]  norm_exp;

normalize unorm(
    .mant_in(mant_result),
    .exp_in(exp_big),
    .mant_out(norm_mant),
    .exp_out(norm_exp)
);

//--------------------------------------------------
// Final result generation
//--------------------------------------------------

always @(*) begin

    // NaN has highest priority

    if(is_nan_a || is_nan_b)

        result = 32'h7FC00000;

    // +Inf + -Inf = NaN

    else if(is_inf_a && is_inf_b &&
            (sign_a != sign_b))

        result = 32'h7FC00000;

    // +Inf + +Inf

    else if(is_inf_a && is_inf_b)

        result = a;

    // A is Inf

    else if(is_inf_a)

        result = a;

    // B is Inf

    else if(is_inf_b)

        result = b;

    // Zero cases

    else if(is_zero_a)

        result = b;

    else if(is_zero_b)

        result = a;

    // Normal arithmetic

    else begin

        result = {
            sign_result,
            norm_exp,
            norm_mant[22:0]
        };

    end

end

endmodule
