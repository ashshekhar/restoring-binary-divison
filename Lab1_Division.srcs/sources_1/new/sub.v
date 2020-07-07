`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: June 14, 2020
// Design Name: 
// Module(s) Name: Restoring Division
// Project Name:  Lab1_Division
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

// Module      : Divider circuit
// Description : Implementation of a restoring division algorithm 
// Input(s)    : dividend(a), divisor(b), clock, reset, start
// Output(s)   : quotient(q), remainder(r), count

module div(a,b,clk,rst,start,busy,ready,count,q,r);
   
    input [31:0] a;  //dividend
    input [15:0] b; //divisor
    
    input clk; //clock input
    input rst; //reset
    input start; //to indicate the start of the division
    
    reg [15:0] reg_b; //for storing divisor b
    reg [31:0] reg_q; //for storing remainder r
    reg [15:0] reg_r; //for storing quotient q
    reg [4:0] count; // to keep incrementing the count in every division step
    
    wire [16:0] subtracter;
    wire [15:0] mux_r;
    
    output [15:0] r; //remainder
    output [31:0] q; //quotient
    output [4:0] count; // output of a counter that controls the iterations of the divisions
    
    output reg busy; // indicates that the divisor is busy and can't start a new division
    output reg ready; // indicates that the quotient and remainder are available
    
    /////////////////////////////////////// Mux over reg_r ////////////////////////////////////////////////////
    
    // As shown in the schematic diagram, in this mux, we use subtracter[16] to decide whether to restore or not
    // If the result is negative, the mux selects the original partial remainder which as per the diagram is
    //  {[14:0]reg_r,q[31]}, else selects the result of the subtraction that is subtracter[15:0]
  
    assign mux_r = subtracter[16]? {reg_r[14:0], reg_q[31]}:subtracter[15:0];
    
    // Also assigning values to q and r
    assign q = reg_q;
    assign r = reg_r;   

   //////////////////////////////////////// Subtracter ///////////////////////////////////////////////////////

    // As shown in the schematic diagram, in the subtracter, we subtract 16 bits of {0,[15:0]reg_b} from 16 bits of 
    // {[15:0]reg_r, MSB of reg_q} and returns a 17 bit answer where the 17th bit is the sign of the result
    
    assign subtracter = {reg_r, reg_q[31]} - {1'b0, reg_b}; 
 
    // Division Process
    always@(posedge clk or negedge rst) 
    begin
     
///////////////////////////////////////// Division process ////////////////////////////////////////////////////  
     
        // If reset is 0, it indicates that ALU is inactive and quotient and remainder are not available
        if(!rst) begin
            ready <= 0;
            busy  <= 0;
      
        // If the process has started already, keep updating the value of reg_q
        end else if(busy) begin
            reg_r <= mux_r;
           
  /////////////////////////////////////// Mux over reg_q //////////////////////////////////////////////////  
           
            // After each iteration, one bit of q is obtained from the signed bit of the subtracter result
            // and written to the LSB of reg_q
            reg_q <= {reg_q[30:0], ~subtracter[16]} ; // Shift the quotient and implement the NOT as shown

  /////////////////////////////////// Finally increase the counter and check for end case//////////////////
            count  <= count + 4'd1; // counter++
           
            // Since the remainder is max 32 bits, the count will max be 31, i.e 5'h1f
            if(count == 31) begin
                ready <= 1; // The quotient and remainder are available
                busy <= 0; // The ALU is ready again
            end
        end   
            
        // Else, start the division process
        else if(start) begin
            busy <= 1; // Since ALU is now busy
            count <= 0;
            ready <= 0;
                    
            // Initialize the registers as per the instructions and waveform
            reg_q <= a; // initially reg_q stores dividend a
            reg_r <= 0;
            reg_b <= b;   
        end
     end
endmodule













