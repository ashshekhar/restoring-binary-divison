`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2020 06:36:18 AM
// Design Name: 
// Module Name: testbench
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

// To generate waveforms, we develop the testbench
module testbench();
    
    // Inputs are set to registers
    reg [31:0] a_tb;
    reg [15:0] b_tb;
    
    reg clk_tb;
    reg rst_tb;
    reg start_tb;
    
    // Outputs are set to wires
    wire [31:0] q_tb;
    wire [15:0] r_tb;
    wire [4:0] count_tb;
    
    wire busy_tb;
    wire ready_tb;
    
    // Calling our division  module
    div div_tb(a_tb, b_tb, clk_tb, rst_tb, start_tb, busy_tb, ready_tb, count_tb, q_tb, r_tb);
    
    // Initial case
        initial begin
            clk_tb = 1;
            start_tb = 0;
            rst_tb = 0;
            
            // Initializing the values of dividend and divisor
            a_tb=32'h4c7f228a;
            b_tb=16'h6a0e;
        
            // Changing the variables as per the waveform
            #5 start_tb = 1;
               rst_tb = 1;
            #10 start_tb = 0;
            
            // For the division after 330ns, divisor is 4, dividend is 0xffff00
            #320 start_tb = 1;
            #5 a_tb=32'hffff00;
                b_tb = 4'h4;
            #5 start_tb = 0;
        end
        
        // Clock is put inside always block, since always changing
        always begin
            #5;
            clk_tb = ~clk_tb;    
        end
endmodule
