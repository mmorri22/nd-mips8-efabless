module parity_controller_1 (
    
    input       current_bit_equals_8,
    input       shift_reg_zero_equals_0,
    input       parity_equals_0,

    input       start,
    input       clk,

    output reg  data_in_en,
    output reg  data_in_s,

    output reg  one_count_en,
    output reg  one_count_s,

    output reg  zero_count_en,
    output reg  zero_count_s,

    output reg  current_bit_en,
    output reg  current_bit_s,

    output reg  shift_reg_en,
    output reg  shift_reg_s,

    output reg  even_parity_en,
    output reg  even_parity_s,

    output reg  odd_parity_en,
    output reg  odd_parity_s,

    output reg  busy_en,
	output reg  busy_s,

    output reg parity_en,
    output reg parity_s
	);

    //states are here
    parameter WAIT          = 5'd0;
	parameter INIT          = 5'd1;
	parameter ONE_STATE     = 5'd2;
	parameter ZERO_STATE    = 5'd3;
	parameter UPDATE_BIT    = 5'd4;
	parameter CALCULATE     = 5'd5;
    parameter ODD_STATE     = 5'd6;
	parameter EVEN_STATE    = 5'd7;
    parameter FINISH        = 5'd8;
    //parameter INIT2         = 5'd9;
	
    //set to idle wait state
	reg [3:0] state = WAIT;
	reg [3:0] next_state;
	
    //always check for next state.
	always @(posedge clk)
		state <= next_state;
		
	always @(*) begin

        data_in_en = 0;
        data_in_s = 0;

        busy_en = 0;
        busy_s = 0;

        current_bit_en = 0;
        current_bit_s = 0;

        data_in_en = 0;
        data_in_s = 0;

        one_count_en = 0;
        one_count_s = 0;

        zero_count_en = 0;
        zero_count_s = 0;

        current_bit_en = 0;
        current_bit_s = 0;

        shift_reg_en = 0;
        shift_reg_s = 0;

        even_parity_en = 0;
        even_parity_s = 0;

        odd_parity_en = 0;
        odd_parity_s = 0;

        parity_en = 0;
        parity_s = 0;
		
		case (state)
			WAIT:	begin
				busy_en = 1;
				if (start)
					next_state = INIT;
				else
					next_state = WAIT;
			end
			
			INIT:	begin
                //busy <= 1
                busy_en = 1;
                busy_s = 1;

                data_in_en = 1;
                one_count_en = 1;
                zero_count_en = 1;
                current_bit_en = 1;
                shift_reg_en = 1;

                odd_parity_en = 1;
                even_parity_en = 1;
                parity_en = 1;

                //next_state = INIT2;
                if(shift_reg_zero_equals_0)
                //used to be onestate
                    next_state = ZERO_STATE;
                else
                    next_state = ONE_STATE;

			end

            //tried to see if a new cycle would fix it
            /*INIT2:  begin
                if(shift_reg_zero_equals_0)
                //used to be onestate
                    next_state = ZERO_STATE;
                else
                    next_state = ONE_STATE;
            end*/

            ONE_STATE: begin
                one_count_en = 1;
                one_count_s = 1;
                if(current_bit_equals_8)
                    next_state = CALCULATE;
                else
                    next_state = UPDATE_BIT;
            end

            ZERO_STATE: begin
                zero_count_en = 1;
                zero_count_s = 1;
                if(current_bit_equals_8)
                    next_state = CALCULATE;
                else
                    next_state = UPDATE_BIT;
            end

            UPDATE_BIT: begin
                current_bit_en = 1;
                current_bit_s = 1;
                shift_reg_en = 1;
                shift_reg_s = 1;
                if(shift_reg_zero_equals_0)
                //used to be onestte
                    next_state = ZERO_STATE;
                else
                    next_state = ONE_STATE;
            end

            CALCULATE: begin
                //one_count_en = 1;
                //one_count_s = 1;

                parity_en = 1;
                parity_s = 1;

                if(parity_equals_0)
                    next_state = EVEN_STATE;
                else
                    next_state = ODD_STATE;
            end
            //used to be odd
            ODD_STATE: begin
                odd_parity_en = 1;
                odd_parity_s = 1;
                next_state = FINISH;
            end

            EVEN_STATE: begin
                even_parity_en = 1;
                even_parity_s = 1;
                next_state = FINISH;
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


