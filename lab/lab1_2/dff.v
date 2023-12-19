module dff(
    output reg q,
    input clk,
    input clr,
    input en,
    input d
);
    always @(clr or posedge clk) begin
        if (en) begin
            if (clr) begin
                q <= 1'b1;
            end else begin
                if (d) begin
                    q <= d;
                end
                else begin
                    q <= q;
                end
            end
        end else begin
            q <= q;
        end
    end
endmodule