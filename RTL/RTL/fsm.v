module fsm(
    input clk,
    input reset,
    input [5:0] opcode,
    input [5:0] funct,

    output reg pcwrite,
    output reg branch,
    output reg pcsrc,
    output reg [1:0] aluop,
    output reg alusrcA,
    output reg [1:0] alusrcB,
    output reg regwrite,
    output reg IorD,
    output reg memorywrite,
    output reg IRwrite,
    output reg regdst,
    output reg memtoreg

);

localparam S0_Fetch=4'b0000;
localparam S1_Decode=4'b0001;
localparam S2_MemAdr=4'b0010;
localparam S3_MemRead=4'b0011; 
localparam S4_MemWriteBack=4'b0100;
localparam S5_MemWrite=4'b0101;
localparam S6_RExecute=4'b0110;
localparam S7_ALUWriteBack=4'b0111;
localparam S8_Branch=4'b1000;
localparam S9_AddiExecute=4'b1001;
localparam S10_AddiWriteBack=4'b1010;

reg [3:0] state;
reg [3:0] nextstate;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state<=S0_Fetch;
    end
    else
    begin
        state<=nextstate;
    end
end

always @(*)
begin
    nextstate=state;

    pcwrite     = 1'b0;
    branch      = 1'b0;
    pcsrc       = 1'b0;
    aluop       = 2'b00;
    alusrcA     = 1'b0;
    alusrcB     = 2'b00;
    regwrite    = 1'b0;
    IorD        = 1'b0;
    memorywrite = 1'b0;
    IRwrite     = 1'b0;
    regdst      = 1'b0;
    memtoreg    = 1'b0;

    case(state)
    
        S0_Fetch:
        begin
            IorD=0;
            alusrcA=0;
            alusrcB=2'b01;
            aluop=2'b00;
            pcsrc=0;
            IRwrite=1;
            pcwrite=1;

            nextstate=S1_Decode;
        end
        S1_Decode:
        begin
            alusrcA=0;
            alusrcB=11;
            aluop=00;
            if(opcode==6'b100011 || opcode==6'b101011)
            begin
                nextstate=S2_MemAdr;
            end
            else if(opcode==6'b000000)
            begin
                nextstate=S6_RExecute;
            end
            else if(opcode==6'b000100)
            begin
                nextstate=S8_Branch;
            end
            else if(opcode==6'b001000)
            begin
                nextstate=S9_AddiExecute;
            end
            else
            begin
                nextstate=S0_Fetch;
            end
        end
        S2_MemAdr:
        begin
            alusrcA=1;
            alusrcB=10;
            aluop=00;

            if(opcode==6'b100011)
                nextstate=S3_MemRead;
            else if (opcode==6'b101011)
                nextstate=S5_MemWrite;
        end
        S3_MemRead:
        begin
            IorD=1;

            nextstate=S4_MemWriteBack;
        end
        S4_MemWriteBack:
        begin
            regdst=0;
            memtoreg=1;
            regwrite=1;

            nextstate=S0_Fetch;
        end
        S5_MemWrite:
        begin
            IorD=1;
            memorywrite=1;

            nextstate=S0_Fetch;
        end
        S6_RExecute:
        begin
            alusrcA=1;
            alusrcB=00;
            aluop=10;

            nextstate=S7_ALUWriteBack;
        end
        S7_ALUWriteBack:
        begin
            regdst=1;
            memtoreg=0;
            regwrite=1;

            nextstate=S0_Fetch;
        end
        S8_Branch:
        begin
            alusrcA=0;
            alusrcB=00;
            aluop=01;
            pcsrc=1;
            branch=1;

            nextstate=S0_Fetch;
        end
        S9_AddiExecute:
        begin
            alusrcA=1;
            alusrcB=10;
            aluop=00;

            nextstate=S10_AddiWriteBack;
        end
        S10_AddiWriteBack:
        begin
            regdst=0;
            memtoreg=0;
            regwrite=1;

            nextstate=S0_Fetch;
        end
    endcase
end
endmodule