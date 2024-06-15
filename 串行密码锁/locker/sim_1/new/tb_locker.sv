`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/31 20:26:20
// Design Name: 
// Module Name: tb_locker
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
