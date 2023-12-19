`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:28:49
// Design Name: 
// Module Name: switch_control
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


module switch_control(
	output wire pos_edge,
	input bnt,
	input clk,
	input rst
    );
	reg sig_r0, sig_r1;
	always @(posedge clk) begin
		if (rst) sig_r0 <= 1'b0;
	       	else sig_r0 <= bnt;
	end

	always @(posedge clk) begin
		if (rst) sig_r1 <= 1'b0;
		else sig_r1 <= sig_r0;
	end

	assign pos_edge = ~sig_r1 & sig_r0;
endmodule
