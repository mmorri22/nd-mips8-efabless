/***********************
 * Modified by: David Simonetti, Thomas Mercurio, and Brooke Mackey
 * Date: 12/05/2023
 * Email: dsimone2@nd.edu
 * 
 * This file contains the modified user_proj_example provided by
 * EFabless for connecting to the Caravel Harness
 ***********************/

module rsa_3 (
 
    // Wishbone Slave ports (WB MI A)
    input clk,
 
    // IOs
    input  [15:0] io_in,
    output [15:0] io_out
);

    // inputs to chip
    wire [12:0] input_data = io_in[12:0];
    wire [2:0] input_control = io_in[15:13];
 
    // outputs of chip
    wire [15:0] output_data;
    
    // internal wires
    wire is_multiplication_done;
    wire is_init_done;
    wire is_mod_done;
    wire initialize;
    wire en_multiply;
    wire en_modulo;
    wire update_e;
    wire update_n;
    wire done;
 
    controller_3 controller_inst(
      .clk(clk),
      .input_data_type(input_control),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .is_mod_done(is_mod_done),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .update_e(update_e),
      .update_n(update_n),
      .done(done)
    );
 
    datapath_3 datapath_inst( 
      .data(input_data),
      .clk(clk),
      .initialize(initialize),
      .en_multiply(en_multiply),
      .en_modulo(en_modulo),
      .update_e(update_e),
      .update_n(update_n),
      .done(done),
      .is_multiplication_done(is_multiplication_done),
      .is_init_done(is_init_done),
      .is_mod_done(is_mod_done),
      .output_data(output_data)
    );
 
    assign io_out = output_data;
endmodule
 
module controller_3
(
  input wire clk                   ,
  input wire [2:0] input_data_type ,
  input wire is_multiplication_done,
  input wire is_init_done          ,
  input wire is_mod_done           ,
  output reg initialize            ,
  output reg en_multiply           ,
  output reg en_modulo             ,
  output reg update_e              ,
  output reg update_n              ,
  output reg done                  
);
 
    // FSM states
    reg[2:0] WAITING=3'd0, INITIALIZE=3'd1, MULTIPLY=3'd2, MODULO=3'd3, DONE=3'd4, UPDATE_N_STATE=3'd5, UPDATE_E_STATE=3'd6;
    reg[2:0] NONE=3'd0, INPUT_DATA_READY=3'd1, N_READY=3'd2, E_READY=3'd3;
 
    reg [2:0] current_state = 3'd0;
    reg [2:0] next_state = 3'd0;
    initial begin
        initialize = 1'd0;
        en_multiply = 1'd0;
        en_modulo = 1'd0;
        done = 1'd0;
    end
 
    always @(posedge clk) begin
		current_state <= next_state;
    end
 
    always @(*) begin
        initialize = 0;
        en_multiply = 0;
        en_modulo = 0;
        update_e = 0;
        update_n = 0;
        done = 0;
        next_state = WAITING;
        case(current_state)
            WAITING: begin
                if (input_data_type == NONE) 
                    next_state = WAITING;
                else if(input_data_type == INPUT_DATA_READY)
                    next_state = INITIALIZE;
                else if (input_data_type == N_READY)
                    next_state = UPDATE_N_STATE;
                else if(input_data_type == E_READY)
                    next_state = UPDATE_E_STATE;
            end
            INITIALIZE: begin
                initialize = 1;
                if (is_init_done)
                    next_state = MULTIPLY;
                else
                    next_state = INITIALIZE;
            end
            MULTIPLY: begin
                if (is_multiplication_done) 
                    next_state = DONE;
                else begin
                    en_multiply = 1;
                    next_state = MODULO;
                end
            end
            MODULO: begin
                if (is_mod_done)
                    next_state = MULTIPLY;
                else begin
                    en_modulo = 1;
                    next_state = MODULO;
                end
            end
            DONE: begin
                done = 1;
                next_state = WAITING;
            end
            UPDATE_N_STATE: begin
                update_n = 1;
                next_state = WAITING;
            end
            UPDATE_E_STATE: begin
                update_e = 1;
                next_state = WAITING;
            end
        endcase
    end
endmodule
 
module datapath_3
(
  input wire [12:0] data            ,
  input wire clk                   ,
  input wire initialize            ,
  input wire en_multiply           ,
  input wire en_modulo             ,
  input wire update_e              ,
  input wire update_n              ,
  input wire done                  ,
  output wire is_multiplication_done,
  output wire is_init_done          ,
  output wire is_mod_done           ,
  output reg [15:0] output_data
);
 
    reg [31:0] n = 3233;
    reg [31:0] e = 17;
    reg [7:0] frozen_data;
    reg [31:0] arithmetic_temp;
    reg [31:0] iterations_left;
    always @(posedge clk) 
    begin
        if (initialize) begin
            frozen_data <= data[7:0];
            arithmetic_temp <= {24'b0, data[7:0]};
            iterations_left <= e;
        end
        if (en_multiply) begin
            arithmetic_temp <= arithmetic_temp * frozen_data;
            iterations_left <= iterations_left - 1;
        end
        if (en_modulo) begin
            if (arithmetic_temp >= n)
                arithmetic_temp <= arithmetic_temp - n;
        end
        if (done) 
            output_data <= arithmetic_temp[15:0];
        if (update_e)
            e <= {19'd0, data};
        if (update_n)
            n <= {19'd0, data};
    end
 
    assign is_multiplication_done = (iterations_left == 1);
    assign is_init_done = (iterations_left == e);
    assign is_mod_done = (n > arithmetic_temp);
 
endmodule
