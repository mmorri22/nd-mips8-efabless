module encryption_co_processor(
    input [15:0] data_in,
    output [15:0] data_out,
    input clk,
    input reset,
    input mode
);

wire [2:0] state_from_controller_to_datapath;
wire [2:0] state_from_datapath_to_controller;
wire mode_from_controller_to_datapath;


datapath_5 datapath(
    .data_in(data_in),
    .data_out(data_out),
    .state(state_from_controller_to_datapath),
    .new_state(state_from_datapath_to_controller),
    .mode(mode_from_controller_to_datapath),
	.clk(clk),
    .reset(reset)
);

controller_5 controller(
    .mode_in(mode),
    .mode_out(mode_from_controller_to_datapath),
    .reset(reset),
    .clk(clk),
    .state_out(state_from_controller_to_datapath),
    .state_in(state_from_datapath_to_controller)
);

endmodule






module encrypt_1(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
//    output reg [2:0] state
);
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;
//            state <= 3'b001;
        end else begin
            // Scramble bits (permutation)
            data_out <= {data_in[15], data_in[10], data_in[5], data_in[0],
                         data_in[14], data_in[9], data_in[4], data_in[11],
                         data_in[13], data_in[8], data_in[3], data_in[12],
                         data_in[7], data_in[2], data_in[1], data_in[6]};
        end
    end
endmodule





module encrypt_2(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
//    output reg [2:0] state
);
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;
//            state <= 3'b001;
        end else begin
            // Scramble bits (permutation)
            data_out <= {data_in[0], data_in[2], data_in[4], data_in[6],
                         data_in[8], data_in[10], data_in[12], data_in[14],
                         data_in[1], data_in[3], data_in[5], data_in[7],
                         data_in[9], data_in[11], data_in[13], data_in[15]};
        end
    end
endmodule




module decrypt_1(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
//    output reg [2:0] state
);
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;
//            state <= 3'b001;
        end else begin
            // Unscramble bits (permutation)
            data_out <= {data_in[3], data_in[14], data_in[13], data_in[10],
                         data_in[6], data_in[2], data_in[15], data_in[12],
                         data_in[9], data_in[5], data_in[1], data_in[7],
                         data_in[11], data_in[8], data_in[4], data_in[0]};
        end
    end
endmodule





module decrypt_2(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
//    output reg [2:0] state
);
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;
//            state <= 3'b001;
        end else begin
            // Unscramble bits (permutation)
            data_out <= {data_in[0], data_in[8], data_in[1], data_in[9],
                         data_in[2], data_in[10], data_in[3], data_in[11],
                         data_in[4], data_in[12], data_in[5], data_in[13],
                         data_in[6], data_in[14], data_in[7], data_in[15]};
        end
    end
endmodule






module datapath_5(
    input [15:0] data_in,
    output reg [15:0] data_out,
    input [2:0] state,
    output reg [2:0] new_state,
    input mode,
	 input clk,
    input reset
);
    // will hold the current value of data
    reg [15:0] data_register;
    reg [15:0] encrypt_1_register;
    reg [15:0] encrypt_2_register;
    reg [15:0] decrypt_1_register;
    reg [15:0] decrypt_2_register;
	 wire [15:0] to_en_1;
	 wire [15:0] to_en_2;
	 wire [15:0] to_de_1;
	 wire [15:0] to_de_2;

    encrypt_1 encrypt_1(
        .clk(clk),
        .reset(reset),
        .data_in(data_register),
        .data_out(to_en_1)
//        .state(state)
    );
    encrypt_2 encrypt_2(
        .clk(clk),
        .reset(reset),
        .data_in(data_register),
        .data_out(to_en_2)
//        .state(state)
    );
    decrypt_1 decrypt_1(
        .clk(clk),
        .reset(reset),
        .data_in(data_register),
        .data_out(to_de_1)
//        .state(state)
    );
    decrypt_2 decrypt_2(
        .clk(clk),
        .reset(reset),
        .data_in(data_register),
        .data_out(to_de_2)
//        .state(state)
    );

    always @(posedge clk) begin
			encrypt_1_register <= to_en_1;
			encrypt_2_register <= to_en_2;
			decrypt_1_register <= to_de_1;
			decrypt_2_register <= to_de_2;
			data_out <= data_register;
        if (reset) begin
            new_state <= 3'b001; // move to the reset state
        end 
        
        else begin

            // start state
            case (state)
                3'b000: begin
                    if (mode == 1'b1)
                        new_state <= 3'b101;
                    else if (mode == 1'b0)
                        new_state <= 3'b011;
                end
                
                // reset state
                3'b001: begin
                    new_state <= 3'b000;
                end

                // finish state
                3'b010: begin
                    new_state <= 3'b000;
                end



                // encrypt_1 state
                3'b011: begin
                    if (reset)
                        new_state <= 3'b001;
                                        
                    else
                        data_register <= encrypt_1_register;
                        new_state <= 3'b100;
                end

                // encrypt_2 state
                3'b100: begin
                    if (reset)
                        new_state <= 3'b001;
                                        
                    else 
                        data_register <= encrypt_2_register;
                        new_state <= 3'b010;
                end

                // decrypt_1 state
                3'b101: begin
                    if (reset)
                        new_state <= 3'b001;
                                        
                    else 
                        data_register <= decrypt_1_register;
                        new_state <= 3'b110;
                end

                // decrypt_2 state
                3'b110: begin
                    if (reset)
                        new_state <= 3'b001;
                                        
                    else 
                        data_register <= decrypt_2_register;
                        new_state <= 3'b010;
                end

                // default state
                default: begin
                    // Default case
                    new_state <= 3'b000;
                end
            
            endcase
        end
    end

endmodule

module controller_5(
    input mode_in,
    output mode_out,
    input reset,
    input clk,
    output [2:0] state_out,
    input [2:0] state_in
);
    reg [2:0] state_register;
    
    reg mode_reg;

    assign mode_out = mode_reg;
    always @(posedge clk) begin
        mode_reg <= mode_in;
    end

    
    assign state_out = state_register;
    always @(posedge clk) begin
        state_register <= state_in;
		  
    end





endmodule
