module unpack(
input [31:0] in,
output sign,
output [7:0] exp,
output [23:0] mant
);
assign sign = in[31];
assign exp = in[30:23];

//hitten bit handling 
assign mant = (exp==8'd0)?
{1'b0, in[22:0]} : //Subnormal number
{1'b1, in[22:0]}; //Normal number 
endmodule 

