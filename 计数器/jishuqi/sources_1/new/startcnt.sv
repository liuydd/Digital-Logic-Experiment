`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 14:23:34
// Design Name: 
// Module Name: startcnt
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


module startcnt (
    input wire CLK,       // 输入1 MHz时钟
    input wire RST,       // 复位信号
    input wire Start,     // 开关信号
    output reg [6:0] High, 
    output reg [6:0] Low 
    );

    reg [3:0] cnt_H;
    reg [3:0] cnt_L;
    wire clk_1Hz;

    // 实例化时钟分频器
    clock_divider u_clk_div (
        .clk_1MHz(CLK),
        .rst(RST),
        .clk_1Hz(clk_1Hz)
    );

    // 使用分频后的1 Hz时钟
   always_ff @(posedge clk_1Hz or posedge RST) begin
        if (RST) begin
            cnt_H <= 0;
            cnt_L <= 0;
        end else if (Start) begin  // 仅在Start信号为高时进行计数
            if (cnt_L == 9) begin
                if(cnt_H == 5) begin
                    cnt_H <= 0;
                    cnt_L <= 0;
                end else begin
                    cnt_H <= cnt_H + 1;
                    cnt_L <= 0;
                end
            end else begin
                cnt_L <= cnt_L + 1;
            end
        end
    end

    // 实例化七段数码管解码器
    Decoder u1 (
        .d (cnt_H),
        .seg (High)
    );

    Decoder u2 (
        .d (cnt_L),
        .seg (Low)
    );
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
        end else if (counter == 499_999) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;  // 翻转1 Hz时钟
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module Decoder (
    input wire [3:0] d,    // 拨动开关输入
    output reg [6:0] seg   // 七段数码管输出
    );

    always_comb begin
        case (d)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1110011;
            4'd10: seg = 7'b1110111;
            4'd11: seg = 7'b0011111;
            4'd12: seg = 7'b1001110;
            4'd13: seg = 7'b0111101;
            4'd14: seg = 7'b1001111;
            4'd15: seg = 7'b1000111;
            default: seg = 7'b0;
        endcase
    end
endmodule
