`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 12:51:20
// Design Name: 
// Module Name: MyFinal
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


module MyFinal(
    input wire clk,
    input wire rst,
    input wire [2:0] Ctrl, //����
    output reg [3:0] h,
    output reg [3:0] m,
    output reg [3:0] l
    );
    wire [7:0] random_out;
    wire clk_1Hz;
    
    // ʵ����ʱ�ӷ�Ƶ��
    clock_divider u_clk_div (
        .clk_1MHz(clk),
        .rst(rst),
        .clk_1Hz(clk_1Hz)
    );
    LFSR_random_generator gen(.clk(clk), .reset(rst), .random_out(random_out));
    
    always_ff@(posedge clk_1Hz or posedge rst)begin
        if(rst)begin
            h <= 4'b0000;
            m <= 4'b0000;
            l <= 4'b0000;
        end
        else begin
        if(Ctrl[2] == 0)begin
            h[3]<=0;
            h[2]<=0;
            h[1]<=random_out[5];
            h[0]<=random_out[4];
        end
        if(Ctrl[1] == 0)begin
            m[3]<=0;
            m[2]<=0;
            m[1]<=random_out[3];
            m[0]<=random_out[2];
        end
        if(Ctrl[0] == 0)begin
            l[3]<=0;
            l[2]<=0;
            l[1]<=random_out[1];
            l[0]<=random_out[0];
        end
        end
    end
    
endmodule

module LFSR_random_generator(
    input wire clk,
    input wire reset,
    output wire [7:0] random_out
    );
    // LFSR�ķ�������ʽΪ x^8 + x^6 + x^5 + x^4 + 1
    reg [7:0] lfsr;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // ����λ�ź�Ϊ��ʱ����LFSR����
            lfsr <= 8'b1;
        end else begin
            // �����µ�LFSRֵ
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end
// ��LFSR��ֵ�����Ϊ�����
assign random_out = lfsr;
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
        end else if (counter == 99_999) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;  // ��ת1 Hzʱ��
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
