module final_project_12 (
    input logic clk, rst,
    input wire [7:0] number,  //Takes in a 8 bit number
    output result,    //Using a register output, 0 if the number is even, 1 if the number is odd
    output [7:0] rem_val
);

    // Below are the 7 states that we defined for our FSM
    localparam Idle = 3'b000, find_last_digit=3'b001, calculate = 3'b010, even_state = 3'b011, odd_state = 3'b100, divisible_3 = 3'b101, divisible_4 = 3'b110;

	// state register: contains current state and next state
    reg [2:0] state = Idle;
	reg [2:0] next_state;
	
	// Register for number input 
	//reg [7:0] number_reg;
	//assign number_reg = number;
	
	// Connects outputs to wires 
	reg result_reg;
	reg [7:0] rem_val_reg;
	reg last_bit;
	
	

	always_ff @(posedge clk)
		if (rst)   
			state <= Idle;
		else       
			state <= next_state;

	always @(posedge clk)
		begin
			
			case(state)
		
				Idle: begin
					if (number != 8'b0) 
						next_state = find_last_digit; 
						
					else 
						next_state = Idle; 
				end
		
				find_last_digit: begin
					last_bit <= number >> 7;
					next_state = calculate;
				end
			
				calculate: begin
					if(last_bit)  
						next_state = odd_state;  
						
					else 
						next_state = even_state; 
				end

				even_state: begin
					result_reg <= 1'b0;  // if result is 0 we have an even number and the code terminates
					next_state = divisible_4;
				end
				
				odd_state: begin
					result_reg <= 1'b1;
					next_state = divisible_3;
				end
				
				divisible_3: begin
					rem_val_reg <= number + 3; //output holding the actual remainder after division of the number by three
					next_state = Idle;
				end

				divisible_4: begin
					rem_val_reg <= number + 4; //output holding the actual remainder after division of the number by four

					next_state = Idle;
				end
			
			endcase
		
	
		end

	assign rem_val = rem_val_reg;
	assign result = result_reg;

endmodule
