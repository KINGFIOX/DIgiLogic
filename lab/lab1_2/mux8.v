module mux8(
    output reg [7:0] q,
    input wire en,
    input wire [2:0] sel,
    input wire [7:0] r
);
  always @(*) begin
    q = 8'b00000000;
    if (en) begin
      case (sel)
        3'b000 : q[0] = r[0];
        3'b001 : q[1] = r[1];
        3'b010 : q[2] = r[2];
        3'b011 : q[3] = r[3];
        3'b100 : q[4] = r[4];
        3'b101 : q[5] = r[5];
        3'b110 : q[6] = r[6];
        3'b111 : q[7] = r[7];
      endcase
    end else begin
      q = 8'b00000000;
    end
  end
endmodule