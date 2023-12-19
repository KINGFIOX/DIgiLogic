`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 22:48:13
// Design Name: 
// Module Name: display_collect
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


module display_collect(
    output reg [7:0] out,       // ������ʾ���
    output reg [7:0] led_en,    // LED ʹ���ź�
    input wire [2:0] sel,       // ѡ������
    input wire [3:0] dk7, dk6, dk5, dk4, dk3, dk2, dk1, dk0  // �����ź�
);

    // mux
    reg [3:0] mid;

    // Multiplexer logic
    always @(*) begin
        case (sel)
            3'b000 : begin mid = dk0; led_en = 8'b11111110; end
            3'b001 : begin mid = dk1; led_en = 8'b11111101; end
            3'b010 : begin mid = dk2; led_en = 8'b11111011; end
            3'b011 : begin mid = dk3; led_en = 8'b11110111; end
            3'b100 : begin mid = dk4; led_en = 8'b11101111; end
            3'b101 : begin mid = dk5; led_en = 8'b11011111; end
            3'b110 : begin mid = dk6; led_en = 8'b10111111; end
            3'b111 : begin mid = dk7; led_en = 8'b01111111; end
        endcase
    end

    // Decoder logic
    always @(*) begin
        case (mid)
            4'h0 : out = 8'b10000001;
            4'h1 : out = 8'b11110011;
            4'h2 : out = 8'b01001001;
            4'h3 : out = 8'b01100001;
            4'h4 : out = 8'b00110011;
            4'h5 : out = 8'b00100101;
            4'h6 : out = 8'b00000101;
            4'h7 : out = 8'b11110001;
            4'h8 : out = 8'b00000001;
            4'h9 : out = 8'b00110001;
            default : out = 8'b11111111;
        endcase
    end

endmodule

