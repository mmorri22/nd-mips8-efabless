module HA_7 (input a, b, output sum, carry);


    assign sum = a ^ b;
   
    assign carry = a & b;
   
endmodule


module FA_7 (input a, b, cin, output sum, cout);


    wire n_sum, n_carry1, n_carry2;
   
    HA_7 U1( a, b, n_sum, n_carry1);
   
    HA_7 U2( n_sum, cin, sum, n_carry2);
   
    assign cout = n_carry2 | n_carry1;


endmodule

module fbf_mult_7(input [3:0] A, input [3:0] B, output [7:0] P);
	// Create wires
	wire [3:0] B0A;
    	wire [3:0] B1A;
    	wire [3:0] B2A;
    	wire [3:0] B3A;
    	wire [5:0] sum;
    	wire [8:0] carry;
	reg [7:0] P_wire;
	wire [1:0] cout;

	

	// B1 and B2 AND gates 
	assign B0A[0] = A[0] & B[0];
    	assign B0A[1] = A[1] & B[0];
    	assign B0A[2] = A[2] & B[0];
   	assign B0A[3] = A[3] & B[0];
    	assign B1A[0] = A[0] & B[1];
    	assign B1A[1] = A[1] & B[1];
    	assign B1A[2] = A[2] & B[1];
    	assign B1A[3] = A[3] & B[1];

	// Row 1 of Adders 
	HA_7 HA_71(B1A[0], B0A[1], P_wire[1], carry[0]);
    	FA_7 FA_71(B1A[1], B0A[2], carry[0], sum[0], carry[1]);
    	FA_7 FA_72(B1A[2], B0A[3], carry[1], sum[1], carry[2]);
    	HA_7 HA_72(B1A[3], carry[2], sum[2], cout[0]);

	// B2 AND gates
	assign B2A[0] = A[0] & B[2];
    	assign B2A[1] = A[1] & B[2];
	assign B2A[2] = A[2] & B[2];
    	assign B2A[3] = A[3] & B[2];

	// Row 2 of Adders
    	HA_7 HA_73(B2A[0], sum[0], P_wire[2], carry[3]);
    	FA_7 FA_73(B2A[1], sum[1], carry[3], sum[3], carry[4]);
    	FA_7 FA_74(B2A[2], sum[2], carry[4], sum[4], carry[5]);
    	FA_7 FA_75(B2A[3], cout[0], carry[5], sum[5], cout[1]); 

	// B3 AND Gates 
    	assign B3A[0] = A[0] & B[3];
    	assign B3A[1] = A[1] & B[3];
    	assign B3A[2] = A[2] & B[3];
    	assign B3A[3] = A[3] & B[3];

	// Row 3 of Adders 
	HA_7 HA_74(B3A[0], sum[3], P_wire[3], carry[6]);
    	FA_7 FA_76(B3A[1], sum[4], carry[6], P_wire[4], carry[7]);
    	FA_7 FA_77(B3A[2], sum[5], carry[7], P_wire[5], carry[8]);
    	FA_7 FA_78(B3A[3], cout[1], carry[8], P_wire[6], P_wire[7]);

	assign P_wire[0] = B0A[0];

	assign P = P_wire;
	


endmodule 


module fsm_mult(
	input clk,
	input rst,
	input[3:0] A, 
	input[3:0] B,
	output [7:0] P);

typedef enum logic[2:0]{
	IDLE = 3'd0,
	LOAD = 3'd1,
	MULTIPLY = 3'd2,
	CHECK = 3'd3,
	LOAD_P = 3'd4,
	DONE = 3'd5
}fsm_state;

// Internal signals 
	wire [3:0]B0A;
	wire [3:0]B1A;
	wire [3:0]B2A;
	wire [3:0]B3A;
	wire [5:0]sum;
	wire [5:0]carry;
	reg [3:0] A_reg;
	reg [3:0] B_reg;

	
	
//Registers for state and next_state 
	reg[1:0] state;
	reg[1:0] next_state;

// Registers for intermediate results 
	reg [7:0] P_reg;

// FBF Multipler
	fbf_mult_7 the_fbf_mult_7(
		.A(A_reg),
		.B(B_reg),
		.P(P_reg)
	);

	// assign P_reg = P_inter;

//FSM always block 
	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			state <= IDLE;
			
		end else begin 
			state <= next_state;
		end 
	end 


// State machine behavior 
	always_comb begin 
	
		case(state)
			IDLE:begin 
				A_reg<=4'b0;
				B_reg<=4'b0;
				next_state = LOAD;
			end
			LOAD:begin 
				next_state=MULTIPLY;
			end
			MULTIPLY:begin
				A_reg<=A;
				B_reg<=B;
				next_state=CHECK;
			end 
			CHECK:begin 
				if (P_reg < 15) begin
        				next_state = LOAD_P;
     				end
				else begin
        				next_state = DONE;
    				end
    			end
			LOAD_P:begin 
				B_reg = P_reg;
				next_state=MULTIPLY;
			end
			DONE:begin 
				next_state<=IDLE;
			end 
		endcase
	end 

	assign P=P_reg; 
endmodule 

