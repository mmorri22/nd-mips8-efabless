module final_path_8 (
	input clk,
	input R,
	input C,
	input in_EN,
	output out_NR,
	output out_NG,
	output out_NY,
	output out_ER,
	output out_EG,
	output out_EY
);

	wire s_NR;
	wire en_NR;
	wire s_NG;
	wire en_NG;
	wire s_NY;
	wire en_NY;
	wire s_ER;
	wire en_ER;
	wire s_EG;
	wire en_EG;
	wire s_EY;
	wire en_EY;
	wire [1:0]s_IC;
	wire en_IC;	
	wire out_IC;
	
	wire rcos;
	wire rcol;

	wire not_r;
	wire c_and_l;
	wire en_s;
	wire l_or_notc;

	final_datapath_8 the_datapath(
		.R (R),
		.C (C),
		.S (rcos),
		.L (rcol),
		.clk (clk),
		.s_NR (s_NR),
		.en_NR (en_NR),
		.s_NG (s_NG),
		.en_NG (en_NG),
		.s_NY (s_NY),
		.en_NY (en_NY),
		.s_ER (s_ER),
		.en_ER (en_ER),
		.s_EG (s_EG),
		.en_EG (en_EG),
		.s_EY (s_EY),
		.en_EY (en_EY),
		.s_IC (s_IC),
		.en_IC (en_IC),
		.out_NR (out_NR),
		.out_NG (out_NG),
		.out_NY (out_NY),
		.out_ER (out_ER),
		.out_EG (out_EG),
		.out_EY (out_EY),
		.out_IC (out_IC),	
		.not_r (not_r),
		.c_and_l (c_and_l),
		.en_s (en_s),
		.l_or_notc (l_or_notc)
	);

	final_controller_8 the_controller(
		.clk (clk),
		.not_r (not_r),
		.c_and_l (c_and_l),
		.en_s (en_s),
		.l_or_notc (l_or_notc),
		.s_NR (s_NR),
		.en_NR (en_NR),
		.s_NG (s_NG),
		.en_NG (en_NG),
		.s_NY (s_NY),
		.en_NY (en_NY),
		.s_ER (s_ER),
		.en_ER (en_ER),
		.s_EG (s_EG),
		.en_EG (en_EG),
		.s_EY (s_EY),
		.en_EY (en_EY),
		.s_IC (s_IC),
		.en_IC (en_IC)
	);

	counter_8 the_counter(
		.clk (clk),
		.in_EN (in_EN),
		.clr (out_IC),
		.rcos (rcos),
		.rcol (rcol)
	);

endmodule


module final_controller_8(
		input clk,
		input not_r,
		input c_and_l,
		input en_s,
		input l_or_notc,
		output reg s_NR,
		output reg en_NR,
		output reg s_NG,
		output reg en_NG,
		output reg s_NY,
		output reg en_NY,
		output reg s_ER,
		output reg en_ER,
		output reg s_EG,
		output reg en_EG,
		output reg s_EY,
		output reg en_EY,
		output reg [1:0]s_IC,
		output reg en_IC
	);

	localparam RR1 = 4'b0000;
	localparam GR = 4'b0001;
	localparam YR = 4'b0010;
	localparam RR2 = 4'b0011;
	localparam RG = 4'b0100;
	localparam RY = 4'b0101;

	reg [3:0] state, next_state;
	initial state = RR1;

	//always @(posedge clk)
		//state <= next_state;

	always_ff@(posedge clk) begin
	
		state <= next_state;
		s_NR = 0;
		en_NR = 0;
		s_NG = 0;
		en_NG = 0;
		s_NY = 0;
		en_NY = 0;
		s_ER = 0;
		en_ER = 0;
		s_EG = 0;
		en_EG = 0;
		s_EY = 0;
		en_EY = 0;
		s_IC = 2'b00;
		en_IC = 0;
		case(state)
			RR1: begin
				s_IC = 2'b01;
				en_IC = 1;
				s_NR = 1;
				en_NR = 1;
				s_NG = 0;
				en_NG = 1;
				s_NY = 0;
				en_NY = 1;
				s_ER = 1;
				en_ER = 1;
				s_EG = 0;
				en_EG = 1;
				s_EY = 0;
				en_EY = 1;
				if (not_r)
					next_state = GR;
				else
					next_state = RR1;
			end
			GR: begin
				s_IC = 2'b10;
				en_IC = 1;
				s_NR = 0;
				en_NR = 1;
				s_NG = 1;
				en_NG = 1;
				s_NY = 0;
				en_NY = 1;
				s_ER = 1;
				en_ER = 1;
				s_EG = 0;
				en_EG = 1;
				s_EY = 0;
				en_EY = 1;
				if (c_and_l)
					next_state = YR;
				else
					next_state = GR;
			end
			YR: begin
				s_IC = 2'b00;
				en_IC = 1;
				s_NR = 0;
				en_NR = 1;
				s_NG = 0;
				en_NG = 1;
				s_NY = 1;
				en_NY = 1;
				s_ER = 1;
				en_ER = 1;
				s_EG = 0;
				en_EG = 1;
				s_EY = 0;
				en_EY = 1;
				if (en_s)
					next_state = RR2;
				else
					next_state = YR;
			end
			RR2: begin
				s_IC = 2'b01;
				en_IC = 1;
				s_NR = 1;
				en_NR = 1;
				s_NG = 0;
				en_NG = 1;
				s_NY = 0;
				en_NY = 1;
				s_ER = 1;
				en_ER = 1;
				s_EG = 0;
				en_EG = 1;
				s_EY = 0;
				en_EY = 1;
				if (not_r)
					next_state = RG;
				else
					next_state = RR2;
			end
			RG: begin
				s_IC = 2'b11;
				en_IC = 1;
				s_NR = 1;
				en_NR = 1;
				s_NG = 0;
				en_NG = 1;
				s_NY = 0;
				en_NY = 1;
				s_ER = 0;
				en_ER = 1;
				s_EG = 1;
				en_EG = 1;
				s_EY = 0;
				en_EY = 1;
				if (l_or_notc)
					next_state = RY;
				else
					next_state = RG;
			end
			RY: begin
				s_IC = 2'b00;
				en_IC = 1;
				s_NR = 1;
				en_NR = 1;
				s_NG = 0;
				en_NG = 1;
				s_NY = 0;
				en_NY = 1;
				s_ER = 0;
				en_ER = 1;
				s_EG = 0;
				en_EG = 1;
				s_EY = 1;
				en_EY = 1;
				if (en_s)
					next_state = RR1;
				else
					next_state = RY;
			end
			//default: begin
			//end
		endcase
	end

