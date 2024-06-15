`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 14:53:06
// Design Name: 
// Module Name: testCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testCounter;
    reg CLK;
    reg RST;
    wire [6:0] High;
    wire [6:0] Low;
    
    Counter ccount(
        .CLK(CLK),
        .RST(RST),
        .High(High),
        .Low(Low)
    );
    
    //产生时钟信号
//    always begin
//        #5 CLK = ~CLK; 
//    end

    initial begin
        CLK = 0;
        RST = 0;
        #10 RST = 1;
        #10 RST = 0;
        #2000000000
        forever begin
            #200000000
            CLK = ~CLK;
        end
    end

    // 输出信息
    initial begin
        $monitor("Time=%0t | RST=%b | High=%b | Low=%b", $time, RST, High, Low);
    end    
endmodule
