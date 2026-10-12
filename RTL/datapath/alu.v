module alu(
    input [31:0] srcA,
    input [31:0] srcB,
    input [2:0] alucontrol,

    output zero,
    output reg [31:0] aluresult
);

always @(*)
begin
    aluresult =32'd0;
    if (alucontrol==3'b010)
        aluresult=srcA+srcB;
    else if (alucontrol==3'b110)
        aluresult=srcA-srcB;
    else if (alucontrol==3'b000)
        aluresult=srcA&srcB;
    else if (alucontrol==3'b001)
        aluresult=srcA|srcB;
    else if (alucontrol==3'b111)
        if ($signed(srcA) < $signed(srcB))
            aluresult=32'd1;
        else
            aluresult=32'd0;
end
assign zero = aluresult==32'b0;
endmodule