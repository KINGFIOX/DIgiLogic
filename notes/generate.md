---
id: "generate"
aliases:
  - "generate"
tags: []
---

# generate

```verilog
module top_module(
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );

    wire [400:0] midcout;

    assign cout = midcout[400];

    bcd_fadd bcd_fadd_0(.a(a[3:0]), .b(b[3:0]), .cin(cin), .cout(midcout[4]), .sum(sum[3:0]));

    generate//子模块不可在always模块内部调用，可以生成模块重复调用
        genvar i;
        for(i=4;i<$bits(a);i=i+4)
            begin:Go
                bcd_fadd bcd_fadd_i(.a(a[i+3:i]), .b(b[i+3:i]), .cin(midcout[i]), .cout(midcout[i+4]), .sum(sum[i+3:i]));
            end
    endgenerate

endmodule
```
