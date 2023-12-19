module dff8(
    output reg [7:0] q,
    input clk,
    input clr,
    input en,
    input wire [7:0] d,
    input wire [2:0] wsel,
    input wire [2:0] rsel
);
    wire [7:0] wsel_de;
    wire [7:0] r;
    decode38 de(
        .sel(wsel),
        .led(wsel_de),
        .en(en)
    );
    dff d0(
        .q(r[0]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[0]),
        .d(d[0])
    );
    dff d1(
        .q(r[1]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[1]),
        .d(d[1])
    );
    dff d2(
        .q(r[2]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[2]),
        .d(d[2])
    );
    dff d3(
        .q(r[3]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[3]),
        .d(d[3])
    );
    dff d4(
        .q(r[4]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[4]),
        .d(d[4])
    );
    dff d5(
        .q(r[5]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[5]),
        .d(d[5])
    );
    dff d6(
        .q(r[6]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[6]),
        .d(d[6])
    );
    dff d7(
        .q(r[7]),
        .clk(clk),
        .clr(clr),
        .en(wsel_de[7]),
        .d(d[7])
    );
    mux8 m(
        .q(q),
        .en(en),
        .sel(rsel),
        .r(r)  
    );
endmodule