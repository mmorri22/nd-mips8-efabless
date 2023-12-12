module traffic (
	input 	clk,
	input 	n,
	input		e,
	input 	s,
	input		w,
	output [7:0] lights
);

	wire start_NS;
	wire wait_not_zero;
	wire swap_to_NS;
	wire swap_to_EW;
	wire next_dir_EW;
	wire en_wait;
	wire [1:0] sel_wait;
	wire en_lights;
	wire [1:0] sel_lights;
	wire en_yellow;
	wire sel_yellow;
	wire en_green;
	wire sel_green;
	wire en_next_dir;
	wire sel_next_dir;
	wire en_last_dir;
	wire sel_last_dir;

traffic_controller controller (
	.clk (clk),
	.start_NS (start_NS),
	.wait_not_zero (wait_not_zero),
	.swap_to_NS (swap_to_NS),
	.swap_to_EW (swap_to_EW),
	.next_dir_EW (next_dir_EW),
	.en_wait (en_wait),
	.sel_wait (sel_wait),
	.en_lights (en_lights),
	.sel_lights (sel_lights),
	.en_yellow (en_yellow),
	.sel_yellow (sel_yellow),
	.en_green (en_green),
	.sel_green (sel_green),
	.en_next_dir (en_next_dir),
	.sel_next_dir (sel_next_dir),
	.en_last_dir (en_last_dir),
	.sel_last_dir (sel_last_dir)
);

traffic_datapath datapath (
	.clk (clk),
	.n (n),
	.e (e),
	.s (s),
	.w (w),
	.en_wait (en_wait),
	.sel_wait (sel_wait),
	.en_lights (en_lights),
	.sel_lights (sel_lights),
	.en_yellow (en_yellow),
	.sel_yellow (sel_yellow),
	.en_green (en_green),
	.sel_green (sel_green),
	.en_next_dir (en_next_dir),
	.sel_next_dir (sel_next_dir),
	.en_last_dir (en_last_dir),
	.sel_last_dir (sel_last_dir),
	.lights (lights),
	.start_NS (start_NS),
	.wait_not_zero (wait_not_zero),
	.swap_to_NS (swap_to_NS),
	.swap_to_EW (swap_to_EW),
	.next_dir_EW (next_dir_EW)
);

endmodule


