module top_module (
    input            clk,
    input            reset,  // Synchronous reset
    input      [7:0] d,
    output reg [7:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q = 8'h34;
    end else begin
      q <= d;
    end
  end
endmodule
