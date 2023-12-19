module top_module (
    input clk,
    input reset,  // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);

  reg [3:0] ones;
  reg [3:0] tens;
  reg [3:0] hundreds;
  reg [3:0] thousands;

  always @(posedge clk) begin
    if (reset) begin
      ones <= 4'd0;
    end else if (ones == 4'd9) begin
      ones <= 4'd0;
    end else begin
      ones <= ones + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      tens <= 4'd0;
    end else if (tens == 4'd9 && ones == 4'd9) begin
      tens <= 4'd0;
    end else if (ones == 4'd9) begin
      tens <= tens + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      hundreds <= 4'd0;
    end else if (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
      hundreds <= 4'd0;
    end else if (tens == 4'd9 && ones == 4'd9) begin
      hundreds <= hundreds + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      thousands <= 4'd0;
    end else if (thousands == 4'd9 && hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
      thousands <= 4'd0;
    end else if (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
      thousands <= thousands + 1'b1;
    end
  end

  assign q = {thousands, hundreds, tens, ones};
  assign ena[1] = (ones == 4'd9) ? 1'b1 : 1'b0;
  assign ena[2] = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
  assign ena[3] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;

endmodule
