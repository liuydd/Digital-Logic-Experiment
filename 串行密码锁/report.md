# 串行密码锁实验报告

刘雅迪

计26

2021010521



## 代码与工作原理

起始状态都是0

* 设置密码：

状态1设置第一个密码，然后按CLK，变为状态2

状态2设置第二个密码，然后按CLK，变为状态3

状态3设置第三个密码，然后按CLK，变为状态4

状态4设置第四个密码，然后按CLK，变为状态9

密码设置完毕

设置完密码后将mode设为0，若接下来要验证密码，必须将mode改成1并且按下rst才能进一步操作

* 验证密码：

状态5验证第一个密码，然后按CLK，变为状态6

状态6验证第二个密码，然后按CLK，变为状态7

状态7验证第三个密码，然后按CLK，变为状态8

状态8验证第四个密码

若连续三次密码验证失败，alert警报灯会亮，密码锁会被锁定，只有输入管理员密码才能开锁，开锁后警报灯熄灭，用户密码被重置为内置密码

Unlock = 0：被锁住。只有当设置密码时才会等于1（因为有内置密码）

```verilog
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
            init: begin //选择Mode的状态
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
            set0: begin //设置密码状态1
                user_password[0] <= Code;
                state <= set1;
            end
            set1: begin //设置密码状态2
                user_password[1] <= Code;
                state <= set2;
            end
            set2: begin //设置密码状态3
                user_password[2] <= Code;
                state <= set3;
            end
            set3: begin //设置密码状态4
                user_password[3] <= Code;
                state <= open; // 密码设置完成, 跳到open状态（即9）
                Unlock <= 0; //被锁住
            end
            val0: begin //验证密码状态5
                if ((~alert && Code != user_password[0]) || (alert && Code != admin_password[0]) || admin_wrong) begin
                    isWrong <= 1;
                end
                state <= val1;
            end
            val1: begin //验证密码状态6
                if ((~alert && Code != user_password[1]) || (alert && Code != admin_password[1]) || admin_wrong) begin
                    isWrong <= 1;
                end
                state <= val2;
            end
            val2: begin //验证密码状态7
                if ((~alert && Code != user_password[2]) || (alert && Code != admin_password[2]) || admin_wrong) begin
                    isWrong <= 1;
                end
                state <= val3;
            end
            val3: begin //验证密码状态8
                if ((~alert && Code != user_password[3]) || (alert && Code != admin_password[3]) || admin_wrong) begin
                    isWrong <= 1;
                end
                if(isWrong == 1) begin
                    handle_wrong_password();
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
            open: begin //终态，密码验证成功或设置成功
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

function void handle_wrong_password();  //处理密码验证错误情况
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
        isWrong = 0;
        state = init;
        Err = 1;
        Unlock = 0; //还是被锁住
    end
endfunction

endmodule

module FourBitsDecoder ( //用七段数码管显示当前状态
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
```

管脚约束

```verilog
#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports CLK];     #CLK接插孔

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports RST];     #IO0接插孔

# Code input
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports Code[3]];     #IO1接插孔
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports Code[2]];     #IO2接插孔
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports Code[1]];     #IO3接插孔
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports Code[0]];     #IO4接插孔

# Mode input
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports Mode];     #IO11接插孔

# Unlock output
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports Unlock];     #IO16接插孔

# Err output
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports Err];     #IO17接插孔

# alert output
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports alert];     #IO18接插孔

# digits output
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports digits[6]];     #IO6接插孔
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports digits[5]];     #IO7接插孔
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports digits[4]];     #IO8接插孔
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports digits[3]];     #IO9接插孔
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports digits[2]];     #IO10接插孔
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports digits[1]];     #IO12接插孔
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports digits[0]];     #IO13接插孔

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
```



## 软件仿真结果与对比

仿真代码

