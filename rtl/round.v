module round(
    input  [23:0] mant_in,
    input  [7:0]  exp_in,

    input         guard,
    input         round_bit,
    input         sticky,

    output reg [23:0] mant_out,
    output reg [7:0]  exp_out
);

reg [24:0] temp;

always @(*) begin

    // Default outputs
    mant_out = mant_in;
    exp_out  = exp_in;

    temp = {1'b0, mant_in};

    // IEEE-754 Round-to-Nearest-Even
    if (guard && (round_bit || sticky || mant_in[0]))
        temp = temp + 1'b1;

    // Overflow after rounding
    if (temp[24]) begin
        mant_out = temp[24:1];
        exp_out  = exp_in + 1;
    end
    else begin
        mant_out = temp[23:0];
        exp_out  = exp_in;
    end

end

endmodule