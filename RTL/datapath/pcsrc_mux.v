module pcsrc_mux(
    input [31:0] aluresult,
    input [31:0] aluout,
    input pcsrc,

    output reg [31:0] nextpc
);

always@(*)
begin
    if(pcsrc)
        nextpc=aluout;
    else
        nextpc=aluresult;
end
endmodule