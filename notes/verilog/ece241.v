module top_module (
    input  clk,
    input  x,
    output z
);
  reg Q1, Q2, Q3;
  wire D1, D2, D3;
  assign {D1, D2, D3} = {Q1 ^ x, ~Q2 & x, ~Q3 | x};
  always @(posedge clk) begin
    Q1 <= D1;
    Q2 <= D2;
    Q3 <= D3;
  end
  assign z = Q1 | Q2 | Q3;
endmodule
