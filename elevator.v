`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:06 01/21/2019 
// Design Name: 
// Module Name:    Elevator 
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
module Elevator(clk, rst, keypad, inkeys, outkeys, floor, power, door);

    input [2:0] inkeys, outkeys, floor;
    input clk, rst;
    output [1:0] power;
    output door;
	 
	 //login device
	 input [3:0] keypad;
	 wire logged, error;
	 Elevator_login loginDevice(clk, keypad, logged, error);

    //regging some outputs	
    reg [1:0] power;
    reg door;
	 
    reg direction;
    reg [2:0] reqs;
    reg [2:0] state;
    
	 
    parameter baz1 = 3'b000;
    parameter baste1 = 3'b001;
    parameter baz2 = 3'b010;
    parameter baste2 = 3'b011;
    parameter baz3 = 3'b100;
    parameter baste3 = 3'b101;
	 
    
    always @ (posedge clk or posedge rst )
		begin
	
	 	if (rst == 1)
			begin
			state = baz1;
			power = 2'b00;
			door = 1;
			reqs = 3'b000;
			direction = 1;
			end
	 
	 else
	 begin
	 
	 if (logged == 1)
		begin
			  if (inkeys[2] == 1)
					reqs[2] = 1;
			  if (inkeys[1] == 1)
					reqs[1] = 1;
			  if (inkeys[0] == 1)
					reqs[0] = 1;
					
			  if (outkeys[2] == 1)
					reqs[2] = 1;
			  if (outkeys[1] == 1)
					reqs[1] = 1;
			  if (outkeys[0] == 1)
					reqs[0] = 1;
		end
		
		else
			begin
			end
	 
		
        
        case (state)
            baz1 : 
				
                if (reqs == 3'b000 | reqs[0] == 1)
                    reqs[0] = 0;
                else 
                    begin
                    state = baste1;
                    door = 0;
                    end
                        
            baste1 : if (floor == 3'b001 & reqs[0] == 1)
                        begin
                        power = 2'b00;
                        state = baz1;
                        door = 1;
                        end
                    else
                        begin
                            power = 2'b10;
                            direction = 1;
                            if (floor == 3'b010)
                                begin
                                state = baste2;
										  if (reqs[1] == 1)
										      power = 2'b00;
                                end
                                
                        end
                        
                    
                        
            baste2 : if (floor == 3'b010 & reqs[1] == 1)
                        begin
                        state = baz2;
                        power = 2'b00;
                        door = 1;
                        end
                    else 
                        begin
                        door = 0;
                        
                        if ((reqs == 3'b001 | (reqs[0] == 1 & direction == 0)))
                        begin
                            power = 2'b11;
                            direction = 0;
                            if (floor == 3'b001)
                                begin
                                state = baste1;
										  power = 2'b00;
                                end
                        end
                        
                        else 
                            if ((reqs == 3'b100 | (reqs[2] == 1 & direction == 1)))
                            begin
                            power = 2'b10;
                            direction = 1;
                            if (floor == 3'b100)
                                begin
                                state = baste3;
										  power = 2'b00;
                                end
                        end
                            
                        end
            baz2 : if (reqs == 3'b000 | reqs[1] == 1)
                        begin
                        reqs[1] = 0;
                        end
                    else 
                        begin
                        state = baste2;
                        door = 0;
                        end
                        
                        
            baste3 : if (floor == 3'b100 & reqs[2] == 1)
                        begin
                        power = 2'b00;
                        state = baz3;
                        door = 1;
                        end
                    else
                        begin
                            power = 2'b11;
                            direction = 0;
                            if (floor == 3'b010)
                                begin
                                state = baste2;
										  if (reqs[1] == 1)
										      power = 2'b00;
                                end
                                
                        end
                
            baz3 : if (reqs == 3'b000 | reqs[2] == 1)
                        begin
                        reqs[2] = 0;
                        end
                    else 
                        begin
                        state = baste3;
                        door = 0;
                        end
                        
            endcase
				
			end
		end
                        
        
endmodule