```verilog
module tb_locker();

reg [3:0] Code;
reg Mode;
reg CLK;
reg RST;
wire Unlock;
wire Err;
wire alert;
wire [6:0] digits;

Locker uut (
    .Code(Code),
    .Mode(Mode),
    .CLK(CLK),
    .RST(RST),
    .Unlock(Unlock),
    .Err(Err),
    .alert(alert),
    .digits(digits)
);

// Clock generation
always #5 CLK = ~CLK;

initial begin
    // Initialize signals
    CLK = 0;
    RST = 1;
    Mode = 1'b1; // Start in validation mode
    Code = 4'd0;

    #10 RST = 0; // Release reset

    // Test sequence
    // 1. Test initial validation mode with correct user password
    Code = 4'd0; #10;
    Code = 4'd1; #10;
    Code = 4'd0; #10;
    Code = 4'd3; #10;

    // Expect Unlock = 1, Err = 0, alert = 0
    if (Unlock !== 1 || Err !== 0 || alert !== 0) $display("Test 1 failed");

    // 2. Test initial validation mode with incorrect user password
    RST = 1; #10; RST = 0; #10; // Reset the module
    Code = 4'd0; #10;
    Code = 4'd1; #10;
    Code = 4'd0; #10;
    Code = 4'd4; #10;

    // Expect Unlock = 0, Err = 1, alert = 0
    if (Unlock !== 0 || Err !== 1 || alert !== 0) $display("Test 2 failed");

    // 3. Test setting a new user password
    Mode = 1'b0; // Switch to set mode
    Code = 4'd5; #10;
    Code = 4'd6; #10;
    Code = 4'd7; #10;
    Code = 4'd8; #10;

    // Expect Unlock = 0, Err = 0, alert = 0
    if (Unlock !== 0 || Err !== 0 || alert !== 0) $display("Test 3 failed");

    // 4. Test validation mode with the new user password
    Mode = 1'b1; // Switch to validation mode
    Code = 4'd5; #10;
    Code = 4'd6; #10;
    Code = 4'd7; #10;
    Code = 4'd8; #10;

    // Expect Unlock = 1, Err = 0, alert = 0
    if (Unlock !== 1 || Err !== 0 || alert !== 0) $display("Test 4 failed");

    // 5. Test alert mode (after three wrong attempts)
    RST = 1; #10; RST = 0; #10; // Reset the module
    Mode = 1'b1; // Switch to validation mode
    Code = 4'd0; #10;
    Code = 4'd1; #10;
    Code = 4'd0; #10;
    Code = 4'd4; #10; // wrong attempt 1
    Code = 4'd0; #10;
    Code = 4'd1; #10;
    Code = 4'd0; #10;
    Code = 4'd4; #10; // wrong attempt 2
    Code = 4'd0; #10;
    Code = 4'd1; #10;
    Code = 4'd0; #10;
    Code = 4'd4; #10; // wrong attempt 3

    // Expect Unlock = 0, Err = 1, alert = 1
    if (Unlock !== 0 || Err !== 1 || alert !== 1) $display("Test 5 failed");

    // 6. Test admin password to unlock after alert
    Code = 4'd0; #10;
    Code = 4'd2; #10;
    Code = 4'd0; #10;
    Code = 4'd7; #10;

    // Expect Unlock = 1, Err = 0, alert = 0
    if (Unlock !== 1 || Err !== 0 || alert !== 0) $display("Test 6 failed");

    $stop;
end

endmodule
```

分别测试了：

* 在验证模式下输入正确的用户密码和错误的用户密码
* 在设置模式设置一个新的用户密码
* 在验证模式下输入新的用户密码
* 连续三次输入错误的用户密码以触发报警，警报灯亮
* 在警报灯亮的情况下输入管理员密码以解除报警

仿真结果与电路功能测试的结果一致。



## 调试中所遇到的问题与解决方法

一开始写好verilog代码后点击CLK和RST后密码锁并没有像我想象地那样变化，或者说我根本不知道它是否按照我设计的在变化，所以我用了一个七段数码管来显示当前的状态，这样既好展示也方便debug，不过debug还是花了很久时间，最后似乎东改改西改改就能正常运行了（？

具体的电路如下：

![](./a.jpg)