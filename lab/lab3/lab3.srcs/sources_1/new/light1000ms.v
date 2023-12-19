`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:50:31
// Design Name: 
// Module Name: light1000ms
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


module light1000ms
	#(parameter F=100000000)
	(
	output reg [2:0] time_cnt,
	input en,
	input clk,
	input rst
    );
	reg [29:0] cnt;
	reg       cnt_inc;
	
	wire rst_n = ~rst;
	wire cnt_end = cnt_inc & (cnt==F);

	// clk count
	always @ (posedge clk or negedge rst_n) begin
	    if(~rst_n)   cnt_inc <= 1'b0;          
	    else if(en) cnt_inc <= 1'b1;       
	    else if(cnt_end) cnt_inc <= 1'b0;
	end

	// clk count increase
	always @ (posedge clk or negedge rst_n) begin
	    if(~rst_n)       cnt <= 30'h0;          
	    else if(cnt_end) cnt <= 30'h0;       
	    else if(cnt_inc) cnt <= cnt + 30'h1; 
	end

	// led counter
	always @ (posedge clk or negedge rst_n) begin
	    if(~rst_n)       time_cnt <= 3'b000;          
	    else if(time_cnt == 3'b111) time_cnt <= 3'h000;
	    else if(cnt_end) time_cnt <= time_cnt + 3'h001; 
	end


endmodule
