`timescale 1ns / 1ps


module dff4 (
    output wire [15:0] q,
    input wire clk,
    input wire rst,
    input wire en,  // 写入开关
    input wire [15:0] d,
    input wire [1:0] wsel,
    input wire [1:0] rsel
);
  wire [3:0] wsel_de;  // 只有一个是有用的
  wire [15:0] r0, r1, r2, r3;

  // 4选1,选择写入
  decode24 de (
      .out(wsel_de),
      .sel(wsel),
      .en (en)
  );

  dff d0 (
      .q  (r0),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[0]),
      .d  (d)
  );
  dff d1 (
      .q  (r1),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[1]),
      .d  (d)
  );
  dff d2 (
      .q  (r2),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[2]),
      .d  (d)
  );
  dff d3 (
      .q  (r3),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[3]),
      .d  (d)
  );
  mux4 m (
      .out(q),
      .sel(rsel),
      .in0(r0),
      .in1(r1),
      .in2(r2),
      .in3(r3)
  );
endmodule


module dff (
    output reg [15:0] q,
    input clk,
    input rst,
    input en,  // 是否写入
    input wire [15:0] d
);

  wire rst_n = ~rst;
  always @(negedge rst_n or posedge clk) begin
    if (~rst_n) begin
      q <= 0;
    end else begin
      if (en) begin
        q <= d;
      end else begin
        q <= q;
      end
    end
  end

endmodule


// 多路选择器
module mux4 (
    output reg  [15:0] out,
    input  wire [ 1:0] sel,
    input  wire [15:0] in0,
    input  wire [15:0] in1,
    input  wire [15:0] in2,
    input  wire [15:0] in3
);
  always @(*) begin
    case (sel)
      2'b00:   out = in0;
      2'b01:   out = in1;
      2'b10:   out = in2;
      2'b11:   out = in3;
      default: out = 0;
    endcase
  end
endmodule

module decode24 (
    output reg [3:0] out,
    input wire [1:0] sel,
    input wire en
);
  always @(*) begin
    if (en) begin
      case (sel)
        2'b00: out = 4'b0001;
        2'b01: out = 4'b0010;
        2'b10: out = 4'b0100;
        2'b11: out = 4'b1000;
      endcase
    end else begin
      out = 4'b0000;
    end
  end
endmodule
