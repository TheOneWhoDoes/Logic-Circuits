`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:59 01/21/2019 
// Design Name: 
// Module Name:    Elevator_Login 
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
module Elevator_login(clk, keypad, logged, error);

	input clk;
	input [3:0] keypad;
	output logged, error;
	
	reg logged, error;
	
	//reg for reseting properly
	reg resetCount;
	
	//username
	reg [3:0] user0;
	reg [3:0] user1;
	reg [3:0] user2;
	
	//full username
	reg [11:0] fullUser;
	
	//password
	reg [3:0] pass0;
	reg [3:0] pass1;
	reg [3:0] pass2;
	reg [3:0] pass3;	
		
	//state
	reg [5:0] state;
	
	//RAM input and outputs
	reg rst, cs;
	reg passLoad, adminLoad, countLoad, lockLoad;
	reg [11:0] address;
	reg [15:0] passIn;
	reg [3:0] countIn;
	reg adminIn, lockIn;
	wire [15:0] passOut;
	wire [3:0] countOut;
	wire adminOut, lockOut;
	
	//RAM
	SYNCSRAM DUT(
          .clk(clk), 
          .rst(rst),
          .cs(cs),
          .pass_rw(passLoad), 
          .admin_rw(adminLoad),
          .lock_rw(lockLoad),
          .count_rw(countLoad),
          .addr(address),
          .pass_in(passIn),
          .count_in(countIn),
          .admin_in(adminIn),
          .lock_in(lockIn),
          .pass_out(passOut),
          .count_out(countOut),
          .admin_out(adminOut),
          .lock_out(lockOut));
	
	initial
		begin
		rst = 1;
		state = 6'b000000;
		logged = 1'b0;
		adminIn = 0;
		lockIn = 0;
		passIn = 15'b000000000000000;
		countIn = 4'b0000;
	
		resetCount = 0;
		end
	
	always @ (negedge clk)
		begin
		if (rst == 1)
			begin
			if (resetCount == 1)
				begin
				rst = 0;
				passLoad = 0;
				countLoad = 0;
				adminLoad = 0;
				lockLoad = 0;
				end
			else
				resetCount = 1;
			end
			
		case (state)
		
			0:
				begin
				logged = 0;
				error = 0;
				countLoad = 0;
				lockLoad = 0;
				passLoad = 0;
				adminLoad = 0;
				
				if (keypad == 4'b1010)
					state = 6'b000001;
					
				end
					
			1: 
				begin
				user2 = keypad;
				state = 6'b000010;
				end
			
			2: 
				begin
				user1 = keypad;
				state = 6'b000011;
				end
			
			3: 
				begin
				user0 = keypad;
				state = 6'b000100;
				end
				
			4: 
				begin
				if (keypad != 4'b1010)
					begin
					state = 6'b000000;
					end
				else
					//we got username
					begin
					state = 6'b000101;
					fullUser = 100 * user2 + 10 * user1 + user0;
					if (fullUser > 0 && fullUser < 129)
						begin
						address = {user2, user1, user0};
						cs = 1;
						end
					else
						state = 6'b000000;
						
					end
				end
			
			5: 
				begin
				if (keypad == 4'b1011)
					state = 6'b000110;
				else
					begin
					if (keypad == 4'b1010)
						state = 6'b000000;
					else
						begin
						//trying to login as admin
						pass3 = keypad;
						state = 6'b001101;
						end	
					end
				end
			
			6: 
				begin
				if (keypad == 4'b1010)
					state = 6'b000111;
				else
					state = 6'b000000;;
				end
					
			7: 
				begin
				pass3 = keypad;
				state = 6'b001000;
				end
			
			8: 
				begin
				pass2 = keypad;
				state = 6'b001001;
				end
				
			9: 
				begin
				pass1 = keypad;
				state = 6'b001010;
				end
				
			10: 
				begin
				pass0 = keypad;
				state = 6'b001011;
				end
				
			11: 
				begin
				if (keypad == 4'b1010)
			       state = 6'b001100;
				 else
				    state = 6'b000000;
				end
			
			
			12: 
				begin
				if (keypad == 4'b1011)
					begin
					if(lockOut)
						state = 6'b000000;
					else
						begin
						countLoad = 1;
						lockLoad = 1;
						//we got user's password
						 if (passOut == {pass3, pass2, pass1, pass0})
							begin
							logged = 1;
							countIn = 4'b0000;
							state = 6'b000000;
							end
						else
							begin
							if (countOut == 2)
								begin
								lockIn = 1;
								end
							else
								countIn = countOut + 1;
								
							error = 1;
							state = 6'b000000;
							end
						end
					end
				end
					 
			//admin handle:
			
			13:
				begin
				pass2 = keypad;
				state = 6'b001110;
				end
				
			14:
				begin
				pass1 = keypad;
				state = 6'b001111;
				end
				
			15:
				begin
				pass0 = keypad;
				state = 6'b010000;
				end
			
			16:
				begin
				if (keypad == 4'b1010)
					state = 6'b010001;
				else
					state = 6'b000000;
				end
				
			17:
				begin
				if (keypad == 4'b1011)
					begin
					if (passOut == {pass3, pass2, pass1, pass0} && adminOut == 1)
					   begin
						//admin logged in!
						state = 6'b010010;
						end
					else
						begin
						error = 1;
						state = 6'b000000;
						end
					end
				else
					state = 6'b000000;
				end
			
			18:
				begin
				if (keypad == 4'b1010)
					state = 6'b010011;
				else
					begin
					error = 1;
					state = 6'b000000;
					end
				end
				
			19:
				begin
				user2 = keypad;
				state = 6'b010100;
				end
			
			20:
				begin
				user1 = keypad;
				state = 6'b010101;
				end
					
			21:
				begin
				user0 = keypad;
				state = 6'b010110;
				end
				
			22:
				begin
				//adding user
				if (keypad == 4'b1011)
					state = 6'b010111;
				else
					begin
					//other choices
					if (keypad == 4'b1010)
						state = 6'b011101;
					else
					state = 6'b000000;
				
					end
				end
				
			23: 
				begin
				pass3 = keypad;
				state = 6'b011000;
				end
			
			24: 
				begin
				pass2 = keypad;
				state = 6'b011001;
				end
				
			25: 
				begin
				pass1 = keypad;
				state = 6'b011010;
				end
				
			26: 
				begin
				pass0 = keypad;
				state = 6'b011011;
				end
				
			27:
				begin
				if (keypad == 4'b1010)
					state = 6'b011100;
				else
					state = 6'b000000;
				end
				
			28:
				begin
				if (keypad == 4'b1011)
					begin
					//adding new user or unlocking it with new password
					fullUser = 100 * user2 + 10 * user1 + user0;
					if (fullUser > 0 && fullUser < 129)
						begin
						address = {user2, user1, user0};
						end
					else
						state = 6'b000000;
					
					countLoad = 1;
					lockLoad = 1;
					passLoad = 1;
					adminLoad = 1;
					
					passIn = {pass3, pass2, pass1, pass0};
					adminIn = 0;
					lockIn = 0;
					countIn = 4'b0000;
					
					end
				state = 6'b000000;
				end
				
			29:
				begin
				//removing
				if (keypad == 4'b1011)
				   state = 6'b011110;
				else
					begin
					if (keypad == 4'b1010)
						state = 6'b000000;
					else
						begin
						//changing admin
						pass3 = keypad;
						state = 6'b011111;
						end
					end
				
				end
			
			30:
				begin
				lockLoad = 1;
				
				fullUser = 100 * user2 + 10 * user1 + user0;
				if (fullUser > 0 && fullUser < 129)
					begin
					address = {user2, user1, user0};
					lockIn = 1;
					end
				else
					state = 6'b000000;
						
				state = 6'b000000;
				end
				
			31:
				begin 
				pass2 = keypad;
				state = 6'b100000;
				end
			
			32:
				begin 
				pass1 = keypad;
				state = 6'b100001;
				end
				
			33:
				begin 
				pass0 = keypad;
				state = 6'b100010;
				end
				
			34:
				begin 
				if (keypad == 4'b1010)
					state = 6'b100011;
				else
					state = 6'b000000;
				end
				
			35:
				begin 
				if (keypad == 4'b1011)
					begin
					
					fullUser = 100 * user2 + 10 * user1 + user0;
					if (!(fullUser > 0 && fullUser < 129))
						begin
						state = 6'b000000;
						end
					else
						begin
						if (address == {user2, user1, user0} && passOut == {pass3, pass2, pass1, pass0})
							begin
							state = 6'b100100;
							end
						
						else
							state = 6'b000000;
						end
					end

					else
					state = 6'b000000;
				end
				
			36:
				begin
				if (keypad == 4'b1010)
					state = 6'b100101;
				else
					state = 6'b000000;
				end
				
			37:
				begin
				user2 = keypad;
				state = 6'b100110;
				end
				
			38:
				begin
				user1 = keypad;
				state = 6'b100111;
				end
				
			39:
				begin
				user0 = keypad;
				state = 6'b101000;
				end
				
			40:
				begin
				if (keypad == 4'b1011)
					state = 6'b101001;
				else
					state = 6'b000000;
				end
				
			41:
				begin
				if (keypad == 4'b1011)
					begin
					//changing admin
					passLoad = 1;
					countLoad = 1;
					adminLoad = 1;
					lockLoad = 1;
					
					adminIn = 0;
					
					state = 6'b101010;
					end
					
				else
					state = 6'b000000;
				end
				
			42:
				begin
				
				fullUser = 100 * user2 + 10 * user1 + user0;
				if (fullUser > 0 && fullUser < 129)
					begin
					address = {user2, user1, user0};
					end
				else
					state = 6'b000000;
						
				countIn = 0;
				lockIn = 0;
				adminIn = 1;
				state = 6'b000000;
				end
				
		
		endcase
	
		end

endmodule

