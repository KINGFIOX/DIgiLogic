module top_module (
    input clk,
    input reset,
    output OneHertz,
    output reg [2:0] c_enable
);  //

  reg [3:0] Q0, Q1, Q2;
  always @(posedge clk) begin
    if (reset) begin
      c_enable = 1;
    end
  end

  assign c_enable[1] = (Q0 == 4'h9);
  assign c_enable[2] = ({Q1, Q0} == 8'h99);
  assign OneHertz = ({Q2, Q1, Q0} == 12'h999) ? 1'b1 : 1'b0;

  bcdcount counter0 (
      clk,
      reset,
      c_enable[0],
      Q0
  );
  bcdcount counter1 (
      clk,
      reset,
      c_enable[1],
      Q1
  );
  bcdcount counter2 (
      clk,
      reset,
      c_enable[2],
      Q2
  );

endmodule

module bcdcount (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);
endmodule


module test (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);  //

  reg [3:0] Q0, Q1, Q2;

  always @(posedge clk) begin
    if (reset) c_enable[0] = 1;
  end

  assign c_enable[1] = (Q0 == 4'd9);
  assign c_enable[2] = ({Q1, Q0} == 8'h99);
  assign OneHertz = ({Q2, Q1, Q0} == 12'h999) ? 1'b1 : 1'b0;

  bcdcount counter0 (
      clk,
      reset,
      c_enable[0],
      Q0
  );
  bcdcount counter1 (
      clk,
      reset,
      c_enable[1],
      Q1
  );
  bcdcount counter2 (
      clk,
      reset,
      c_enable[2],
      Q2
  );

endmodule
