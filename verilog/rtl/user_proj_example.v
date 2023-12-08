`default_nettype none

module user_proj_example #(
	parameter AWIDTH=5, DWIDTH=8, BITS = 16
)(

	`ifdef USE_POWER_PINS
		inout vdd,	// User area 1 1.8V supply
		inout vss,	// User area 1 digital ground
	`endif
	
    // Include the Caravel Ports to connect the inputs and outputs
    input wb_clk_i,
    input wb_rst_i,
	input [3:0] wbs_sel_i,

    // IOs
    input  [BITS-1:0] io_in,
    output [BITS-1:0] io_out,
	output [BITS-1:0] io_oeb,
);

	/* For mapping the wb_clk_i and wb_rst_i to our clk and rst */
    wire clk = wb_clk_i;
    wire rst = !wb_rst_i;
	
	/* Set io_oeb to 0 to ensure all outputs are active */
	assign io_oeb = 1'b0;
	
	/* Set io_in to the io_in_wire */
	wire [BITS-1:0] io_in_wire = io_in;
	assign io_in_wire[BITS-1:DWIDTH+1] = 7'b0;
	
	/****************************************/
	/*************	Projects ****************/
	
	/* Project 0 Output signals - Prof. Morrison */
	wire [BITS-1:0] proj_output0_out;	// Prof. Morridon
	
	/* Project 1 Output Signals - Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young */
	wire [BITS-1:0] proj_output1_out;
	assign proj_output1_out[BITS-1:3] = 13'b0;	// Only 3 output bits so set the rest to 0
	
	/* Wires connecting from Projects to the MUX */
	wire [BITS-1:0] mux_outputs;
	
	/* input0 - Prof. Morrison - MIPS 8-bit Multicycle */
	mips the_mips(
		.clk(clk),
		.reset(rst),
		.memdata(io_in_wire[DWIDTH-1:0]),
		.adr(proj_output0_out[BITS-1:DWIDTH]),
		.writedata(proj_output0_out[DWIDTH-1:0])
	);
	
	/* input1 - Aidan XXXX - */
	parity proj1(
		.clk(clk),
		.start(io_in_wire[DWIDTH]),
		.data_in(io_in_wire[DWIDTH-1:0]),
		.even_parity(proj_output1_out[2]),
		.odd_parity(proj_output1_out[1]),
		.busy(proj_output1_out[0])
	);
	

	/* The 256-16 MUX Itself */
	mux256_to_16 the_output_mux(
	
		.input0(proj_output0_out),	// Prof. Morrison Project Connection
		.input1(proj_output1_out),	// Aidan Oblepias et al.
		.input2(16'b0),
		.input3(16'b0),
		.input4(16'b0),
		.input5(16'b0),
		.input6(16'b0),
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

/********************************************************/
/********************* Project 0 ************************/

// states and instructions

  typedef enum logic [3:0] {FETCH1 = 4'b0000, FETCH2, FETCH3, FETCH4,
                            DECODE, MEMADR, LBRD, LBWR, SBWR,
                            RTYPEEX, RTYPEWR, BEQEX, JEX} statetype;
  typedef enum logic [5:0] {LB    = 6'b100000,
                            SB    = 6'b101000,
                            RTYPE = 6'b000000,
                            BEQ   = 6'b000100,
                            J     = 6'b000010} opcode;
  typedef enum logic [5:0] {ADD = 6'b100000,
                            SUB = 6'b100010,
                            AND = 6'b100100,
                            OR  = 6'b100101,
                            SLT = 6'b101010} functcode;


// simplified MIPS processor
module mips #(parameter WIDTH = 8, REGBITS = 3)
             (input  logic             clk, reset, 
              input  logic [WIDTH-1:0] memdata, 
              output logic [WIDTH-1:0] adr, writedata);

   logic [31:0] instr;
   logic        zero, alusrca, memtoreg, iord, pcen, regwrite, regdst, memread, memwrite;
   logic [1:0]  pcsrc, alusrcb;
   logic [3:0]  irwrite;
   logic [2:0]  alucontrol;
   logic [5:0]  op, funct;
 
   assign op = instr[31:26];      
   assign funct = instr[5:0];  
      
   controller  cont(clk, reset, op, funct, zero, memread, memwrite, 
                    alusrca, memtoreg, iord, pcen, regwrite, regdst,
                    pcsrc, alusrcb, alucontrol, irwrite);
   datapath    #(WIDTH, REGBITS) 
               dp(clk, reset, memdata, alusrca, memtoreg, iord, pcen,
                  regwrite, regdst, pcsrc, alusrcb, irwrite, alucontrol,
                  zero, instr, adr, writedata);
endmodule

module controller(input logic clk, reset, 
                  input  logic [5:0] op, funct,
                  input  logic       zero, 
                  output logic       memread, memwrite, alusrca,  
                  output logic       memtoreg, iord, pcen, 
                  output logic       regwrite, regdst, 
                  output logic [1:0] pcsrc, alusrcb,
                  output logic [2:0] alucontrol,
                  output logic [3:0] irwrite);

  statetype       state;
  logic           pcwrite, branch;
  logic     [1:0] aluop;

  // control FSM
  statelogic statelog(clk, reset, op, state);
  outputlogic outputlog(state, memread, memwrite, alusrca,
                        memtoreg, iord, 
                        regwrite, regdst, pcsrc, alusrcb, irwrite, 
                        pcwrite, branch, aluop);

  // other control decoding
  aludec  ac(aluop, funct, alucontrol);
  assign pcen = pcwrite | (branch & zero); // program counter enable
endmodule

module statelogic(input  logic       clk, reset,
                  input  logic [5:0] op,
                  output statetype   state);

  statetype nextstate;
  
  always_ff @(posedge clk)
    if (reset) state <= FETCH1;
    else       state <= nextstate;
    
  always_comb
    begin
      case (state)
        FETCH1:  nextstate = FETCH2;
        FETCH2:  nextstate = FETCH3;
        FETCH3:  nextstate = FETCH4;
        FETCH4:  nextstate = DECODE;
        DECODE:  case(op)
                   LB:      nextstate = MEMADR;
                   SB:      nextstate = MEMADR;
                   RTYPE:   nextstate = RTYPEEX;
                   BEQ:     nextstate = BEQEX;
                   J:       nextstate = JEX;
                   default: nextstate = FETCH1; // should never happen
                 endcase
        MEMADR:  case(op)
                   LB:      nextstate = LBRD;
                   SB:      nextstate = SBWR;
                   default: nextstate = FETCH1; // should never happen
                 endcase
        LBRD:    nextstate = LBWR;
        LBWR:    nextstate = FETCH1;
        SBWR:    nextstate = FETCH1;
        RTYPEEX: nextstate = RTYPEWR;
        RTYPEWR: nextstate = FETCH1;
        BEQEX:   nextstate = FETCH1;
        JEX:     nextstate = FETCH1;
        default: nextstate = FETCH1; // should never happen
      endcase
    end
endmodule

module outputlogic(input statetype state,
                   output logic       memread, memwrite, alusrca,  
                   output logic       memtoreg, iord, 
                   output logic       regwrite, regdst, 
                   output logic [1:0] pcsrc, alusrcb,
                   output logic [3:0] irwrite,
                   output logic       pcwrite, branch,
                   output logic [1:0] aluop);

  always_comb
    begin
      // set all outputs to zero, then 
      // conditionally assert just the appropriate ones
      irwrite = 4'b0000;
      pcwrite = 0; branch = 0;
      regwrite = 0; regdst = 0;
      memread = 0; memwrite = 0;
      alusrca = 0; alusrcb = 2'b00; aluop = 2'b00;
      pcsrc = 2'b00;
      iord = 0; memtoreg = 0;
      case (state)
        FETCH1: 
          begin
            memread = 1; 
            irwrite = 4'b0001; 
            alusrcb = 2'b01; 
            pcwrite = 1;
          end
        FETCH2: 
          begin
            memread = 1;
            irwrite = 4'b0010;
            alusrcb = 2'b01;
            pcwrite = 1;
          end
        FETCH3:
          begin
            memread = 1;
            irwrite = 4'b0100;
            alusrcb = 2'b01;
            pcwrite = 1;
          end
        FETCH4:
          begin
            memread = 1;
            irwrite = 4'b1000;
            alusrcb = 2'b01;
            pcwrite = 1;
          end
        DECODE: alusrcb = 2'b11;
        MEMADR:
          begin
            alusrca = 1;
            alusrcb = 2'b10;
          end
        LBRD:
          begin
            memread = 1;
            iord    = 1;
          end
        LBWR:
          begin
            regwrite = 1;
            memtoreg = 1;
          end
        SBWR:
          begin
            memwrite = 1;
            iord     = 1;
          end
        RTYPEEX: 
          begin
            alusrca = 1;
            aluop   = 2'b10;
          end
        RTYPEWR:
          begin
            regdst   = 1;
            regwrite = 1;
          end
        BEQEX:
          begin
            alusrca = 1;
            aluop   = 2'b01;
            branch  = 1;
            pcsrc   = 2'b01;
          end
        JEX:
          begin
            pcwrite  = 1;
            pcsrc    = 2'b10;
          end
      endcase
    end
endmodule

module aludec(input  logic [1:0] aluop, 
              input  logic [5:0] funct, 
              output logic [2:0] alucontrol);

  always_comb
    case (aluop)
      2'b00: alucontrol = 3'b010;  // add for lb/sb/addi
      2'b01: alucontrol = 3'b110;  // subtract (for beq)
      default: case(funct)      // R-Type instructions
                 ADD: alucontrol = 3'b010;
                 SUB: alucontrol = 3'b110;
                 AND: alucontrol = 3'b000;
                 OR:  alucontrol = 3'b001;
                 SLT: alucontrol = 3'b111;
                 default:   alucontrol = 3'b101; // should never happen
               endcase
    endcase
endmodule

module datapath #(parameter WIDTH = 8, REGBITS = 3)
                 (input  logic             clk, reset, 
                  input  logic [WIDTH-1:0] memdata, 
                  input  logic             alusrca, memtoreg, iord, 
                  input  logic             pcen, regwrite, regdst,
                  input  logic [1:0]       pcsrc, alusrcb, 
                  input  logic [3:0]       irwrite, 
                  input  logic [2:0]       alucontrol, 
                  output logic             zero, 
                  output logic [31:0]      instr, 
                  output logic [WIDTH-1:0] adr, writedata);

  logic [REGBITS-1:0] ra1, ra2, wa;
  logic [WIDTH-1:0]   pc, nextpc, data, rd1, rd2, wd, a, srca, 
                      srcb, aluresult, aluout, immx4;

  logic [WIDTH-1:0] CONST_ZERO = 0;
  logic [WIDTH-1:0] CONST_ONE =  1;

  // shift left immediate field by 2
  assign immx4 = {instr[WIDTH-3:0],2'b00};

  // register file address fields
  assign ra1 = instr[REGBITS+20:21];
  assign ra2 = instr[REGBITS+15:16];
  mux2       #(REGBITS) regmux(instr[REGBITS+15:16], 
                               instr[REGBITS+10:11], regdst, wa);

   // independent of bit width, load instruction into four 8-bit registers over four cycles
  flopen     #(8)      ir0(clk, irwrite[0], memdata[7:0], instr[7:0]);
  flopen     #(8)      ir1(clk, irwrite[1], memdata[7:0], instr[15:8]);
  flopen     #(8)      ir2(clk, irwrite[2], memdata[7:0], instr[23:16]);
  flopen     #(8)      ir3(clk, irwrite[3], memdata[7:0], instr[31:24]);

  // datapath
  flopenr    #(WIDTH)  pcreg(clk, reset, pcen, nextpc, pc);
  flop       #(WIDTH)  datareg(clk, memdata, data);
  flop       #(WIDTH)  areg(clk, rd1, a);
  flop       #(WIDTH)  wrdreg(clk, rd2, writedata);
  flop       #(WIDTH)  resreg(clk, aluresult, aluout);
  mux2       #(WIDTH)  adrmux(pc, aluout, iord, adr);
  mux2       #(WIDTH)  src1mux(pc, a, alusrca, srca);
  mux4       #(WIDTH)  src2mux(writedata, CONST_ONE, instr[WIDTH-1:0], 
                               immx4, alusrcb, srcb);
  mux3       #(WIDTH)  pcmux(aluresult, aluout, immx4, 
                             pcsrc, nextpc);
  mux2       #(WIDTH)  wdmux(aluout, data, memtoreg, wd);
  regfile    #(WIDTH,REGBITS) rf(clk, regwrite, ra1, ra2, 
                                 wa, wd, rd1, rd2);
  alu        #(WIDTH) alunit(srca, srcb, alucontrol, aluresult, zero);
endmodule

module alu #(parameter WIDTH = 8)
            (input  logic [WIDTH-1:0] a, b, 
             input  logic [2:0]       alucontrol, 
             output logic [WIDTH-1:0] result,
             output logic             zero);

  logic [WIDTH-1:0] b2, andresult, orresult, sumresult, sltresult;

  andN    andblock(a, b, andresult);
  orN     orblock(a, b, orresult);
  condinv binv(b, alucontrol[2], b2);
  adder   addblock(a, b2, alucontrol[2], sumresult);
  // slt should be 1 if most significant bit of sum is 1
  assign sltresult = sumresult[WIDTH-1];

  mux4 resultmux(andresult, orresult, sumresult, sltresult, alucontrol[1:0], result);
  zerodetect #(WIDTH) zd(result, zero);
endmodule


module regfile #(parameter WIDTH = 8, REGBITS = 3)
                (input  logic               clk, 
                 input  logic               regwrite, 
                 input  logic [REGBITS-1:0] ra1, ra2, wa, 
                 input  logic [WIDTH-1:0]   wd, 
                 output logic [WIDTH-1:0]   rd1, rd2);

   logic [WIDTH-1:0] RAM [2**REGBITS-1:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0
  always @(posedge clk)
    if (regwrite) RAM[wa] <= wd;

  assign rd1 = ra1 ? RAM[ra1] : 0;
  assign rd2 = ra2 ? RAM[ra2] : 0;
endmodule


module zerodetect #(parameter WIDTH = 8)
                   (input  logic [WIDTH-1:0] a, 
                    output logic             y);

   assign y = (a==0);
endmodule	

module flop #(parameter WIDTH = 8)
             (input  logic             clk, 
              input  logic [WIDTH-1:0] d, 
              output logic [WIDTH-1:0] q);

  always_ff @(posedge clk)
    q <= d;
endmodule

module flopen #(parameter WIDTH = 8)
               (input  logic             clk, en,
                input  logic [WIDTH-1:0] d, 
                output logic [WIDTH-1:0] q);

  always_ff @(posedge clk)
    if (en) q <= d;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

  always_comb 
    casez (s)
      2'b00: y = d0;
      2'b01: y = d1;
      2'b1?: y = d2;
    endcase
endmodule

module mux4 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

  always_comb
    case (s)
      2'b00: y = d0;
      2'b01: y = d1;
      2'b10: y = d2;
      2'b11: y = d3;
    endcase
endmodule

module andN #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] a, b,
              output logic [WIDTH-1:0] y);

  assign y = a & b;
endmodule

module orN #(parameter WIDTH = 8)
            (input  logic [WIDTH-1:0] a, b,
             output logic [WIDTH-1:0] y);

  assign y = a | b;
endmodule

module inv #(parameter WIDTH = 8)
            (input  logic [WIDTH-1:0] a,
             output logic [WIDTH-1:0] y);

  assign y = ~a;
endmodule

module condinv #(parameter WIDTH = 8)
                (input  logic [WIDTH-1:0] a,
                 input  logic             invert,
                 output logic [WIDTH-1:0] y);

  logic [WIDTH-1:0] ab;

  inv  inverter(a, ab);
  mux2 invmux(a, ab, invert, y);
endmodule

module adder #(parameter WIDTH = 8)
              (input  logic [WIDTH-1:0] a, b,
               input  logic             cin,
               output logic [WIDTH-1:0] y);

  assign y = a + b + cin;
endmodule

/*******************************************************/
/************** Project 1 ******************************/
/*******************************************************/
module parity_controller (
    
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


module parity_datapath (
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


module parity (
	
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
	
	parity_controller controller (
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
	
	parity_datapath datapath (

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