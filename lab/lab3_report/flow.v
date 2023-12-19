`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:26:53
// Design Name: 
// Module Name: flow
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


module flow(
	output wire [7:0] led,
	input wire rst,	// reset
	input wire bnt,	// stop start
	input wire [1:0] sel,	// switch time 
	input wire clk
    );
    	wire sc_posedge;
	wire en;  // switch enable
	wire [3:0] de_sel;
	wire [3:0] de_en;  // de_sel & en
	wire [2:0] led_sel, led_sel0, led_sel1, led_sel2, led_sel3;  // mux

	decode24 de(
		.out(de_sel),
		.sel(sel)
	);

	// detect pos edge
	switch_control sc(
		.bnt(bnt),
		.clk(clk),
		.rst(rst),
		.pos_edge(sc_posedge)
	);

	// control start stop
	switch_counter sc_manager(
		.cnt(en),
		.rst(rst),
		.clk(clk),
		.pos_edge(sc_posedge)
	);

	assign de_en = {4{en}} & de_sel;
    
	// 1s flow light controller
	light1000ms lc0(
		.time_cnt(led_sel0),
		.en(de_en[0]),
		.clk(clk),
		.rst(rst)
	);
	defparam lc0.F = 100000000;


	// 0.1s
	light1000ms lc1(
		.time_cnt(led_sel1),
		.en(de_en[1]),
		.clk(clk),
		.rst(rst)
	);
	defparam lc1.F = 10000000;


	// 0.01s
	light1000ms lc2(
		.time_cnt(led_sel2),
		.en(de_en[2]),
		.clk(clk),
		.rst(rst)
	);
	defparam lc2.F = 10000000;


	// 0.25s
	light1000ms lc3(
		.time_cnt(led_sel3),
		.en(de_en[3]),
		.clk(clk),
		.rst(rst)
	);
	defparam lc3.F = 25000000;

	mux4 m(
		.out(led_sel),
		.sel(sel),
		.r0(led_sel0),
		.r1(led_sel1),
		.r2(led_sel2),
		.r3(led_sel3)
	);

	decode38 d1(
		.led(led),
		.sel(led_sel)
	);
endmodule
