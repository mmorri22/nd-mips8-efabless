module final_project_12 (
    input clk,
    input rst,
    input [7:0] number,  //Takes in a 8 bit number
    output reg result,    //Using a register output, 0 if the number is even, 1 if the number is odd
    output reg [2:0] rem_3,     //output holding the remainer of our number divided by 3
    output reg div_3,           //output that is 1 if the nmber is divisible by 3 and 0 if it is not
    output reg [2:0] rem_4,     //output holding the remainer of our number divided by 4
    output reg div_4           //output that is 1 if the number is divisible by 4 and 0 if it is not
);

    // Below are the 7 states that we defined for our FSM
    localparam Idle = 3'b0, find_last_digit=3'b1, calculate = 3'b10, even_state = 3'b11, odd_state = 3'b100, divisible_3 = 3'b101, divisible_4 = 3'b110;
    //Idle,   //Idle state that the FSM is always in until a number is entered
    //find_last_digit,  //Give description of the state here
    //calculate,     // find whether even or odd
    //even_state,  //Give description of the state here
    //odd_state,  //Give description of the state here
    //divisible_3,     //If odd - calculate whether or not divisible by 3
    //divisible_4     //If even - calculate whether or not divisible by 4

    // state register: contains current state and next state
    reg [2:0] state, next_state;
    reg [7:0] rem_3_val, rem_4_val;
	reg [7:0] number_reg;
    reg last_bit;
    //reg new_input;

    initial begin
        state = Idle;
    end

    // Finite State machine
    always @(posedge clk or posedge rst) begin
        
            if (rst) begin
            /*
                result <= 1'b0;
                rem_3_val <= 8'b0;
                rem_3 <= 3'b0;
                div_3 <= 1'b0;
                rem_4_val <= 8'b0;
                rem_4 <= 3'b0;
                div_4 <= 1'b0;
                last_bit <= 1'b0;
            */
                state <= Idle;  // Initialize to Idle state on reset
            end
            else begin
                state <= next_state;  // Update state
            end
     end

    // Consider having a register called state - under idle state would get begin/calculate

    // Next state and state are currently flip flops



    // conditions for transistions between the states and output logic
    always @(posedge clk) begin // Double check this state
	
		number_reg = number;
	
        case (state)
            Idle: begin //state 0
                if (number_reg != 8'b00000000) begin
                    next_state = find_last_digit;
                end else begin
                    next_state = Idle;
                end
            end

            find_last_digit: begin // state 1// could just use calculate with number[0]
                //last_bit = number >> 7; // right shift to get last bit
                last_bit = number_reg[0];
                next_state = calculate;
            end

            calculate: begin //state 2
                if(number_reg[0]) begin
                    next_state = odd_state;
                end else begin
                    next_state = even_state;
                end
            end

            even_state: begin //state 3
                result = 0;
                 // if result is 0 we have an even number\\
                next_state = divisible_4;
            end

            odd_state: begin //state 4
                result = 1;
                next_state = divisible_3;
            end
			
			

            divisible_3: begin //state 5
			
				if( number_reg >= 3 ) begin 
					number_reg = number_reg - 3;
					next_state = divisible_3;
				end
				else begin
			
		
					rem_3_val = number_reg; //output holding the actual remainder after division of the number by three
					rem_3 = (rem_3_val[2:0]);
					if(rem_3_val == 0) begin
						div_3 = 1; //output div is 1 if the number is divisible by 3
					end else begin
						div_3 = 0;
					end
					next_state = Idle;
				
				end 
            end

            divisible_4: begin //state 6
			
				if( number_reg >= 4 ) begin 
					number_reg = number_reg - 4;
					next_state = divisible_4;
				end				
				else begin
					rem_4_val = number_reg;
					rem_4 = (rem_4_val[2:0]);
					if(rem_4_val == 0) begin
						 div_4 = 1; //output div is 1 if the number is divisible by 4
					end else begin
						 div_4 = 0;
					end
					next_state = Idle;
				end 
            end

        endcase
    end
endmodule