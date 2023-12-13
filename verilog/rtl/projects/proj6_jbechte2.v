// states and instructions

// next = chip_input[5];
// input_char = chip_input[4:0];
// guessed_letters = chip_output[4:0];
// win = chip_output[14];
// lose = chip_output[15];
module hangy_6(input  logic             clk, reset, 
              input  [11:0] chip_input,
              output [6:0] chip_output);
  
  logic [4:0] input_char_eq_word;
  logic guessed_letters_is_done;
  logic tries_eq_7;
  logic s_tries, en_tries;
  logic [2:0] s_guessed_letters;
  logic en_guessed_letters;
  logic en_word_index;
  logic en_input_char;
  logic s_win, en_win;
  logic s_lose, en_lose;

  // chip input breakdown:
  logic next;
  assign next = chip_input[5];

  wire lose;
  wire win;
  wire [4:0] guessed_letters;

  // always @(next)
  //   $display("next: %b", next);

  // chip output breakdown:
  assign chip_output[6:0] = {lose, win, guessed_letters};

  controller_6 controlly (
    .clk(clk),
    .reset(reset),
    .next(next),
    .input_char_eq_word(input_char_eq_word),
    .guessed_letters_is_done(guessed_letters_is_done),
    .tries_eq_7(tries_eq_7),
    .s_tries(s_tries),
    .en_tries(en_tries),
    .s_guessed_letters(s_guessed_letters),
    .en_guessed_letters(en_guessed_letters),
    .en_word_index(en_word_index),
    .en_input_char(en_input_char),
    .s_win(s_win),
    .en_win(en_win),
    .s_lose(s_lose),
    .en_lose(en_lose)
  );

  datapath_6 daty (
    .clk(clk),
    .rst(reset),
    .chip_input(chip_input),
    .s_tries(s_tries),
    .en_tries(en_tries),
    .s_guessed_letters(s_guessed_letters),
    .en_guessed_letters(en_guessed_letters),
    .en_word_index(en_word_index),
    .en_input_char(en_input_char),
    .s_win(s_win),
    .en_win(en_win),
    .s_lose(s_lose),
    .en_lose(en_lose),
    .guessed_letters(guessed_letters),
    .input_char_eq_word(input_char_eq_word),
    .guessed_letters_is_done(guessed_letters_is_done),
    .tries_eq_7(tries_eq_7),
    .win(win),
    .lose(lose)
  );

endmodule

module controller_6(input  logic clk, reset, 
                  input  logic next, 
                  input  logic [4:0] input_char_eq_word,
                  input  logic guessed_letters_is_done,
                  input  logic tries_eq_7, 
                  output logic s_tries, en_tries,
                  output logic [2:0] s_guessed_letters, 
                  output logic en_guessed_letters,
                  output logic en_word_index,
                  output logic en_input_char,
                  output logic s_win, en_win,
                  output logic s_lose, en_lose
                  );

  // always @(*)
	localparam INIT_GAME 		= 4'b0000;  
	localparam GEN_WORD  		= 4'b0001; 
	localparam GUESS				= 4'b0010;
	localparam CHECK_GUESS_0		= 4'b0011;
	localparam CORRECT_0 		= 4'b0100;
	localparam CHECK_GUESS_1		= 4'b0101; 
	localparam CORRECT_1 		= 4'b0110;
	localparam CHECK_GUESS_2 	= 4'b0111;
	localparam CORRECT_2 		= 4'b1000;
	localparam CHECK_GUESS_3 	= 4'b1001;
	localparam CORRECT_3 		= 4'b1010;
	localparam CHECK_GUESS_4 	= 4'b1011;
	localparam CORRECT_4 		= 4'b1100;
	localparam ALL_INCORRECT 	= 4'b1101;
	localparam WIN 				= 4'b1110;
	localparam LOSE				= 4'b1111;

  reg[4:0] state, next_state;
  
  always_ff @(posedge clk)
    if (reset) state <= INIT_GAME;
    else       state <= next_state;
    
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

                          s_win = 1'b0;
                          en_win = 1'b1;

                          s_lose = 1'b0;
                          en_lose = 1'b1;

                          if (next) next_state = GEN_WORD;
                          else next_state = INIT_GAME;
                        end
        GEN_WORD:       begin
                          en_word_index = 1'b1;
                          next_state = GUESS;
                        end
        GUESS:          begin
                          en_input_char = 1'b1;
                          if (next) next_state = CHECK_GUESS_0;
                          else next_state = GUESS;
                        end
        CHECK_GUESS_0:  begin 
                          if (input_char_eq_word[4]) next_state = CORRECT_0;
                          else next_state = CHECK_GUESS_1;
                        end
        CHECK_GUESS_1:  begin 
                          if (input_char_eq_word[3]) next_state = CORRECT_1;
                          else next_state = CHECK_GUESS_2;
                        end
        CHECK_GUESS_2:  begin 
                          if (input_char_eq_word[2]) next_state = CORRECT_2;
                          else next_state = CHECK_GUESS_3;
                        end
        CHECK_GUESS_3:  begin 
                          if (input_char_eq_word[1]) next_state = CORRECT_3;
                          else next_state = CHECK_GUESS_4;
                        end
        CHECK_GUESS_4:  begin 
                          if (input_char_eq_word[0]) next_state = CORRECT_4;
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
        default: next_state = INIT_GAME; // should never happen
      endcase
    end
  
