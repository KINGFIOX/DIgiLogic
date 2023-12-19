`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 11:32:18 AM
// Design Name: 
// Module Name: kb_cnt
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


module kb_cnt #(
    parameter END=15,
    parameter WIDTH=4
)(
    input clk, 
    input reset, 
    input cnt_inc, 
    output cnt_end, 
    output reg[WIDTH-1:0] cnt
);

assign cnt_end = (cnt == END);

always @(posedge clk, posedge reset) begin
	if (reset) cnt <= 0;
	else if (cnt_end) cnt <= 0;
	else if (cnt_inc) cnt <= cnt + 1;
end

endmodule
