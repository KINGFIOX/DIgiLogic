`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 18:42:59
// Design Name: 
// Module Name: mux4
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


module mux4(
	output reg [7:0] out,
	input wire [1:0] sel,
	input wire [3:0] r0, r1, r2, r3
    );
    	always @(*) begin
		case (sel)
			2'b00 : out = r0;
			2'b01 : out = r1;
			2'b10 : out = r2;
			2'b11 : out = r3;
		endcase
	end
endmodule
