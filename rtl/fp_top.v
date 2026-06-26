module fpu_top(
    input  [31:0] a,
    input  [31:0] b,
    input  [1:0]  op,

    output reg [31:0] result,
output reg overflow,
output reg underflow,
output reg invalid,
output reg div_by_zero
);

wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] mul_result;
wire [31:0] div_result;


fp_add u_add(
    .a(a),
    .b(b),
    .result(add_result)
);

fp_sub u_sub(
    .a(a),
    .b(b),
    .result(sub_result)
);

fp_mul u_mul(
    .a(a),
    .b(b),
    .result(mul_result)
);

fp_div u_div(
    .a(a),
    .b(b),
    .result(div_result)
);

always @(*) begin
//default value s
overflow = 1'b0;
underflow=1'b0;
invalid= 1'b0;
div_by_zero =1'b0;

    case(op)

        2'b00:
            result = add_result;

        2'b01:
            result = sub_result;

        2'b10:
            result = mul_result;

        2'b11:
            result = div_result;

        default:
            result = 32'h00000000;

    endcase

end

endmodule