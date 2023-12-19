`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 10:12:09
// Design Name: 
// Module Name: dff_test
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

`timescale 1ns/1ps

module dff_test();	
	reg clr;
	reg clk;
	reg en;
	reg [7:0] d;
	wire [7:0] q;

    dff u_dff(
        .clk(clk),
        .clr(clr),
        .en(en),
        .q(q),
        .d(d)
    );	

   initial begin
    #0 begin clk = 0; clr = 0; en = 0; d = 0; end
    #5 begin clr = 0; en = 0; d = 0; end
    #5 begin clr = 0; en = 0; d = 8'b00011100; end
    #5 begin clr = 0; en = 1; d = 0; end
    #5 begin clr = 0; en = 1; d = 8'b01101100; end
    #5 begin clr = 1; en = 0; d = 0; end
    #5 begin clr = 1; en = 0; d = 8'b00011001; end
    #5 begin clr = 1; en = 1; d = 0; end
    #5 begin clr = 1; en = 1; d = 8'b01011000; end
   end
   
   always #5 clk = ~clk;

endmodule
