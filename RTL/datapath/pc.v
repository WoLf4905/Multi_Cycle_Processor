module pc (
    input clk,
    input reset,
    input pcen,
    input [31:0] nextpc,

    output reg [31:0] pc
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        pc<=0;
    else if (pcen)
        pc<=nextpc;
end
endmodule