`default_nettype none

/* Locations of Student Projects */
`include "projects/proj0_morrison.v"
`include "projects/proj1_aoblepia.v"
`include "projects/proj2_akaram.v"
`include "projects/proj3_dsimone2.v"
`include "projects/proj4_evstar3.v"
`include "projects/proj5_dchirumb.v"
`include "projects/proj6_jbechte2.v"

module user_proj_example #(
	parameter DWIDTH=8, BITS = 16
)(

	`ifdef USE_POWER_PINS
		inout vdd,	// User area 1 1.8V supply
		inout vss,	// User area 1 digital ground
	`endif
	
    // Include the Caravel Ports for clk, reset, and mux select signals
    input wb_clk_i,
    input wb_rst_i,
	input wbs_we_i,				// For Proj5 mode
	input [3:0] wbs_sel_i,

    // IOs
    input  [BITS-1:0] io_in,	// 16-bits of input signals
    output [BITS-1:0] io_out,	// 16-bits of output signals
	output [BITS-1:0] io_oeb	// 16-bits OEB to set active output signals
);

	/* For mapping the wb_clk_i and wb_rst_i to our clk and rst */
    wire clk = wb_clk_i;
    wire rst = !wb_rst_i;
	wire mode = wbs_we_i;
	
	/* Set io_oeb to 0 to ensure all outputs are active */
	assign io_oeb = 1'b0;
	
	/* Set io_in to the io_in_wire */
	wire [BITS-1:0] io_in_wire = io_in;
	
	/****************************************/
	/************** Projects ****************/
	/****************************************/
	
	/* Project 0 Output signals - Prof. Morrison - MIPS 8-bit Multicycle */
	wire [BITS-1:0] proj_output0_out;	
	// All 16 outputs, so no need for setting the bits to 0

	mips the_mips(
		.clk(clk),
		.reset(rst),
		.memdata(io_in_wire[DWIDTH-1:0]),
		.adr(proj_output0_out[BITS-1:DWIDTH]),
		.writedata(proj_output0_out[DWIDTH-1:0])
	);
	
	/* Project 1 Output Signals - Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young */
	wire [BITS-1:0] proj_output1_out;
	assign proj_output1_out[BITS-1:3] = 13'b0;	// 3 output bits so set the rest (13) to 0

	parity_1 proj1(
		.clk(clk),
		.start(io_in_wire[DWIDTH]),
		.data_in(io_in_wire[DWIDTH-1:0]),
		.even_parity(proj_output1_out[2]),
		.odd_parity(proj_output1_out[1]),
		.busy(proj_output1_out[0])
	);
	
	/* Project 2 Output Signals - Antonio Karam, Sean Froning, Varun Taneja, Brendan McGinn */
	wire [BITS-1:0] proj_output2_out;
	assign proj_output2_out[BITS-1:9] = 7'b0; // 9 output bits so set the rest (7) to 0
	
	pseudo_2 proj2 (
		.clk(clk),
		.start(rst),
		.sw_in(io_in_wire[BITS-1:DWIDTH]),
		.seq_num(io_in_wire[DWIDTH-1:0]),
		.num(proj_output2_out[DWIDTH-1:0]),
		.busy(proj_output2_out[DWIDTH])
	);
	
	/* Project 3 Output Signals - David Simonetti, Thomas Mercurio, and Brooke Mackey */
	wire [BITS-1:0] proj_output3_out;
	// All 16 outputs, so no need for setting the bits to 0							
	rsa_3 proj3(
	 
		.clk(clk),
		.io_in(io_in[BITS-1:0]),
		.io_out(proj_output3_out)

	);
	
	/* Project 4 Output Signals - Evan Day, Sofia Nelson, James Lindell, Eamon Tracey */
	wire [BITS-1:0] proj_output4_out;
	assign proj_output4_out[BITS-1:1] = 15'b0; // 1 output bits so set the rest (15) to 0	
	
	wrapper_4 gamer_tag(
        .char_in(io_in_wire[7:0]),
        .reset(io_in_wire[8]),
        .process(io_in_wire[9]),
        .match(proj_output4_out[0])
	);
	
	/* Project 5 - David Chirumbole, Noor Ackhar, and Marc Edde */
	wire [BITS-1:0] proj_output5_out;
	// All 16 outputs, so no need for setting the bits to 0		
	
	encryption_co_processor proj5(
		.data_in(io_in_wire),
		.data_out(proj_output5_out),
		.clk(clk),
		.reset(rst),
		.mode(mode)
	);
	
	/* Project 6 - Josue Guerra, Steven Conaway, Nicholas Palma, Jacob Bechtel */
	wire [BITS-1:0] proj_output6_out;
	assign proj_output6_out[BITS-1:7] = 9'b0; // 7 output bits so set the rest (9) to 0	

	hangy_6 the_hangy(
		.clk(clk),
		.reset(rst),
		.chip_input(io_in_wire[11:0]),
		.chip_output(proj_output6_out[6:0])
	);

	/* The 256-16 MUX Itself */
	/* Wires connecting from Projects to the MUX */
	wire [BITS-1:0] mux_outputs;
	
	mux256_to_16 the_output_mux(
	
		.input0(proj_output0_out),	// Proj0 - Prof. Morrison Project Connection
		.input1(proj_output1_out),	// Proj1 - Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young.
		.input2(proj_output2_out),	// Proj2 - Antonion Karam, Sean Froning, Varun Taneja, Brendan McGinn.
		.input3(proj_output3_out),	// Proj3 - David Simonetti, Thomas Mercurio, and Brooke Mackey
		.input4(proj_output4_out),	// Proj4 - Evan Day, Sofia Nelson, James Lindell, Eamon Tracey
		.input5(proj_output5_out),	// Proj5 - David Chirumbole, Noor Ackhar, and Marc Edde
		.input6(proj_output6_out),	// Proj6 - Josue Guerra, Steven Conaway, Nicholas Palma, Jacob Bechtel
		.input7(16'b0),
		.input8(16'b0),
		.input9(16'b0),
		.input10(16'b0),
		.input11(16'b0),
		.input12(16'b0),
		.input13(16'b0),
		.input14(16'b0),
		.input15(16'b0),
		.sel(wbs_sel_i),
		.outputs(mux_outputs)
		
	);

	/* Map the wires to the io_out */
	assign io_out = mux_outputs;

endmodule

/******************************************************/
/************* Connection MUX *************************/
/*** Connect all 16 projects to the 16-bit output ****/
/******************************************************/
module mux256_to_16
#(
	parameter INPUTS = 16
)
(
	input  logic [INPUTS-1:0] input0, input1, input2, input3, input4, input5, input6, 
	input  logic [INPUTS-1:0] input7, input8, input9, input10, input11, input12, 
	input  logic [INPUTS-1:0] input13, input14, input15,
	input  logic [3:0]       sel, 
	output  logic [INPUTS-1:0] outputs

);

  always_comb
    case (sel)
      4'b0000: outputs = input0;
      4'b0001: outputs = input1;
      4'b0010: outputs = input2;
      4'b0011: outputs = input3;
      4'b0100: outputs = input4;
      4'b0101: outputs = input5;
      4'b0110: outputs = input6;
      4'b0111: outputs = input7;
      4'b1000: outputs = input8;
      4'b1001: outputs = input9;
      4'b1010: outputs = input10;
      4'b1011: outputs = input11;
      4'b1100: outputs = input12;
      4'b1101: outputs = input13;
      4'b1110: outputs = input14;
      4'b1111: outputs = input15;
    endcase
	
endmodule


/* End EFabless Harness project with `default_nettype wire */
`default_nettype wire