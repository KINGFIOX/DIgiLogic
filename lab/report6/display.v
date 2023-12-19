`timescale 1ns / 1ps


module display #(
    parameter F = 10000
) (
    output reg [7:0] out,
    output reg [7:0] led_en,
    input [3:0] dk7,
    dk6,
    dk5,
    dk4,
    dk3,
    dk2,
    dk1,
    dk0,
    input clk,
    input rst
);

  wire [2:0] sel;
  dp_cnt cnt (
      .sel(sel),
      .clk(clk),
      .rst(rst),
      .en (1'b1)
  );
  defparam cnt.F = F;

  wire [7:0] mid_out, mid_en;
  dp_mux mux (
      .out(mid_out),
      .led_en(mid_en),
      .sel(sel),
      .dk7(dk7),
      .dk6(dk6),
      .dk5(dk5),
      .dk4(dk4),
      .dk3(dk3),
      .dk2(dk2),
      .dk1(dk1),
      .dk0(dk0)
  );

  always @(*) begin
    out = mid_out;
    led_en = mid_en;
  end
endmodule


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

module dp_mux (
    output reg  [7:0] out,     // 数字显示输出
    output reg  [7:0] led_en,  // LED 使能信号
    input  wire [2:0] sel,     // 选择输入
    input  wire [3:0] dk7,
    dk6,
    dk5,
    dk4,
    dk3,
    dk2,
    dk1,
    dk0  // 输入信号
);

  // mux
  reg [3:0] mid;

  // Multiplexer logic
  always @(*) begin
    case (sel)
      3'b000: begin
        mid = dk0;
        led_en = 8'b11111110;
      end
      3'b001: begin
        mid = dk1;
        led_en = 8'b11111101;
      end
      3'b010: begin
        mid = dk2;
        led_en = 8'b11111011;
      end
      3'b011: begin
        mid = dk3;
        led_en = 8'b11110111;
      end
      3'b100: begin
        mid = dk4;
        led_en = 8'b11101111;
      end
      3'b101: begin
        mid = dk5;
        led_en = 8'b11011111;
      end
      3'b110: begin
        mid = dk6;
        led_en = 8'b10111111;
      end
      3'b111: begin
        mid = dk7;
        led_en = 8'b01111111;
      end
    endcase
  end

  // Decoder logic
  always @(*) begin
    case (mid)
      4'h0: out = 8'b10000001;
      4'h1: out = 8'b11110011;
      4'h2: out = 8'b01001001;
      4'h3: out = 8'b01100001;
      4'h4: out = 8'b00110011;
      4'h5: out = 8'b00100101;
      4'h6: out = 8'b00000101;
      4'h7: out = 8'b11110001;
      4'h8: out = 8'b00000001;
      4'h9: out = 8'b00110001;
      4'ha: out = 8'b00010001;
      4'hb: out = 8'b00000111;
      4'hc: out = 8'b01001111;
      4'hd: out = 8'b01000011;
      default: out = 8'b11111111;
    endcase
  end

endmodule
