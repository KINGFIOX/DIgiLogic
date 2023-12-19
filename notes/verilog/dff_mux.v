module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q
);
  reg [1:0] cnt = 2'b00;
  reg mux_out, d_out;
  always @(posedge clk) begin
    case (cnt)  // 先设置一个计数器
      2'b00: cnt <= 2'b01;
      2'b01: cnt <= 2'b10;
      2'b10: cnt <= 2'b00;
    endcase
    if (L) begin
      mux_out = r_in;
    end
    d_out <= mux_out;

  end
endmodule
