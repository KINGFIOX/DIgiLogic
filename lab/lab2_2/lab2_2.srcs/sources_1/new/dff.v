`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 09:52:06
// Design Name: 
// Module Name: dff
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


module dff(
    output reg[7:0] q,
    input clk,
    input clr,
    input en,
    input wire[7:0] d
);
    always @(posedge clr or posedge clk) begin
        if (clr) begin
            q <= 8'b11111111;
        end else begin
            if (en) begin
                q <= d;
            end
            else begin
                q <= q;
            end
        end
    end
endmodule
