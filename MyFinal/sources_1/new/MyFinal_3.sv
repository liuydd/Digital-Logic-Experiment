`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 14:06:30
// Design Name: 
// Module Name: MyFinal_3
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


module MyFinal_3(
    input wire clk,
    input wire rst,
    input wire [2:0] Ctrl, //开关
    input wire button, //任务3
    output reg [3:0] h,
    output reg [3:0] m,
    output reg [3:0] l
    );
    wire [7:0] random_out;
    wire clk_1Hz;
    int cnt;
    
//    always_comb begin
//        if(button == 1)begin
//            if(stop == 3'b000)begin
//                stop = 3'b001;
//            end
//            else if(stop == 3'b001)begin
//                stop = 3'b011;
//            end
//            else if(stop == 3'b011)begin
//                stop = 3'b111;
//            end
//        end
//    end
    
    // 实例化时钟分频器
    clock_divider u_clk_div (
        .clk_1MHz(clk),
        .rst(rst),
        .clk_1Hz(clk_1Hz)
    );
    LFSR_random_generator gen(.clk(clk), .reset(rst), .random_out(random_out));
    
    always_ff@(posedge clk_1Hz or posedge rst or posedge button)begin
        if(rst)begin
            h <= 4'b0000;
            m <= 4'b0000;
            l <= 4'b0000;
            cnt <= 0;
        end
        else if(button)begin
            if(cnt <3)begin
                cnt <= cnt + 1;
            end
            else begin
                cnt <= 0;
            end
            if(Ctrl[2] == 0 && cnt < 3)begin
                    h[3]<=0;
                    h[2]<=0;
                    h[1]<=random_out[5];
                    h[0]<=random_out[4];
                end
                if(Ctrl[1] == 0 && cnt < 2)begin
                    m[3]<=0;
                    m[2]<=0;
                    m[1]<=random_out[3];
                    m[0]<=random_out[2];
                end
                if(Ctrl[0] == 0 && cnt == 0)begin
                    l[3]<=0;
                    l[2]<=0;
                    l[1]<=random_out[1];
                    l[0]<=random_out[0];
                end
        end
        else begin
//            else begin
                if(Ctrl[2] == 0 && cnt < 3)begin
                    h[3]<=0;
                    h[2]<=0;
                    h[1]<=random_out[5];
                    h[0]<=random_out[4];
                end
                if(Ctrl[1] == 0 && cnt < 2)begin
                    m[3]<=0;
                    m[2]<=0;
                    m[1]<=random_out[3];
                    m[0]<=random_out[2];
                end
                if(Ctrl[0] == 0 && cnt == 0)begin
                    l[3]<=0;
                    l[2]<=0;
                    l[1]<=random_out[1];
                    l[0]<=random_out[0];
                end
//            end
        end
    end
    
endmodule

module LFSR_random_generator(
    input wire clk,
    input wire reset,
    output wire [7:0] random_out
    );
    // LFSR的反馈多项式为 x^8 + x^6 + x^5 + x^4 + 1
    reg [7:0] lfsr;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // 当复位信号为高时，将LFSR重置
            lfsr <= 8'b1;
        end else begin
            // 计算新的LFSR值
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end
// 将LFSR的值输出作为随机数
assign random_out = lfsr;
endmodule

module clock_divider(
    input wire clk_1MHz,  // 输入1 MHz时钟
    input wire rst,       // 复位信号
    output reg clk_1Hz    // 输出1 Hz时钟
    );

    reg [19:0] counter;  // 20位计数器用于分频

    always_ff @(posedge clk_1MHz or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_1Hz <= 0;
        end else if (counter == 99_999) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;  // 翻转1 Hz时钟
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