module traffic_controller (
	input clk,
	input start_NS,
	input wait_not_zero,
	input swap_to_NS,
	input swap_to_EW,
	input next_dir_EW,
	output reg en_wait,
	output reg [1:0] sel_wait,
	output reg en_lights,
	output reg [1:0] sel_lights,
	output reg en_yellow,
	output reg sel_yellow,
	output reg en_green,
	output reg sel_green,
	output reg en_next_dir,
	output reg sel_next_dir,
	output reg en_last_dir,
	output reg sel_last_dir
);
	localparam START 	= 3'b000;
	localparam SET_NS 	= 3'b001;
	localparam SET_EW 	= 3'b010;
	localparam RED 		= 3'b011;
	localparam YELLOW 	= 3'b100;
	localparam GREEN 	= 3'b101;

	reg [2:0] state = 3'd0;
	reg [2:0] next_state;


	always @(posedge clk) begin
		//set variables to 0
		state <= next_state;
		en_wait = 0;
		sel_wait = 0;
		en_lights = 0;
		sel_lights = 0;
		en_yellow = 0;
		sel_yellow = 0;
		en_green = 0;
		sel_green = 0;
		en_next_dir = 0;
		sel_next_dir = 0;
		en_last_dir = 0;
		sel_last_dir = 0;

		case (state)
			START: begin
				if(start_NS)
					next_state = SET_NS;
				else
					next_state = SET_EW;
			end
			SET_NS: begin
				en_yellow = 1;
				sel_yellow = 0; //yellow = NS
				en_green = 1;
				sel_green = 0; //green = NS
				en_last_dir = 1;
				sel_last_dir = 0; //last_dir = NS
				next_state = GREEN;
			end 
			SET_EW: begin
				en_yellow = 1;
				sel_yellow = 1; //yellow = EW
				en_green = 1;
				sel_green = 1; //green = EW
				en_last_dir = 1;
				sel_last_dir = 1; //last_dir = EW
				next_state = GREEN;
			end 
			RED: begin
				en_lights = 1;
				sel_lights = 0; //lights = 0 for red
				en_wait = 1;
				sel_wait = 2; // = wait - 1
				if(wait_not_zero)
					next_state = RED;
				else
					if(next_dir_EW)
						next_state = SET_EW;
					else
						next_state = SET_NS;
			end 
			YELLOW: begin
				en_lights = 1;
				sel_lights = 1; //lights = yellow
				en_wait = 1;
				sel_wait = 2; //wait = wait - 1
				if(wait_not_zero)
					next_state = YELLOW;
				else begin
					en_wait = 1;
					sel_wait = 0; //wait = 3
					next_state = RED;
			end
	
			end 
			GREEN: begin
				en_lights = 1;
				sel_lights = 2; //lights = green
				
				if(wait_not_zero) begin
					next_state = GREEN;
					en_wait = 1;
					sel_wait = 2; //wait = wait - 1
				end
				else begin
					en_wait = 1;
					sel_wait = 3; // set wait to 0
					if(swap_to_NS || swap_to_EW) begin
						en_next_dir = 1;
						if(swap_to_EW)
							sel_next_dir = 1; //next_dir = EW
						else if(swap_to_NS) 
							sel_next_dir = 0; //next_dir = NS
						en_wait = 1;
						sel_wait = 0; //wait = 3
						next_state = YELLOW;
					end
					else
						next_state = GREEN;

				end	
			end 
			default: ;
		endcase
	end

endmodule


module traffic_datapath (
	input clk,
	input n,
	input e,
	input s,
	input w,
	input en_wait,
	input [1:0] sel_wait,
	input en_lights,
	input [1:0] sel_lights,
	input en_yellow,
	input sel_yellow,
	input en_green,
	input sel_green,
	input en_next_dir,
	input sel_next_dir,
	input en_last_dir,
	input sel_last_dir,
	output reg [7:0] lights,
	output start_NS,
	output wait_not_zero,
	output swap_to_NS,
	output swap_to_EW,
	output next_dir_EW
);

	initial lights = 8'b00000000;

	reg [3:0] waittime = 0;
	reg [7:0] yellow = 8'b00000000;
	reg [7:0] green = 8'b00000000;
	reg next_dir = 0;
	reg last_dir = 0;

	always @(posedge clk)
		if(en_wait)
			if(sel_wait == 0)
				waittime <= 3;
			else if(sel_wait == 1)
				waittime <= 10;
			else if(sel_wait == 2)
				waittime <= waittime - 4'd1;
			else
				waittime <= 0;
		
	always @(posedge clk)
		if(en_lights)
			if(sel_lights == 0)
				lights <= 8'b00000000;
			else if(sel_lights == 1)
				lights <= yellow;
			else
				lights <= green;
		
	always @(posedge clk)
		if(en_yellow) begin
			if(sel_yellow)
				yellow <= 8'b00010001;
			else
				yellow <= 8'b01000100;
		end
		
	always @(posedge clk)
		if(en_green)
			if(sel_green)
				green <= 8'b00100010;
			else
				green <= 8'b10001000;
				
	always @(posedge clk)
		if(en_next_dir)
			if(sel_next_dir)
				next_dir <= 1;
			else
				next_dir <= 0;
		
	always @(posedge clk)
		if(en_last_dir)
			if(sel_last_dir)
				last_dir <= 1;
			else
				last_dir <= 0;

	assign start_NS = (n||s) && !(e&&w);
	assign wait_not_zero = (waittime > 0);	
	assign swap_to_NS = ((last_dir == 1) && (n||s));
	assign swap_to_EW = ((last_dir == 0) && (e||w));
	assign next_dir_EW = next_dir;
	
endmodule

