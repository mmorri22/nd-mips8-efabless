module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* Replaced with MIPS Example */
/*--------------------------------------*/

	user_proj_example mprj(

		/* Connect the vdd and vss to the risc module */
		`ifdef USE_POWER_PINS
			.vdd(vdd),	// User area 1 1.8V power
			.vss(vss),	// User area 1 digital ground
		`endif
		
		/* Inputs for wire and reset */
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		
		// IO Pads
		.io_in ({io_in[12:5]}),
		.io_out({io_in[28:13]}),
		.io_oeb({io_in[28:13]})

	);
endmodule	// user_project_wrapper

`default_nettype wire