endmodule


module datapath_6 #(parameter WIDTH = 8, REGBITS = 3)
                 (input  logic clk, rst,
                 input   logic [11:0] chip_input,

                  input logic s_tries, en_tries,
                  input logic [2:0] s_guessed_letters,
                  input logic en_guessed_letters,
                  input logic en_word_index,
                  input logic en_input_char,
                  input logic s_win, en_win,
                  input logic s_lose, en_lose,

                 output reg [4:0] guessed_letters,    // this is letter-by-letter

                 output reg [4:0] input_char_eq_word, // this is letter-by-letter
                 output reg guessed_letters_is_done,
                 output reg tries_eq_7, 

                 output reg win, 
                 output reg lose
                 );

  reg [2:0] tries;

  always_ff @(posedge clk) 
    begin
      if (en_tries) begin
        if (s_tries) tries = tries + 1'b1;
        else tries = 1'b0;
      end
    end
  
  always_ff @(posedge clk)
    begin
      if (en_guessed_letters) begin
        case (s_guessed_letters)
          3'b000:  guessed_letters = 5'b00000;
          3'b001:  guessed_letters = guessed_letters | 5'b10000;
          3'b010:  guessed_letters = guessed_letters | 5'b01000;
          3'b011:  guessed_letters = guessed_letters | 5'b00100;
          3'b100:  guessed_letters = guessed_letters | 5'b00010;
          3'b101:  guessed_letters = guessed_letters | 5'b00001;
          default: guessed_letters = guessed_letters | 5'b00000;
        endcase
      end
    end 

  reg [5:0] word_index;

  always_ff @(posedge clk)
    if (en_word_index) word_index = chip_input[11:6];

  wire [24:0] word;
  wordrom_6 wordrom_6y(
     .addr(word_index),
     .data(word)
   );


  //assign word=25'b0110101110100111000100101;
  
  reg [4:0] input_char;
  always_ff @(posedge clk)
    if (en_input_char) begin 
      input_char = chip_input[4:0];
      // $display("input_char: %b", input_char);
    end
  
  always_comb 
    input_char_eq_word = {
      input_char == word[24:20],
      input_char == word[19:15],
      input_char == word[14:10],
      input_char == word[9:5],
      input_char == word[4:0]
    };
  

  always_comb 
    guessed_letters_is_done = (guessed_letters == 5'b11111);
  
  always_comb 
    tries_eq_7 = (tries == 3'b111);
  
  always_ff @(posedge clk)
    if (en_win) win = s_win;

  always_ff @(posedge clk)
    if (en_lose) lose = s_lose;  
endmodule


module wordrom_6 (
  input [5:0] addr,
  output [24:0] data
);

  reg [24:0] words [0:63];
  initial $readmemb("proj6_words_data.txt", words);

  assign data = words[addr];

endmodule

/* End EFabless Harness project with `default_nettype wire */
`default_nettype wire
