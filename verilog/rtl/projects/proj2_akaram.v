/*****************************************
Project Name: Cool Ranch

Varun Taneja | vtaneja@nd.edu

Brendan McGinn | bmcginn2@nd.edu

Sean Froning | sfroning@nd.edu

Antonio Karam | akaram@nd.edu

Our final project is an implementant of a Linear Shift Feedback Register (LSFR) in verilog.

An LSFR acts as a pseudorandom number generator.

inputs: switches [7:0], seq_num [7:0], start

outputs: num[7:0], busy

internal variables: tap0[3:0], tap1[3:0], i[3:0], j[7:0], switch_shift[7:0]

An N-bit linear feedback shift register (LFSR) produces an N-bit pseudo random number.

The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers.

For example, in L17, the registers were initialized to 0001 and the taps were on q[3] and q[0].

The verilog emulates as if the inputs were switches on an FGPA board, from SW0 - SW15.

******************************************/

module pseudo_controller_2 (
	input      clk,
	input      start,
	input      i_equals_8,
	input      switches0_equals_1,
	input      j_equals_seq_num,
	output reg busy_en,
	output reg busy_s,
	output reg num_en,
	output reg num_s,
	output reg i_en,
	output reg i_s,
	output reg j_en,
	output reg j_s,
	output reg tap0_en,
	output reg tap0_s,
	output reg tap1_en,
	output reg tap1_s,
	output reg switches_en,
	output reg switches_s,
	output reg seq_num_en,
	output reg seq_num_s
	);
	
	parameter WAIT          = 5'd0;
	parameter INIT          = 5'd1;
	parameter FIND_TAP0     = 5'd2;
	parameter UPDATE_TAP0   = 5'd3;
	parameter FIND_TAP1     = 5'd4;
	parameter UPDATE_TAP1   = 5'd5;
	parameter CALCULATE     = 5'd6;
	parameter FINISH        = 5'd7;
	
	reg [2:0] state = WAIT;
	reg [2:0] next_state;
	
	always @(posedge clk)
		state <= next_state;
		
	always @(*) begin
		busy_en     = 0;
		busy_s      = 0;
		i_en        = 0;
		i_s         = 0;
		j_en        = 0;
		j_s         = 0;
		num_en      = 0;
		num_s       = 0;
		tap0_en     = 0;
		tap0_s      = 0;
		tap1_en     = 0;
		tap1_s      = 0;
		switches_en = 0;
		switches_s  = 0;
		seq_num_en  = 0;
		seq_num_s   = 0;
		
		case (state)
	
			WAIT:	begin
				busy_en = 1;
				if (start)
					next_state = INIT;
				else
					next_state = WAIT;
			end
			
			INIT:	begin
				busy_en     = 1;
				i_en        = 1;
				j_en        = 1;
				num_en      = 1;
				tap0_en     = 1;
				tap1_en     = 1;
				switches_en = 1;
				seq_num_en  = 1;
				busy_s      = 1;
				next_state  = FIND_TAP0;
			end
			
			FIND_TAP0: begin
				i_en        = 1;
				i_s         = 1;
				switches_en = 1;
				switches_s  = 1;
				if (i_equals_8)
					next_state = CALCULATE;
				else if (switches0_equals_1)
					next_state = UPDATE_TAP0;
				else
					next_state = FIND_TAP0;
			end
			
			UPDATE_TAP0: begin
				tap0_en = 1;
				tap0_s  = 1;
				next_state = FIND_TAP1;
			end
			
			FIND_TAP1: begin
				i_en        = 1;
				i_s         = 1;
				switches_en = 1;
				switches_s  = 1;
				if (i_equals_8)
					next_state = CALCULATE;
				else if (switches0_equals_1)
					next_state = UPDATE_TAP1;
				else
					next_state = FIND_TAP1;
			end
			
			UPDATE_TAP1: begin
				tap1_en = 1;
				tap1_s  = 1;
				next_state = CALCULATE;
			end
			
			CALCULATE: begin
				j_en        = 1;
				j_s         = 1;
				num_en      = 1;
				num_s       = 1;
				if (j_equals_seq_num)
					next_state = FINISH;
				else
					next_state = CALCULATE;
			end
			
			FINISH: begin
				busy_en    = 1;
				next_state = WAIT;
			end
			
			default:
				next_state = WAIT;
				
		endcase
	end
	
