`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 20:10:54
// Design Name: 
// Module Name: Locker
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


module Locker(
    input wire [3:0] Code,
    input wire Mode,
    input wire CLK,
    input wire RST,
    output reg Unlock,
    output reg Err,
    output reg alert,
    output[6:0] digits
    );
    
typedef enum {init, set0, set1, set2, set3, val0, val1, val2, val3, open} state_t;
state_t state;

reg [3:0] admin_password[0:3] = '{4'd0, 4'd2, 4'd0, 4'd7};
reg [3:0] user_password[0:3] = '{4'd0, 4'd1, 4'd0, 4'd3};
shortint wrongtimes;
logic admin_wrong;
logic isWrong;

FourBitsDecoder decoder(.number(state), .digits(digits));

initial begin
    state = init;
    Unlock = 0; //一开始就被锁住了，因为有内置密码
    Err = 0;
    alert = 0;
    wrongtimes = 0;
    admin_wrong = 0;
    isWrong = 0;
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= init;
        Unlock <= 0;
        Err <= 0;
        alert <= 0;
//        wrongtimes <= 0;
        admin_wrong <= 0;
    end else begin
        case (state)
            init: begin
//                Unlock <= 1;
                case (Mode)
                    1'b0: begin
                        state <= set0; // Mode = 0, 为设置密码模式
                        Unlock <= 1; //设置密码时解锁
                    end
                    1'b1: begin
                        state <= val0; // Mode = 1, 为验证密码模式
                        Unlock <= 0;
                    end
                endcase
                Err <= 0;
            end
            set0: begin
                user_password[0] <= Code;
                state <= set1;
            end
            set1: begin
                user_password[1] <= Code;
                state <= set2;
            end
            set2: begin
                user_password[2] <= Code;
                state <= set3;
            end
            set3: begin
                user_password[3] <= Code;
                state <= open; // 密码设置完成, 跳到open状态（即9）
                Unlock <= 0; //被锁住
            end
            val0: begin
                if ((~alert && Code != user_password[0]) || (alert && Code != admin_password[0]) || admin_wrong) begin
                    isWrong <= 1;
                end
//                else begin
                state <= val1;
//                end
            end
            val1: begin
                if ((~alert && Code != user_password[1]) || (alert && Code != admin_password[1]) || admin_wrong) begin
                    isWrong <= 1;
                end
//                else begin
                state <= val2;
//                end
            end
            val2: begin
                if ((~alert && Code != user_password[2]) || (alert && Code != admin_password[2]) || admin_wrong) begin
                    isWrong <= 1;
                end
//                else begin
                state <= val3;
//                end
            end
            val3: begin
                if ((~alert && Code != user_password[3]) || (alert && Code != admin_password[3]) || admin_wrong) begin
                    isWrong <= 1;
                end
                if(isWrong == 1) begin
                    // user
                    if (~alert) begin
                        isWrong = 0;
                        state = init;
                        Unlock = 0; //被锁住
                        Err = 1;
                        wrongtimes++;
                        if (wrongtimes >= 3) alert = 1;
                    end
                    // admin          
                    else begin
                //        if (state == val3) begin
                        isWrong = 0;
                        state = init;
                        Err = 1;
                        Unlock = 0; //还是被锁住
            //            admin_wrong = 0;
        //        end else begin
        //            admin_wrong = 1;
    //            state = state_t'(state + 1);
    //        end
                    end
                end
                else begin //密码验证正确
                    state <= open;
                    wrongtimes <= 0;
                    Err <= 0;
                    Unlock <= 1;
                    if (alert == 1) begin // 如果是在报警灯亮了后输入管理员密码才解锁的
                        alert <= 0; // 解除报警
                        Unlock <= 1; //开锁
                        user_password <= '{4'd0, 4'd1, 4'd0, 4'd3};
                    end
                end
            end
            open: begin
                if(alert == 1)begin
                    Unlock <= 0; //被锁住
                end
                else begin
                    Unlock <= 1;
                end
            end
            default: state <= init;
        endcase
    end
end


endmodule

module FourBitsDecoder (
    input [3:0] number,
    output reg[6:0] digits
);

always_ff @(number) begin
    case(number)
        4'h0:   digits = 7'b1111110;
        4'h1:   digits = 7'b0110000;
        4'h2:   digits = 7'b1101101;
        4'h3:   digits = 7'b1111001;
        4'h4:   digits = 7'b0110011;
        4'h5:   digits = 7'b1011011;
        4'h6:   digits = 7'b1011111;
        4'h7:   digits = 7'b1110000;
        4'h8:   digits = 7'b1111111;
        4'h9:   digits = 7'b1110011;
        4'ha:   digits = 7'b1110111;
        4'hb:   digits = 7'b0011111;
        4'hc:   digits = 7'b1001110;
        4'hd:   digits = 7'b0111101;
        4'he:   digits = 7'b1001111;
        4'hf:   digits = 7'b1000111;
        default:
                digits = 7'b0;
    endcase
end
    
endmodule
