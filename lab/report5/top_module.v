`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 17:00:46
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


module top_module (
    output wire [7:0] out,
    output wire [7:0] led_en,
    output wire [3:0] col,
    output wire correct,
    output wire [15:0] led,
    input wire [3:0] row,
    input rst,
    input clk
);
  wire [3:0] num;

  wire en;

  keyboard k (
      .col(col),
      .num(num),
      .en (en),
      .rst(rst),
      .led(led),
      .clk(clk),
      .row(row)
  );

  password p (
      .correct(correct),
      .num(num),
      .en(en),
      .clk(clk),
      .rst(rst)
  );

  display dp (
      .out(out),
      .led_en(led_en),
      .clk(clk),
      .rst(rst),
      .dk7(num),
      .dk6(4'h0),
      .dk5(4'h1),
      .dk4(4'h8),
      .dk3(4'h1),
      .dk2(4'h0),
      .dk1(4'h3),
      .dk0(4'h2)
  );
  defparam dp.F = 10000;
endmodule
