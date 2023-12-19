`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 17:20:38
// Design Name: 
// Module Name: dp_cnt
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



// this is select led
module dp_cnt #(
    parameter F = 10000
)  // log2(1500000) = 20.51
(
    output reg [2:0] sel,
    input clk,
    input rst,
    input en  // en default to 1
);
  reg [20:0] cnt;
  reg cnt_inc;
  wire rst_n = ~rst;
  wire cnt_end = cnt_inc & (cnt == F);

  // clk enable count
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt_inc <= 1'b0;
    end else if (en) begin
      cnt_inc <= 1'b1;
    end else if (cnt_end) begin
      cnt_inc <= 1'b0;
    end
  end

  // clk count increase
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 21'h0;
    end else if (cnt_end) begin
      cnt <= 21'h0;
    end else if (cnt_inc) begin
      cnt <= cnt + 21'h1;
    end
  end

  // digital select
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sel <= 3'b000;
    end  // else if (sel == 3'b111) begin sel <= 3'b000; end
         // else if (cnt_end) begin sel <= sel + 3'b001; end
    else if (cnt_end) begin
      case (sel)
        3'b000: sel <= 3'b001;
        3'b001: sel <= 3'b010;
        3'b010: sel <= 3'b011;
        3'b011: sel <= 3'b100;

        3'b100: sel <= 3'b101;
        3'b101: sel <= 3'b110;
        3'b110: sel <= 3'b111;
        3'b111: sel <= 3'b000;
      endcase
    end
  end
endmodule
