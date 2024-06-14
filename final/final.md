试题(1) 电梯

```verilog
//  Created by Colin on 2021/06/11.
//  Copyright © 2021 Colin. All rights reserved.

module Main (
    input wire Clk, //时钟
    input wire E_Button, Ctrl, Rst, //分别为紧急按钮、电梯上升/下降、复位
    output reg[6:0] Seg,
    output reg Div_out //分频输出端口
);
    logic[3:0] number = 1;
    FourBitsDecoder decoder(.number(number), .digits(Seg));

    shortint counter = 0;
    int cc = 0;
    
    initial begin
        Div_out = 1;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            number = 1;
            cc = 0;
        end
        else if (cc == 1_000_000) begin
            cc = 0;
            if (E_Button == 0) begin
                if (Ctrl == 1) begin
                    // 1 -> 6
                    if (number < 6) begin
                        number++;
                    end
                end
                else begin
                    // 6 -> 1
                    if (number > 1) begin
                        number--;
                    end
                end
            end
        end
        if (E_Button == 0)
            cc++;

        if (counter % 2 == 0) begin
            Div_out = ~Div_out;
            counter = 0;
        end
        counter++;
    end

endmodule

module FourBitsDecoder (
    input wire[3:0] number,
    output reg[6:0] digits
);

always @(number) begin
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

```verilog
//my answer
module Final(
    input wire clk,
    input wire rst,
    input wire Ctrl, //上升还是下降
    input wire E_Button, //紧急停止按钮
    output reg [6:0] numbers
    );
    logic[3:0] number = 1; //楼层
    wire clk_1Hz;
    
    // 实例化时钟分频器
    clock_divider u_clk_div (
        .clk_1MHz(clk),
        .rst(rst),
        .clk_1Hz(clk_1Hz)
    );
    
    FourBitsDecoder decoder(.number(number), .digits(numbers));
    
    always_ff @(posedge clk_1Hz or posedge rst)begin
        if(rst)begin
            number <= 1;
        end
        else if(E_Button == 0)begin
            if(Ctrl == 1)begin //电梯上升
                if(number < 6)begin
                    number++;
                end
            end
            else if(Ctrl == 0)begin //电梯下降
                if(number > 1)begin
                    number--;
                end
            end
        end
    end
    
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

module FourBitsDecoder ( //这是不带译码的数码管，带译码的数码管处理方式见“四位全加器”
    input wire[3:0] number,
    output reg[6:0] digits
);

always @(number) begin
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

```verilog
#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports clk];     #CLK接插孔

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports rst];     #IO0接插孔

# seg output
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports numbers[6]];     #IO1接插孔
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports numbers[5]];     #IO2接插孔
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports numbers[4]];     #IO3接插孔
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports numbers[3]];     #IO4接插孔
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports numbers[2]];     #IO5接插孔
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports numbers[1]];     #IO6接插孔
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports numbers[0]];     #IO7接插孔

# Ctrl
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports Ctrl];     #IO20接插孔

# E_Button
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports E_Button];     #IO19接插孔

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
```





反应速度

```
module problem4_reaction(
    input wire clk1M, // 1MHz 时钟
    input wire clkBtn, // CLK 按钮
    input wire rstBtn, // RST 按钮
    output reg led1, // 连接LED1
    output reg led2, // 连接LED2
    output reg led3 // 连接LED3
);

reg btnSync, btnLast;
reg [21:0] counter;

always @(posedge clk1M) begin
    if(rstBtn) begin
        counter <= 0;
        led1 <= 0;
    end else begin
        if(!(&counter))
            counter <= counter + 1;
        if(~led1) begin
            // 判断counter计时到2s～4s的某个值时，点亮led1，并重新开始计时
            // === YOUR CODE HERE ===
        end
    end
end

always @(posedge clk1M) begin
    btnLast <= btnSync;
    btnSync <= clkBtn;
    if(rstBtn) begin
        led2 <= 0;
        led3 <= 0;
    end else if(btnSync & !btnLast) begin
        // 检测到CLK按钮按下瞬间，根据题目要求比较counter的值，并设置led2，led3
        // === YOUR CODE HERE ===
    end
end

endmodule
```



2022考试题：

```verilog
//my answer
module Final2023(
    input wire clk,
    input wire rst,
    input wire Ctrl, //拨码开关
    input wire Change, //手动换挡开关
    input wire Stop, //刹车开关
    output reg [3:0] Speed, //速度
    output reg [3:0] DW //挡位
    );
    wire clk_1Hz;
    
    clock_divider u_clk_div (
        .clk_1MHz(clk),
        .rst(rst),
        .clk_1Hz(clk_1Hz)
    );
    
    always_ff @(posedge clk_1Hz or posedge rst) begin
        if(rst)begin
            Speed <= 0;
            DW <= 1;
        end
        else begin
            if(Stop == 0)begin
                if(Ctrl == 1)begin //拨码开关为高电平，自动挡
                    if(Speed <9 && Speed != 1 && Speed != 3 && Speed != 5 && Speed != 7)begin
                        Speed ++;
                    end
                    else if (Speed == 1 || Speed == 3 || Speed == 5 || Speed == 7)begin
                        Speed ++;
                        DW ++;
                    end
                end
                else if(Ctrl == 0) begin //拨码开关为低电平，手动挡
                    if(Change) begin
                        if(Speed <9 && Speed != 1 && Speed != 3 && Speed != 5 && Speed != 7)begin
                            Speed ++;
                        end
                        else if (Speed == 1 || Speed == 3 || Speed == 5 || Speed == 7)begin
                            Speed ++;
                            DW ++;
                        end
                    end
                end
            end
            else if(Stop == 1)begin
                if(Speed >0 && Speed != 8 && Speed != 6 && Speed != 4 && Speed != 2)begin
                        Speed --;
                    end
                    else if (Speed == 8 || Speed == 6 || Speed == 4 || Speed == 2)begin
                        Speed --;
                        DW --;
                end
            end
        end
    end
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
```

