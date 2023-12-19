module top_module (
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 0;
    end else begin
      if (slowena) begin
        case (q)
          4'b0000: q <= 4'b0001;
          4'b0010: q <= 4'b0011;
          4'b0011: q <= 4'b0100;
          4'b0100: q <= 4'b0101;
          4'b0101: q <= 4'b0110;
          4'b0110: q <= 4'b0111;
          4'b0111: q <= 4'b1000;
          4'b1000: q <= 4'b1001;
          4'b1001: q <= 4'b0000;
        endcase
      end else begin
        q <= q;
      end
    end
  end
endmodule


module top_module2 (
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);

  always @(posedge clk) begin
    if (reset) q <= 0;
    else if (slowena) begin
      if (q == 9)  //slowena is high
        q <= 0;
      else q <= q + 1;
    end else q <= q;
  end
endmodule
