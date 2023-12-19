`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 09:51:22
// Design Name: 
// Module Name: mux8
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


module mux8(
    output reg [7:0] q,
    input wire [2:0] sel,
    input wire [7:0] r0, r1, r2, r3, r4, r5, r6, r7
);
  always @(*) begin
      case (sel)
        3'b000 : q[7:0] = r0[7:0];
        3'b001 : q[7:0] = r1[7:0];
        3'b010 : q[7:0] = r2[7:0];
        3'b011 : q[7:0] = r3[7:0];
        3'b100 : q[7:0] = r4[7:0];
        3'b101 : q[7:0] = r5[7:0];
        3'b110 : q[7:0] = r6[7:0];
        3'b111 : q[7:0] = r7[7:0];
        default: q[7:0] = 8'b00000000;
      endcase
  end
endmodule