```verilog
#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports clk];     #CLK接插孔

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports rst];     #IO0接插孔

# Speed
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports Speed[3]];     #IO1接插孔
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports Speed[2]];     #IO2接插孔
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports Speed[1]];     #IO3接插孔
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports Speed[0]];     #IO4接插孔

# DW
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports DW[3]];     #IO5接插孔
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports DW[2]];     #IO6接插孔
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports DW[1]];     #IO7接插孔
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports DW[0]];     #IO8接插孔

# Ctrl
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports Ctrl];     #IO14接插孔

# Change
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports Change];     #IO20接插孔

#Stop
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports Stop];     #IO19接插孔

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
```





尝试写一个状态机模板：

在编写所有状态机时，代码都主要分为 3 个部分：切换时序逻辑，次状态组合逻辑和状态行为组合逻辑

```verilog
modul state_machine(
	input wire clk,
    input wire rst,
    //...
);

typedef enum {STATE_0, STATE_1, STATE_2, STATE_3} state_type;

state_type state_r, next_state_w;

always_ff @(posedge clk or posedge rst) begin //切换时序逻辑，这段逻辑负责 state_r 寄存器的输入逻辑。简单的时候只需要像上面这样把 next_state_w 赋给 state_r 就好。
    if(rst) begin
        state_r <= STATE_0; //置零，回到STATE_0状态
    end else begin
        state_r <= next_state_w; //切换到下一个状态
    end
end

always_comb begin //次状态组合逻辑，这段逻辑主要负责根据当前状态，以及其他必要信号，以组合逻辑方式计算下一个状态。注意组合逻辑需要覆盖所有可能分支。
    case(state_r) //设置现态state_r的下一个状态next_state_w
        STATE_0: begin
            next_state_w <= STATE_1
        end
        STATE_1: begin
            next_state_w <= ...
        end
        STATE_2: begin
            next_state_w <= ...
        end
        STATE_3: begin
            next_state_w <= ...
        end
        default: //别忘了default
            next_state_w <= ...
    endcase
end
            
always_comb begin //状态行为组合逻辑，这段代码主要负责确定每个状态，当前模块的行为。在本节的例子当中，每个状态对应着一个数字的输出，因此只需要像这样输出数字就好。注意组合逻辑需要覆盖所有可能分支。
    case(state_r)
        STATE_0: seg7_wo = 4'h2;
        STATE_1: seg7_wo = 4'h0;
        STATE_2: seg7_wo = 4'h1;
        STATE_3: seg7_wo = 4'h3;
        default: seg7_wo = 4'h0;
    endcase
end
        
endmodule
```





约束模板：

```verilog
#CLK input
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports CLK];     #CLK接插孔

#RST input
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports RST];     #IO0接插孔

# High output
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports High[6]];     #IO1接插孔
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports High[5]];     #IO2接插孔
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports High[4]];     #IO3接插孔
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports High[3]];     #IO4接插孔
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports High[2]];     #IO5接插孔
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports High[1]];     #IO6接插孔
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports High[0]];     #IO7接插孔

# High output
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports Low[6]];     #IO11接插孔
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports Low[5]];     #IO12接插孔
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports Low[4]];     #IO13接插孔
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports Low[3]];     #IO14接插孔
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports Low[2]];     #IO15接插孔
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports Low[1]];     #IO16接插孔
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports Low[0]];     #IO17接插孔

# start
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports Start];     #IO20接插孔

# required if touch button used as manual clock source
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
```





1M的时钟：1Mhz = 1000000Hz

时钟分频：

```verilog
module Final(
	input wire CLK,       // 输入1 MHz时钟
    input wire RST       // 复位信号
);
wire clk_1Hz;

// 实例化时钟分频器
clock_divider u_clk_div (
    .clk_1MHz(CLK),
    .rst(RST),
    .clk_1Hz(clk_1Hz)
);

// 使用分频后的1 Hz时钟
always_ff @(posedge clk_1Hz or posedge RST) begin
    
end

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
```



 

带译码的数码管：可以直接用output reg [3:0] Speed，用阿拉伯数字来表示输出

不带译码的数码管：使用FourBitsDecoder decoder(.number(number), .digits(numbers));



```verilog
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
```

