/**************************************
* Parity Checker - AAGL
*
* Aidan Oblepias    - aoblepia@nd.edu
* Allison Gentry    - agentry2@nd.edu
* Garrett Young     - gyoung7@nd.edu
* Leo Herman        - lherman@nd.edu
*
* This is an 8-bit parity checker Verilog circuit to synthesize on the EFabless Caravel OpenLane flow using the Global Foundries gf180mcuD Process Development Kit.
**************************************/
 
 
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
 
    //States for FSM:
    localparam WAIT          = 5'd0;
    localparam INIT          = 5'd1;
    localparam ONE_STATE     = 5'd2;
    localparam ZERO_STATE    = 5'd3;
    localparam UPDATE_BIT    = 5'd4;
    localparam CALCULATE     = 5'd5;
    localparam ODD_STATE     = 5'd6;
    localparam EVEN_STATE    = 5'd7;
    localparam FINISH        = 5'd8;
    localparam INIT2         = 5'd9;
    localparam CALCULATE_2   = 5'd10;
    localparam UPDATE_BIT_2  = 5'd11;
   
    //set to idle wait state
    reg [3:0] state = WAIT;
    reg [3:0] next_state;
   
    //always check for next state.
    always @(posedge clk)
        state <= next_state;
       
    //initialize all enables and signals to 0.
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
       
       //state switcher: check every clock update
        case (state)
            WAIT:   begin
                busy_en = 1;
                if (start)
                    next_state = INIT;
                else
                    next_state = WAIT;
            end
           
            INIT:   begin
                //busy <= 1
                busy_en = 1;
                busy_s = 1;
                //init input data and internal variables
                data_in_en = 1;
                current_bit_en = 1;
                shift_reg_en = 1;
                parity_en = 1;
                //init output regs
                odd_parity_en = 1;
                even_parity_en = 1;
                // continue init on next clock update to check register values.
                next_state = INIT2;
            end
            
            //Continue initialization. Check if LSB of input is set.
            INIT2:  begin
                if(shift_reg_zero_equals_0)
                    next_state = ZERO_STATE;
                else
                    next_state = ONE_STATE;
            end
            
            //If LSB is set, update one_counter.
            ONE_STATE: begin
                one_count_en = 1;
                one_count_s = 1;
                if(current_bit_equals_8)
                    next_state = CALCULATE;
                else
                    next_state = UPDATE_BIT;
            end
 
            //If LSB is low, ensure one_count is not updated.
            ZERO_STATE: begin
                one_count_en = 0;
                one_count_s = 0;
                if(current_bit_equals_8)
                    next_state = CALCULATE;
                else
                    next_state = UPDATE_BIT;
            end
 
            //update internal counters.
            UPDATE_BIT: begin
                //don't let any more 1s be counted.
                one_count_en = 0;
                current_bit_en = 1;
                current_bit_s = 1;
                shift_reg_en = 1;
                shift_reg_s = 1;
                next_state = UPDATE_BIT_2;
            end
 
            //continue update on next clock update.
            UPDATE_BIT_2: begin
                if(shift_reg_zero_equals_0)
                    next_state = ZERO_STATE;
                else
                    next_state = ONE_STATE;
            end
 
 
            CALCULATE: begin
                //don't let any more 1s be counted.
                one_count_en = 0;
 
                parity_en = 1;
                parity_s = 1;
                
                next_state = CALCULATE_2;
            end
 
            //continue calculate on next clock update.
            CALCULATE_2: begin
                if(parity_equals_0)
                    next_state = EVEN_STATE;
                else
                    next_state = ODD_STATE;
            end
 
            //If parity is odd:
            ODD_STATE: begin
                odd_parity_en = 1;
                odd_parity_s = 1;
                next_state = FINISH;
            end
 
            //if parity is even:
            EVEN_STATE: begin
                even_parity_en = 1;
                even_parity_s = 1;
                next_state = FINISH;
            end
           
           //Lower busy signal, go back to idle until next input.
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
 
    //initial values on startup
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
            else
                shift_reg <= shift_reg >> 1;
   
    /*//busy signal and enable
    always @ (posedge clk)
        if (busy_en)
            if (~busy_s)
                busy <= 0;
            else begin
                busy <= 1;
                one_count <= 0;
            end*/
 
    //ensure one_count is reset when busy          
    /*always @ (posedge busy)
        //if (one_count)
        one_count <= 0;*/
 
    //if enabled, increment.
    always @(posedge clk) begin
        if (one_count_en) begin
            one_count <= one_count + 1;
        end
        if (busy_en) begin
            if (~busy_s)
                busy <= 0;
            else begin
                busy <= 1;
                one_count <= 0;
            end
        end
    end
 
    //current_bit++
    always @(posedge clk)
        if (current_bit_en)
            if(~current_bit_s)
                current_bit <= 1;
            else
                current_bit <= current_bit + 1;
 
    //final parity checker
    always @(posedge clk)
        if (parity_en)
            if(~parity_s)
                parity <= 0;
            else
                parity <= one_count % 2;
 
    //odd_parity output checker
    always @(posedge clk)
        if (odd_parity_en)
            if(~odd_parity_s)
                odd_parity <= 0;
            else
                odd_parity <= 1;
 
    //even_parity output checker
    always @(posedge clk)
        if (even_parity_en)
            if(~even_parity_s)
                even_parity <= 0;
            else
                even_parity <= 1;
 
    // check shortcuts.
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
	
	reg current_bit_equals_8;
	reg parity_equals_0;
	// reg shift_reg_zero_equals_0;
 
    wire parity_en;
    wire parity_s;
   
    //connect modules together
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
   
    //connect modules together.
    parity_datapath_1 datapath (
        .clk(clk),
       
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
