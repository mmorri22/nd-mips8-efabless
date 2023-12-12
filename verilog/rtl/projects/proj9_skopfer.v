module netflix (
	input clk,               			// clock
    input rst,							// reset to stop tracking current person and start with new person
    input [1:0] tl,						// 2 bit input with t and l
    output reg [14:0] output_result     	// output with 14:12  3bit person counter, 11:5 7bit week
);


// define states
localparam NS = 3'b000;	// not started
localparam S1 = 3'b001;	// season 1
localparam S2 = 3'b010;	// season 2
localparam S3 = 3'b011;	// season 3
localparam S4 = 3'b100;	// season 4
localparam S5 = 3'b101;	// season 5
localparam F = 3'b110;	// finished

// 3 bit counter for person
reg [2:0] person_counter;		// person counter
// 9 bit counter for weeks
reg [6:0] week_counter; 		// week counter
// finished variable
reg [1:0] finished;				// times finished
// state variables
reg [2:0] state;				// state
reg [2:0] next_state;			// next state
// t and l variables
reg t;							// has time
reg l;							// likes the show


// initializations
initial begin
	person_counter <= 3'b0;				// start at 0 people
	week_counter <= 7'b0;				// start at 0 weeks
	finished <= 2'b0;					// start at 0 times finished
	state <= 3'b0;					// start at not started
    //output_result <= 15'b0;	// the output is the person concat with the number of weeks concat with number of times finished concat with the state
end 

// next iteration of state machine on positive clock edge so changes happen at every clock iteration
always @(posedge clk) begin
	// if we are resetting, so new person is starting
	if (rst) begin
		// set stuff for new person
		finished <= 2'b0;						// reset times finished
		state <= NS;							// go back to not started
		person_counter <= person_counter + 1;   // increment person
	end 
	
	// tl has 2 bits, make t the leftmost bit of tl
	t <= tl[0];
	// tl has 2 bits, make l the rightmost bit of tl
	l <= tl[1];
	
	// check through states to make changes
	case(state)
		NS: begin
			if (t & l) next_state = S1;
			else next_state = NS;
		end 
		S1: begin
			if (t & l) next_state = S2;
			else next_state = S1;
		end 
		S2: begin
			if (t & l) next_state = S3;
			else next_state = S2;
		end 
		S3: begin
			if (t & l) next_state = S4;
			else next_state = S3;
		end 
		S4: begin 
		// at this point we are binging, doesn't matter if we have time
			if (l) next_state = S5;
			else next_state = S4;
		end 
		S5: begin
			// at this point, will only not move on if we dont have time and dont like it
			if (~t &~ l) next_state = S5;
			else next_state = F;
		end 
		F: begin
			// if not in forever finished state
			if (finished != 3) begin
				// increment times has finished the show
				finished <= finished + 1;
			end
			// if hasn't watched the show all the way through 3 times yet
			if (finished < 3) begin
				// may restart show so return to not started state
				next_state = NS;
			end 
			else begin
				// if has watched the show all the way through 3 times will stay in finished state
				next_state = F;
			end
		end
	endcase
	// update state
	state <= next_state;
	// update output
	output_result <= {person_counter, week_counter, finished, state};
	// update week counter
	week_counter <= week_counter + 1;
end 
endmodule