module wrapper_4(
        input wire [7:0] char_in,
        input wire reset,
        input wire process,
        output wire match
);

wire is_num;
wire is_dash;
wire is_dot;
wire is_space;

datapath_4 d (
	.char_in (char_in),
	.is_num (is_num),
	.is_dash (is_dash),
    .is_dot (is_dot),
    .is_space (is_space)
);

controller_4 c (
	.reset (reset),
	.is_num (is_num),
	.is_dash (is_dash),
    .is_dot (is_dot),
    .is_space (is_space),
	.process (process),
	.match (match)
);

endmodule


module controller_4(
	input wire reset,
	input wire is_num,
	input wire is_dash,
    input wire is_dot,
    input wire is_space,
	input wire process,
	output wire match
);

reg [4:0] state, next_state;
initial
        state = 0;

parameter ERROR_STATE = 5'd31;

always @(posedge process)
begin
    if (reset)
        state <= 0;
    else
        state <= next_state;
end

assign match = state == 12 || state == 21 || state == 30;

always @(*)
begin
    next_state <= ERROR_STATE;
    case (state)
		0:
			if (is_num)
				next_state <= 1;
		1:
			if (is_num)
				next_state <= 2;
		2:
			if (is_num)
				next_state <= 3;
		3:
			if (is_dash)
				next_state <= 4;
            else if (is_dot)
                next_state <= 13;
            else if (is_space)
                next_state <= 22;
		4:
			if (is_num)
				next_state <= 5;
		5:
			if (is_num)
				next_state <= 6;
		6:
			if (is_num)
				next_state <= 7;
		7:
			if (is_dash)
				next_state <= 8;
		8:
			if (is_num)
				next_state <= 9;
		9:
			if (is_num)
				next_state <= 10;
		10:
			if (is_num)
				next_state <= 11;
		11:
			if (is_num)
				next_state <= 12;
		12:
			next_state <= ERROR_STATE;
		13:
			if (is_num)
				next_state <= 14;
		14:
			if (is_num)
				next_state <= 15;
		15:
			if (is_num)
				next_state <= 16;
		16:
			if (is_dot)
				next_state <= 17;
		17:
			if (is_num)
				next_state <= 18;
		18:
			if (is_num)
				next_state <= 19;
		19:
			if (is_num)
				next_state <= 20;
		20:
			if (is_num)
				next_state <= 21;
		21:
            next_state <= ERROR_STATE;
		22:
			if (is_num)
				next_state <= 23;
		23:
			if (is_num)
				next_state <= 24;
		24:
			if (is_num)
				next_state <= 25;
		25:
			if (is_space)
				next_state <= 26;
		26:
			if (is_num)
				next_state <= 27;
		27:
			if (is_num)
				next_state <= 28;
		28:
			if (is_num)
				next_state <= 29;
		29:
			if (is_num)
				next_state <= 30;
		30:
            next_state <= ERROR_STATE;
		ERROR_STATE:
			next_state <= ERROR_STATE;
		default: ;
    endcase
end

endmodule


module datapath_4(
	input wire [7:0] char_in,
	output reg is_num,
	output reg is_dash,
	output reg is_dot,
	output reg is_space
);

always @(*)
begin
	if (char_in == "-")
		is_dash = 1;
	else
		is_dash = 0;

    if (char_in == ".")
        is_dot = 1;
    else
        is_dot = 0;

    if (char_in == " ")
        is_space = 1;
    else
        is_space = 0;

	if (char_in >= "0" && char_in <= "9")
		is_num = 1;
	else
		is_num = 0;

end

endmodule
