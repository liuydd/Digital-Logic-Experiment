`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 14:20:30
// Design Name: 
// Module Name: clock
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


module clock (
    input wire CLK,       // ����1 MHzʱ��
    input wire RST,       // ��λ�ź�
    output reg [6:0] High, 
    output reg [6:0] Low 
    );

    reg [3:0] cnt_H;
    reg [3:0] cnt_L;
    wire clk_1Hz;

    // ʵ����ʱ�ӷ�Ƶ��
    clock_divider u_clk_div (
        .clk_1MHz(CLK),
        .rst(RST),
        .clk_1Hz(clk_1Hz)
    );

    // ʹ�÷�Ƶ���1 Hzʱ��
    always_ff @(posedge clk_1Hz or posedge RST) begin
        if (RST) begin
            cnt_H <= 0;
            cnt_L <= 0;
        end else begin
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

    // ʵ�����߶�����ܽ�����
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
    input wire clk_1MHz,  // ����1 MHzʱ��
    input wire rst,       // ��λ�ź�
    output reg clk_1Hz    // ���1 Hzʱ��
    );

    reg [19:0] counter;  // 20λ���������ڷ�Ƶ

    always_ff @(posedge clk_1MHz or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_1Hz <= 0;
        end else if (counter == 999_999) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;  // ��ת1 Hzʱ��
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module Decoder (
    input wire [3:0] d,    // ������������
    output reg [6:0] seg   // �߶���������
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
