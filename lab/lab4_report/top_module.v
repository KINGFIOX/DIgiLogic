`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 22:46:31
// Design Name: 
// Module Name: top_module
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


module top_module(
	output reg [7:0] out,
	output reg [7:0] led_en,
	input rst,
	input s3,  // half
	input s2,  // automatic
	input clk
    );
	
	wire [3:0] dk3, dk2;
	wire [3:0] dk1, dk0;
	s3_control s3c(
		.tens(dk3),
		.ones(dk2),
		.s3(s3),
		.clk(clk),
		.rst(rst)
	);

	s2_control s2c(
		.tens(dk1),
		.ones(dk0),
		.s2(s2),
		.clk(clk),
		.rst(rst)
	);
 	   

	wire [2:0] sel;	// ???2^3
	clk_cnt led_flash(
		.sel(sel),
		.rst(rst),
		.en(1),
		.clk(clk)
	);

	
	wire [7:0] mid_out, mid_en;
	display_collect dc(
	 	.out(mid_out),
		.led_en(mid_en),
		.sel(sel),
		.dk7(4'h1),
		.dk6(4'h0),
		.dk5(4'h1),
		.dk4(4'h2),
		.dk3(dk3),
		.dk2(dk2),
		.dk1(dk1),
		.dk0(dk0)
	 );  // 模块后，不要加多余的逗号
	
	always @(*) begin
		out = mid_out;
		led_en = mid_en;
	end

endmodule

