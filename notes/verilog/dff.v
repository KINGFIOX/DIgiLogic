module top_module (
    input clk,
    input d,
    input ar,  // asynchronous reset
    output reg q
);
  always @(ar or posedge clk) begin
    if (ar) begin
      q <= d;
    end
  end
endmodule
