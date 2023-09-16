`timescale 1ms / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:57 01/21/2019 
// Design Name: 
// Module Name:    Testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Testbench();
	reg clk, rst;
	reg [3:0] keypad;
	reg [2:0] inkeys, outkeys, floor;
	wire [1:0] power;
	wire door;
	
	Elevator elev(clk, rst, keypad, inkeys, outkeys, floor, power, door);
	
	
	initial
		begin
		clk = 0;
		end
		
	always
		#1 clk = !clk;
	
	initial
		begin
		
		//reset
		rst = 1;
		floor = 3'b001;
		#1.5
		rst = 0;
		
		//simple login and floor 2 and 3 request
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#1
		inkeys = 3'b110;
		#1
		inkeys = 3'b000;
		#7
		floor = 3'b010;
		#12
		floor = 3'b100;
		
		//admin adds user, 111 : 1234
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0010;
		#2
		keypad = 4'b0011;
		#2
		keypad = 4'b0100;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		
		//new user loggs in, and requests floor 2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0010;
		#2
		keypad = 4'b0011;
		#2
		keypad = 4'b0100;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#1
		outkeys = 3'b010;
		#1
		inkeys = 3'b000;
		#7
		floor = 3'b010;
		#5
		
		//admin sets that user as the new admin
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1011;
		#2
		
		//new admin removes the previous admin
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0010;
		#2
		keypad = 4'b0011;
		#2
		keypad = 4'b0100;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		
		//the previous admin tries to login but he can't
		keypad = 4'b1010;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0000;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b0001;
		#2
		keypad = 4'b1010;
		#2
		keypad = 4'b1011;
		#1
		inkeys = 3'b001;
		#1
		inkeys = 3'b000;	

		
		end

endmodule
