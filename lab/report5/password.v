`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 11:37:30 AM
// Design Name: 
// Module Name: password
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


module password (
    output reg correct,
    input en,
    input [3:0] num,
    input clk,
    input rst
);

  wire rst_n = ~rst;

  parameter IDLE = 4'b1111;
  parameter S0 = 4'b1110;  // 1
  parameter S1 = 4'b1101;  // 12
  parameter S2 = 4'b1011;  // 123

  reg [3:0] current_state;
  reg [3:0] next_state;


  // condition
  wire idle_s0_con = current_state == IDLE && en && num == 4'h1;
  wire idle_idle_con = current_state == IDLE && en && num != 4'h1;
  wire s0_s0_con = current_state == S0 && en && num == 4'h1;
  wire s0_s1_con = current_state == S0 && en && num == 4'h2;
  wire s0_idle_con = current_state == S1 && en && num != 4'h2;
  wire s1_s0_con = current_state == S1 && en && num == 4'h1;
  wire s1_s2_con = current_state == S1 && en && num == 4'h3;
  wire s1_idle_con = current_state == S1 && en && num != 4'h1 && num != 4'h3;
  wire s2_s0_con = current_state == S2 && en && num == 1'h1;
  wire s2_idle_con = current_state == S2 && en && num != 1'h1;


  // migrate current to next
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end


  // state migrate table
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (idle_s0_con) begin
          next_state = S0;
        end else if (idle_idle_con) begin
          next_state = IDLE;
        end else begin
          next_state = IDLE;
        end
      end
      S0: begin
        if (s0_s1_con) begin
          next_state = S1;
        end else if (s0_s0_con) begin
          next_state = S0;
        end else if (s0_idle_con) begin
          next_state = IDLE;
        end else begin
          next_state = S0;
        end
      end
      S1: begin
        if (s1_s2_con) begin
          next_state = S2;
        end else if (s1_s0_con) begin
          next_state = S0;
        end else if (s1_idle_con) begin
          next_state = IDLE;
        end else begin
          next_state = S1;
        end
      end
      S2: begin
        if (s2_s0_con) begin
          next_state = S0;
        end else if (s2_idle_con) begin
          next_state = IDLE;
        end else begin
          next_state = S2;
        end
      end
      default: next_state = IDLE;
    endcase
  end


  // output
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) correct <= 1'b0;
    else if (current_state == S2) begin
      correct <= 1'b1;
    end else begin
      correct <= 1'b0;
    end
  end
endmodule
