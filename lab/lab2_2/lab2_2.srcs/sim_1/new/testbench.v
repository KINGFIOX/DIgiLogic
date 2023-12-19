`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 12:07:51
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

module testbench();	
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


        always #5 clk = ~clk;

   initial begin
    clk = 0;
    clr = 0;
    en = 1;
    d = 8'b00000000;
    #10;
    
    clr = 1;
    #10;
    
    clr = 0;
    #10;
    
    d = 8'b01010101;
    #10;
    
    d = 8'b10101010;
    #10;
    
    #20;
    
    $finish;
   end
   

  

endmodule

