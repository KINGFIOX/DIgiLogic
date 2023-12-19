`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 11:52:51
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


module testbench();
	reg clr;
	reg en;
	reg [2:0] wsel;
	reg [2:0] rsel;
	reg [7:0] d;
	wire [7:0] q;
	reg clk;
	
	dff8 u_dff8(
	   .q(q),
	   .clk(clk),
	   .clr(clr),
	   .en(en),
	   .d(d),
	   .wsel(wsel),
	   .rsel(rsel)
	);

   initial begin
    #0 begin clk = 0; clr = 1; en = 0; d = 0; end
    #0 begin clr = 0; en = 1; d = 8'h00; end
    #5 begin clr = 0; en = 1; d = 8'h01; wsel = 3'b000; rsel = 3'b000; end
    #5 begin clr = 0; en = 1; d = 8'ha0; wsel = 3'b001; rsel = 3'b001; end
    #5 begin clr = 0; en = 1; d = 8'h00; wsel = 3'b010; rsel = 3'b010; end
    #5 begin clr = 0; en = 1; d = 8'haa; end
    #5 begin clr = 0; en = 0; d = 8'ha5; end
    #5 begin clr = 0; en = 0; d = 8'ha5; end
    #5 begin clr = 0; en = 0; d = 1; end
    #5 begin clr = 0; en = 1; d = 0; end
    #5 begin clr = 0; en = 1; d = 1; end
   end
   
   always #5 clk = ~clk;

endmodule