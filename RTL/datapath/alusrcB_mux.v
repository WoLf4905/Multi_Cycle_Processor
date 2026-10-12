module alusrcB_mux(
    input [1:0] alusrcB,
    input [31:0] RD2,
    input [31:0] signlmm,
    input [31:0] signlmm_2shift,

    output reg [31:0] srcB
);

always @(*)
begin
    if(alusrcB==2'b00)
        srcB=RD2;
    else if(alusrcB==2'b01)
        srcB=32'd4;
    else if(alusrcB==2'b10)
        srcB=signlmm;
    else
        srcB=signlmm_2shift;
end
endmodule
