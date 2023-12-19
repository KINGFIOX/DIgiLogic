`timescale 1ns / 1ps


module top_module (
    output wire [7:0] out,
    output wire [7:0] led_en,
    output wire [3:0] col,
    input wire s2,
    input wire s3,
    input wire s4,
    input wire s5,
    input wire [3:0] row,
    input rst,
    input clk
);

  // 降频 的 clk
  clk_div u_clk_div (
      .clk_in1 (clk),
      .clk_out1(clk_g),
      .locked  (1'b1)
  );

  wire [15:0] num;  // 计算结果 --> out1
  wire [15:0] rem;  // 记忆  -> out2

  cal c (
      .out1(num),   // 乘法可能会有进位之类的
      .out2(rem),
      .col (col),   // 列扫描
      .row (row),   // 行输入
      .rst (rst),   // rst是s1
      .s2  (s2),    // 等号
      .s3  (s3),    // 上翻
      .s4  (s4),    // 保存按键
      .s5  (s5),    // 下翻
      .clk (clk_g)
  );

  display dp (
      .out(out),
      .led_en(led_en),
      .clk(clk_g),
      .rst(rst),
      .dk3(rem[15:12]),
      .dk2(rem[11:8]),
      .dk1(rem[7:4]),
      .dk0(rem[3:0]),
      .dk7(num[15:12]),
      .dk6(num[11:8]),
      .dk5(num[7:4]),
      .dk4(num[3:0])
  );
  defparam dp.F = 10000;

endmodule
