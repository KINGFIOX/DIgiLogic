`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/11 18:05:30
// Design Name: 
// Module Name: testbench
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


module testbench(

    );

	reg a;
	reg b;
	reg c;
	wire s;

	unblock1 b1(
		.S(s),
		.A(a),
		.B(b),
		.C(c)
	);


	initial begin
		#10 begin a = 0; b = 0; c = 0; end
		#10 begin a = 0; b = 0; c = 0; end
		#10 begin a = 0; b = 0; c = 1; end
		#10 begin a = 0; b = 1; c = 0; end
		#10 begin a = 0; b = 1; c = 1; end
		#10 begin a = 1; b = 0; c = 0; end
		#10 begin a = 1; b = 0; c = 1; end
		#10 begin a = 1; b = 1; c = 0; end
		#10 begin a = 1; b = 1; c = 1; end
	end
endmodule
