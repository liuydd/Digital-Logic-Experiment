`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 13:32:23
// Design Name: 
// Module Name: Counter
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


module Counter (
    input wire CLK, 
    input wire RST, 
    output reg [6:0] High, 
    output reg [6:0] Low 
    );

    reg [3:0] cnt_H;
    reg [3:0] cnt_L;

    always_ff @(posedge CLK or posedge RST) begin
        if(RST) begin
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

    Decoder u1 (
        .d (cnt_H),
        .seg (High)
    );

    Decoder u2 (
        .d (cnt_L),
        .seg (Low)
    );
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
