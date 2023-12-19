`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:31:15
// Design Name: 
// Module Name: decode24
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


module decode24(
	output reg [3:0] out,
	input wire [1:0] sel
    );
    always @(*) begin
	    case (sel)
		    2'b00 : out = 4'b0001; 
		    2'b01 : out = 4'b0010;
		    2'b10 : out = 4'b0100;
		    2'b11 : out = 4'b1000;
	    endcase
    end   
endmodule