module parity_datapath_1 (
	input clk,

    input [7:0] data_in,
    //include start_en?

	input data_in_en,
    input data_in_s,

    input shift_reg_en,
    input shift_reg_s,

    input one_count_en,
    input one_count_s,

    input zero_count_en,
    input zero_count_s,

    input current_bit_en,
    input current_bit_s,

    input parity_en,
    input parity_s,

    input busy_en,
    input busy_s,

    input odd_parity_en,
    input odd_parity_s,

    input even_parity_en,
    input even_parity_s,

    output      current_bit_equals_8,
    output      parity_equals_0,
    output      shift_reg_zero_equals_0,

	output reg even_parity,
    output reg odd_parity,
	output reg busy
    
   );
   
	initial busy = 0;
	

    reg [4:0] one_count = 0;
    reg [4:0] zero_count = 0;
    reg [4:0] current_bit = 1;
    reg [7:0] shift_reg = 0;
    reg [4:0] parity = -1;
	
    
    //initial shift_reg = data_in;
    always @ (posedge clk)
		if (shift_reg_en)
			if (~shift_reg_s)
				shift_reg <= data_in;
                //Try hard coding odd parity value?
                //shift_reg <= 8'b10010001;
			else
				shift_reg <= shift_reg >> 1;
    
    //can stay same for our project too
	always @ (posedge clk)
		if (busy_en)
			if (~busy_s)
				busy <= 0;
			else
				busy <= 1;

    always @(posedge clk)
        if (one_count_en)
            if(~one_count_s)
                one_count <= 0;
            else
                one_count <= one_count + 1;

    //zero_count++
    always @(posedge clk)
        if (zero_count_en)
            if(~zero_count_s)
                zero_count <= 0;
            else
                zero_count <= zero_count + 1;

    //current_bit++
    always @(posedge clk)
        if (current_bit_en)
            if(~current_bit_s)
                current_bit <= 1;
            else
                current_bit <= current_bit + 1;

    always @(posedge clk)
        if (parity_en)
            if(~parity_s)
                parity <= 0;
            else
                parity <= one_count % 2;

    always @(posedge clk)
        if (odd_parity_en)
            if(~odd_parity_s)
                odd_parity <= 0;
            else
                odd_parity <= 1;

    always @(posedge clk)
        if (even_parity_en)
            if(~even_parity_s)
                even_parity <= 0;
            else
                even_parity <= 1;


    assign current_bit_equals_8 = (current_bit == 8);
    assign parity_equals_0 = (parity == 0);
    assign shift_reg_zero_equals_0 = (shift_reg[0] == 0);
endmodule


module parity_1 (
	
    input   clk,
    input   start,
    input [7:0] data_in,
    output even_parity,
    output odd_parity,
    output busy
);
	

    wire busy_en;
    wire busy_s;

    wire  data_in_en;
    wire  data_in_s;

    wire  one_count_en;
    wire  one_count_s;

    wire  zero_count_en;
    wire  zero_count_s;

    wire  current_bit_en;
    wire  current_bit_s;

    wire  shift_reg_en;
    wire  shift_reg_s;

    wire  even_parity_en;
    wire  even_parity_s;

    wire  odd_parity_en;
    wire  odd_parity_s;

    wire parity_en;
    wire parity_s;
	
	parity_controller_1 controller (
        .clk(clk),
        .start(start),
        .busy_en(busy_en),
        .busy_s(busy_s),

        .data_in_en(data_in_en),
        .data_in_s(data_in_s),

        .one_count_en(one_count_en),
        .one_count_s(one_count_s),

        .zero_count_en(zero_count_en),
        .zero_count_s(zero_count_s),

        .current_bit_en(current_bit_en),
        .current_bit_s(current_bit_s),

        .shift_reg_en(shift_reg_en),
        .shift_reg_s(shift_reg_s),

        .even_parity_en(even_parity_en),
        .even_parity_s(even_parity_s),

        .odd_parity_en(odd_parity_en),
        .odd_parity_s(odd_parity_s),

        .parity_en(parity_en),
        .parity_s(parity_s),

        .current_bit_equals_8(current_bit_equals_8),
        .parity_equals_0(parity_equals_0),
        .shift_reg_zero_equals_0(shift_reg_zero_equals_0)
	);
	
	parity_datapath_1 datapath (

        .clk(clk),
        //.start(start),
        
        .busy(busy),
        .even_parity(even_parity),
        .odd_parity(odd_parity),
        .data_in(data_in),

        .busy_en(busy_en),
        .busy_s(busy_s),

        .data_in_en(data_in_en),
        .data_in_s(data_in_s),

        .one_count_en(one_count_en),
        .one_count_s(one_count_s),

        .zero_count_en(zero_count_en),
        .zero_count_s(zero_count_s),

        .current_bit_en(current_bit_en),
        .current_bit_s(current_bit_s),

        .shift_reg_en(shift_reg_en),
        .shift_reg_s(shift_reg_s),

        .even_parity_en(even_parity_en),
        .even_parity_s(even_parity_s),

        .odd_parity_en(odd_parity_en),
        .odd_parity_s(odd_parity_s),

        .parity_en(parity_en),
        .parity_s(parity_s),

        .current_bit_equals_8(current_bit_equals_8),
        .parity_equals_0(parity_equals_0),
        .shift_reg_zero_equals_0(shift_reg_zero_equals_0)
	);
endmodule