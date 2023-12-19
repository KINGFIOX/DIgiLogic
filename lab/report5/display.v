`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 16:53:26
// Design Name: 
// Module Name: display
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


module display
	#(parameter F=10000)
	(
		output reg [7:0] out,
		output reg [7:0] led_en,
		input [3:0] dk7, dk6, dk5, dk4, dk3, dk2, dk1, dk0,
		input clk,
		input rst
	);
	
	wire [2:0] sel;
	dp_cnt cnt(
		.sel(sel),
		.clk(clk),
		.rst(rst),
		.en(1'b1)
	);
	defparam cnt.F = F;

	wire [7:0] mid_out, mid_en;
	dp_mux mux(
		.out(mid_out),
		.led_en(mid_en),
		.sel(sel),
		.dk7(dk7),
		.dk6(dk6),
		.dk5(dk5),
		.dk4(dk4),
		.dk3(dk3),
		.dk2(dk2),
		.dk1(dk1),
		.dk0(dk0)
	);
	
	always @(*) begin
		out = mid_out;
		led_en = mid_en;
	end
endmodule
