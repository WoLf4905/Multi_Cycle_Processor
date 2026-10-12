module aluout(
    input clk,
    input reset,
    input [31:0] aluresult,

    output reg [31:0] aluout
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        aluout<=32'b0;
    else
        aluout<=aluresult;
end
endmodule