endmodule


module final_datapath_8 (
	input R,
	input C,
	input S,
	input L,
	input clk,
	input s_NR,
	input en_NR,
	input s_NG,
	input en_NG,
	input s_NY,
	input en_NY,
	input s_ER,
	input en_ER,
	input s_EG,
	input en_EG,
	input s_EY,
	input en_EY,
	input [1:0]s_IC,
	input en_IC,
	output reg out_NR,
	output reg out_NG,
	output reg out_NY,
	output reg out_ER,
	output reg out_EG,
	output reg out_EY,
	output reg out_IC,
	output not_r,
	output c_and_l,
	output en_s,
	output l_or_notc
	);

	always @(posedge clk)
		if (en_NR)
			if (s_NR == 0)
				out_NR <= 0;
			else if (s_NR == 1)
				out_NR <= 1;
	always @(posedge clk)
		if (en_NG)
			if (s_NG == 0)
				out_NG <= 0;
			else if (s_NG == 1)
				out_NG <= 1;
	always @(posedge clk)
		if (en_NY)
			if (s_NY == 0)
				out_NY <= 0;
			else if (s_NY == 1)
				out_NY <= 1;
	always @(posedge clk)
		if (en_ER)
			if (s_ER == 0)
				out_ER <= 0;
			else if (s_ER == 1)
				out_ER <= 1;
	always @(posedge clk)
		if (en_EG)
			if (s_EG == 0)
				out_EG <= 0;
			else if (s_EG == 1)
				out_EG <= 1;
	always @(posedge clk)
		if (en_EY)
			if (s_EY == 0)
				out_EY <= 0;
			else if (s_EY == 1)
				out_EY <= 1;
	always @(posedge clk)
		if (en_IC)  //Inverse everything because that is the input to counter_8.
			if (s_IC == 2'b00)
				out_IC <= 1;
			else if (s_IC == 2'b01)
				out_IC <= R;
			else if (s_IC == 2'b10)
				out_IC <= ~(L & C);
			else if (s_IC == 2'b11)
				out_IC <= ~(L + ~C);

	assign not_r = ~R;
	assign c_and_l = C & L;
	assign en_s = S;
	assign l_or_notc = L | ~C;

endmodule


module counter_8(
	input clk,
	input in_EN,
	input clr,
	output rcos,
	output rcol);

	wire qQ1, qQ2, qQ3, qQ4, t1, t2;

	jk_ff_8 jk1(in_EN, in_EN, clk, clr, qQ1);
	and a1(t1, in_EN, qQ1);
	jk_ff_8 jk2(t1, t1, clk, clr, qQ2);
	and a2(t2, t1, qQ2);
	jk_ff_8 jk3(t2, t2, clk, clr, qQ3);
	and a3(rcos, t2, qQ3);
	jk_ff_8 jk4(rcos, rcos, clk, clr, qQ4);
	and a4(rcol, rcos, qQ4);


endmodule




module jk_ff_8(
	input j,
	input k,
	input clk,
	input clr,
	output reg q);

	always @(posedge clk) begin
		
		if (!clr) begin
			q <= 1'b0;
		end
		else begin
			case({j,k})
				2'b00 : q <= q;
				2'b01 : q <= 0;
				2'b10 : q <= 1;
				2'b11 : q <= ~q;
			endcase
		end
	end

endmodule

