`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:38:34
// Design Name: 
// Module Name: switch_counter
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


module switch_counter(
	output reg cnt,
	input rst,
	input clk,
	input pos_edge
    );
	always @(posedge clk) begin
		if (rst) cnt <= 1'b0;
		else cnt <= cnt ^ pos_edge;
	end
endmodule