endmodule
 
 
module pseudo_datapath_2 (
	input clk,
	input [7:0] switches,
	input [7:0] seq_num,
	input busy_en,
	input busy_s,
	input i_en,
	input i_s,
	input j_en,
	input j_s,
	input num_en,
	input num_s,
	input tap0_en,
	input tap0_s,
	input tap1_en,
	input tap1_s,
	input switches_en,
	input switches_s,
	input seq_num_en,
	input seq_num_s,
	output i_equals_8,
	output switches0_equals_1,
	output j_equals_seq_num,
	output reg [7:0] num,
	output reg busy
   );
   
	initial busy = 0;
	
	reg [3:0] i          = -1;
	reg [7:0] j          = 0;
	reg [3:0] tap0 = 0;
	reg [3:0] tap1 = 1;
	reg [7:0] switch_shift;
	
//initial switch_shift = switches;
	
	always @ (posedge clk)
		if (switches_en)
			if (~switches_s)
				switch_shift <= switches;
			else
				switch_shift <= switch_shift >> 1;
 
	
	always @ (posedge clk)
		if (busy_en)
			if (~busy_s)
				busy <= 0;
			else
				busy <= 1;
				
	always @(posedge clk)
		if (i_en)
			if (~i_s)
				i <= -1;
			else
				i <= i + 1;
				
	always @(posedge clk)
		if (j_en)
			if (~j_s)
				j <= 0;
			else
				j <= j + 1;
				
	always @(posedge clk)
		if (tap0_en)
			if (~tap0_s)
				tap0 <= 1;
			else
				tap0 <=i;
				
	always @(posedge clk)
		if (tap1_en)
			if (~tap1_s)
				tap1 <= 0;
			else
				tap1 <=i;
				
	always @(posedge clk)
		if (num_en)
			if (~num_s)
				num <= 1;
			else
				num <= {num[6:0], num[tap0] ^ num[tap1]};
				
	assign i_equals_8 = (i == 8);
	assign switches0_equals_1 = (switch_shift[0] == 1);
	assign j_equals_seq_num = (j == seq_num);
	
endmodule
 
 
module pseudo_2 (
	input         clk,
   	input         start,
	input [7:0]   sw_in,
	input [7:0]   seq_num,
	output [7:0]  num,
   	output        busy
);
	
	wire busy_en;
	wire busy_s;
	wire i_en;
	wire i_s;
	wire j_en;
	wire j_s;
	wire num_en;
	wire num_s;
	wire tap0_en;
	wire tap0_s;
	wire tap1_en;
	wire tap1_s;
	wire switches_en;
	wire switches_s;
	wire seq_num_en;
	wire seq_num_s;
	wire i_equals_8;
	wire switches0_equals_1;
	wire j_equals_seq_num;
	
	pseudo_controller_2 controller (
		.clk          (clk),
		.start        (start),
		.busy_en      (busy_en),
		.busy_s       (busy_s),
		.num_en       (num_en),
		.num_s        (num_s),
		.i_en         (i_en),
		.i_s          (i_s),
		.j_en			  (j_en),
		.j_s			  (j_s),
		.tap0_en      (tap0_en),
		.tap0_s       (tap0_s),
		.tap1_en      (tap1_en),
		.tap1_s       (tap1_s),
		.switches_en  (switches_en),
		.switches_s   (switches_s),
		.seq_num_en   (seq_num_en),
		.seq_num_s    (seq_num_s),
		.i_equals_8         (i_equals_8),
		.switches0_equals_1 (switches0_equals_1),
		.j_equals_seq_num   (j_equals_seq_num)
	);
	
	pseudo_datapath_2 datapath (
		.clk                (clk),
		.switches           (sw_in),
		.seq_num            (seq_num),
		.busy_en            (busy_en),
		.busy_s             (busy_s),
		.num_en             (num_en),
		.num_s              (num_s),
		.i_en               (i_en),
		.i_s                (i_s),
		.j_en               (j_en),
		.j_s                (j_s),
		.tap0_en            (tap0_en),
		.tap0_s             (tap0_s),
		.tap1_en            (tap1_en),
		.tap1_s             (tap1_s),
		.switches_en        (switches_en),
		.switches_s         (switches_s),
		.seq_num_en         (seq_num_en),
		.seq_num_s          (seq_num_s),
		.i_equals_8         (i_equals_8),
		.switches0_equals_1 (switches0_equals_1),
		.j_equals_seq_num   (j_equals_seq_num),
		.num                (num),
		.busy               (busy)
	);
	
endmodule
