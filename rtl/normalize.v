module normalize(
    input  [24:0] mant_in,
    input  [7:0]  exp_in,

    output reg [23:0] mant_out,
    output reg [7:0]  exp_out
);

reg [24:0] temp_mant;
reg [7:0]  temp_exp;
integer shift;

always @(*) begin

    temp_mant = mant_in;
    temp_exp  = exp_in;

    // Zero result
    if (mant_in == 25'd0) begin
        mant_out = 24'd0;
        exp_out  = 8'd0;
    end

    // Carry generated after addition
    else if (mant_in[24]) begin
        mant_out = mant_in[24:1];
        exp_out  = exp_in + 1;
    end

    // Left normalize
    else begin

        shift = 0;

        while ((temp_mant[23] == 1'b0) &&
               (temp_exp > 0) &&
               (temp_mant != 0)) begin

            temp_mant = temp_mant << 1;
            temp_exp  = temp_exp - 1;
            shift     = shift + 1;

        end

        mant_out = temp_mant[23:0];
        exp_out  = temp_exp;

    end

end

endmodule
