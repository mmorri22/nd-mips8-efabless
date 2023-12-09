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

    // IOs
    input  [DWIDTH-1:0] io_in,
    output [BITS-1:0] io_out,
	output [BITS-1:0] io_oeb,
);

	/* For mapping the wb_clk_i and wb_rst_i to our clk and rst */
    wire clk = wb_clk_i;
    wire rst = !wb_rst_i;
	
	/* Set io_oeb to 0 to ensure all outputs are active */
	assign io_oeb = 1'b0;

	/* Output signals */
	wire [DWIDTH-1:0] adr_out;
	wire [DWIDTH-1:0] writedata_out;
	
	mips the_mips(
		.clk(clk),
		.reset(rst),
		.memdata(io_in[DWIDTH-1:0]),
		.adr(adr_out),
		.writedata(writedata_out)
	);

	/* Map the wires to the io_out */
	assign io_out[BITS-1:DWIDTH] = adr_out;
	assign io_out[DWIDTH-1:0] = writedata_out;

endmodule


// states and instructions

typedef enum logic [3:0] {INIT_GAME = 4'b0000, GEN_WORD, GUESS, 
                          CHECK_GUESS_0, CORRECT_0, 
                          CHECK_GUESS_1, CORRECT_1, 
                          CHECK_GUESS_2, CORRECT_2, 
                          CHECK_GUESS_3, CORRECT_3, 
                          CHECK_GUESS_4, CORRECT_4, 
                          ALL_INCORRECT, WIN, LOSE
                         } statetype;


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

  statetype       state, nextstate;
  
  always_ff @(posedge clk)
    if (reset) state <= FETCH1;
    else       state <= nextstate;
    
  always_comb
    begin
      // start by setting all outputs to 0
      s_tries = 1'b0; 
      en_tries = 1'b0;

      s_guessed_letters = 3'b0;
      en_guessed_letters = 1'b0;

      en_word_index = 1'b0;

      en_input_char = 1'b0;

      s_win = 1'b0;
      en_win = 1'b0;

      s_lose = 1'b0;
      en_lose = 1'b0;

      case (state)
        INIT_GAME:      begin
                          s_tries = 1'b0;
                          en_tries = 1'b1;

                          s_guessed_letters = 3'b0;
                          en_guessed_letters = 1'b1;

                          if (next) nextstate = GEN_WORD;
                          else nextstate = INIT_GAME;
                        end
        GEN_WORD:       begin
                          en_word_index = 1'b1;
                          nextstate = GUESS;
                        end
        GUESS:          begin
                          en_input_char = 1'b1;
                          if (next) nextstate = CHECK_GUESS_0;
                          else nextstate = GUESS;
                        end
        CHECK_GUESS_0:  begin 
                          if (input_char_eq_word_0) next_state = CORRECT_0;
                          else next_state = CHECK_GUESS_1;
                        end
        CHECK_GUESS_1:  begin 
                          if (input_char_eq_word_1) next_state = CORRECT_1;
                          else next_state = CHECK_GUESS_2;
                        end
        CHECK_GUESS_2:  begin 
                          if (input_char_eq_word_2) next_state = CORRECT_2;
                          else next_state = CHECK_GUESS_3;
                        end
        CHECK_GUESS_3:  begin 
			  if (input_char_eq_word_3) next_state = CORRECT_3;
                          else next_state = CHECK_GUESS_4;
                        end
        CHECK_GUESS_4:  begin 
                          if (input_char_eq_word_4) next_state = CORRECT_4;
                          else next_state = ALL_INCORRECT;
                        end
        CORRECT_0:      begin
                          s_guessed_letters = 3'b001;
                          en_guessed_letters = 1'b1;
                          if (guessed_letters_is_done) next_state = WIN;
                          else next_state = GUESS;
                        end
        CORRECT_1:      begin
                          s_guessed_letters = 3'b010;
                          en_guessed_letters = 1'b1;
                          if (guessed_letters_is_done) next_state = WIN;
                          else next_state = GUESS;
                        end
        CORRECT_2:      begin
                          s_guessed_letters = 3'b011;
                          en_guessed_letters = 1'b1;
                          if (guessed_letters_is_done) next_state = WIN;
                          else next_state = GUESS;
                        end
        CORRECT_3:      begin
                          s_guessed_letters = 3'b100;
                          en_guessed_letters = 1'b1;
                          if (guessed_letters_is_done) next_state = WIN;
                          else next_state = GUESS;
                        end
        CORRECT_4:      begin
                          s_guessed_letters = 3'b101;
                          en_guessed_letters = 1'b1;
                          if (guessed_letters_is_done) next_state = WIN;
                          else next_state = GUESS;
                        end
        ALL_INCORRECT:  begin
                          s_tries = 1'b1;
                          en_tries = 1'b1;
                          if (tries_eq_7) next_state = LOSE;
                          else next_state = GUESS;
                        end
        WIN:            begin
                          s_win = 1'b1;
                          en_win = 1'b1;
                          if (next) next_state = INIT_GAME;
                          else next_state = WIN;
                        end
        LOSE:           begin
                          s_lose = 1'b1;
                          en_lose = 1'b1;
                          if (next) next_state = INIT_GAME;
                          else next_state = LOSE;
                        end
        default: nextstate = INIT_GAME; // should never happen
      endcase
    end
  


  
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

module lfsr6 (
 input clk,
 output reg [5:0] q);

 initial q = 6'd1;

 always @(posedge clk)
  q <= {q[4:0], q[5]^q[0]};

endmodule

/* End EFabless Harness project with `default_nettype wire */
`default_nettype wire
