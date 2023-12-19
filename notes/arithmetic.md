---
id: "arithmetic"
aliases:
  - "arithmetic"
tags: []
---

# arithmetic

### adder100

```verilog
module adder100(
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    assign {cout, sum} = a + b + cin;
endmodule
```

这个可以得到 进位

### overflow adder

```verilog
module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
	assign s = a + b;
    assign overflow = (a[7] == b[7]) ? s[7] ^ b[7] : 0;
endmodule
```
