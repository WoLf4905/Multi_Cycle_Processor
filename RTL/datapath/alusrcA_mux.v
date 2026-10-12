module alusrcA_mux(
    input alusrcA,
    input [31:0] pc,
    input [31:0] RD1,

    output reg [31:0] srcA
);

always @(*)
begin
    if (alusrcA)
        srcA=RD1;
    else
        srcA=pc;
end
endmodule