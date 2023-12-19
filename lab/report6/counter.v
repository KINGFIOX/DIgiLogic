module counter #(
    parameter END=15,
    parameter WIDTH=4
)(
    input clk, 
    input reset, 
    input cnt_inc, 
    output cnt_end, 
    output reg[WIDTH-1:0] cnt
);

assign cnt_end = (cnt == END);

always @(posedge clk, posedge reset) begin
	if (reset) cnt <= 0;
	else if (cnt_end) cnt <= 0;
	else if (cnt_inc) cnt <= cnt + 1;
end

endmodule