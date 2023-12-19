`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 16:55:01
// Design Name: 
// Module Name: multiplexer
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


`timescale 1ns / 1ps

module multiplexer (
    input wire enable,
    input wire select,
    input wire [3:0] input_a, input_b,
    output reg [3:0] led
);
  always @(*) begin
    if (enable) begin
    case (select)
        1'b0: led[3:0] = input_a[3:0] + input_b[3:0];
        1'b1: led[3:0] = input_a[3:0] - input_b[3:0];
      endcase
    end else begin
      led[3:0] = 4'b1111;
    end
  end



endmodule

