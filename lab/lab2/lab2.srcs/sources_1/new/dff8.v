`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 10:20:58
// Design Name: 
// Module Name: dff8
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


module dff8(
    output wire [7:0] q,
    input clk,
    input clr,
    input en,
    input wire [7:0] d,
    input wire [2:0] wsel,
    input wire [2:0] rsel
);
    wire [7:0] wsel_de;
    wire [7:0] r0, r1, r2, r3, r4, r5, r6, r7;
    decode38 de(
        .sel(wsel),
        .led(wsel_de),
        .en(en)
    );
    dff d0(
        .q(r0),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[0]),
        .d(d)
    );
    dff d1(
        .q(r1),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[1]),
        .d(d)
    );
    dff d2(
        .q(r2),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[2]),
        .d(d)
    );
    dff d3(
        .q(r3),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[3]),
        .d(d)
    );
    dff d4(
        .q(r4),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[4]),
        .d(d)
    );
    dff d5(
        .q(r5),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[5]),
        .d(d)
    );
    dff d6(
        .q(r6),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[6]),
        .d(d)
    );
    dff d7(
        .q(r7),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[7]),
        .d(d)
    );
    mux8 m(
        .q(q),
        .sel(rsel),
        .r0(r0),
        .r1(r1),
        .r2(r2),  
        .r3(r3),
        .r4(r4),
        .r5(r5),
        .r6(r6),
        .r7(r7)
    );
endmodule
