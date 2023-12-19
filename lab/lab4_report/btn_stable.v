`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 22:50:05
// Design Name: 
// Module Name: btn_stable
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


module btn_stable (
    output reg key_out,
    input key_in,
    input clk,
    input rst
);
	parameter F = 1;  // 15000
	wire rst_n = ~rst;
	reg [19:0] cnt;
	reg key_cnt;

	// collect the result
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			key_out <= 1'b0;
		else if (cnt == F - 1)
			key_out <= key_in;
	end
	
	// inc cnt
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			cnt <= 20'h0;
		else if (key_cnt)
			cnt <= cnt + 20'h1;
		else
			cnt <= 20'h0;
	end

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			key_cnt <=0;
		else if (key_cnt == 1'b0 && key_in != key_out)
			key_cnt <= 1'b1;
		else if (cnt == F - 1)
			key_cnt <= 1'b0;
	end

endmodule
