`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 22:47:23
// Design Name: 
// Module Name: s3_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module s3_control(
	output reg [3:0] tens,
	output reg [3:0] ones,
	input s3,
	input clk,
	input rst
    );
	wire rst_n = ~rst;

	wire ss3;
	btn_stable s_s3(  // switch remove unstable
		.key_out(ss3),
		.key_in(s3),
		.clk(clk),
		.rst(rst)
	);
	

	reg sig_r0, sig_r1;
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			sig_r0 <= 1'b0;
		else
			sig_r0 <= ss3;
	end

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			sig_r1 <= 1'b0;
		else
			sig_r1 <= sig_r0;
	end

	wire s3_pos = ~sig_r1 & sig_r0;  // detect the posedge

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			tens <= 4'b0000;
			ones <= 4'b0000;
		end else begin
			if (s3_pos) begin  // inc to 20 if there is posedge
				    case ({tens, ones})
					    8'h00 : begin tens <= 4'h0; ones <= 4'h1; end
					    8'h01 : begin tens <= 4'h0; ones <= 4'h2; end
					    8'h02 : begin tens <= 4'h0; ones <= 4'h3; end
					    8'h03 : begin tens <= 4'h0; ones <= 4'h4; end
					    8'h04 : begin tens <= 4'h0; ones <= 4'h5; end
					    8'h05 : begin tens <= 4'h0; ones <= 4'h6; end
					    8'h06 : begin tens <= 4'h0; ones <= 4'h7; end
					    8'h07 : begin tens <= 4'h0; ones <= 4'h8; end
					    8'h08 : begin tens <= 4'h0; ones <= 4'h9; end
					    8'h09 : begin tens <= 4'h1; ones <= 4'h0; end

					    8'h10 : begin tens <= 4'h1; ones <= 4'h1; end
					    8'h11 : begin tens <= 4'h1; ones <= 4'h2; end
					    8'h12 : begin tens <= 4'h1; ones <= 4'h3; end
					    8'h13 : begin tens <= 4'h1; ones <= 4'h4; end
					    8'h14 : begin tens <= 4'h1; ones <= 4'h5; end
					    8'h15 : begin tens <= 4'h1; ones <= 4'h6; end
					    8'h16 : begin tens <= 4'h1; ones <= 4'h7; end
					    8'h17 : begin tens <= 4'h1; ones <= 4'h8; end
					    8'h18 : begin tens <= 4'h1; ones <= 4'h9; end
					    8'h19 : begin tens <= 4'h2; ones <= 4'h0; end
					    8'h20 : begin tens <= 4'h2; ones <= 4'h0; end
					    default: begin tens <= 4'h0; ones <= 4'h0; end
				    endcase
			    end else begin
				    tens <= tens;
				    ones <= ones;
			    end
		end
	end

endmodule


