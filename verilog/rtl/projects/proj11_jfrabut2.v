module simpleDES (input  clk, reset,
                  input  [15:0] in_signal,
                  output [7:0] out_signal);

  wire read_en, key_en, encrypt_11_en, do_read;

  controller_11 control (clk, reset, do_read, read_en, key_en, encrypt_11_en);
  datapath_11 dp (clk, reset, read_en, key_en, encrypt_11_en, in_signal, out_signal, do_read);



endmodule



module controller_11 (input     clk, reset,
                    input do_read,
                   output reg read_en, key_en, encrypt_11_en);
  localparam IDLE=3'b000, READ=3'b001, KEYGEN=3'b010, ENCRYPT=3'b011, DONE=3'b100;
  reg [2:0] state, nstate;


  always @ (posedge clk)
    if (reset)
      state <= IDLE;
    else
      begin
		case (state)
		  IDLE: nstate = do_read? READ: IDLE;
		  READ: nstate = KEYGEN;
		  KEYGEN: nstate = ENCRYPT;
		  ENCRYPT: nstate = DONE;
		  DONE: nstate = IDLE;
		endcase
        case (nstate)
          IDLE: {read_en, key_en, encrypt_11_en} = 3'b000;
          READ: {read_en, key_en, encrypt_11_en} = 3'b100;
          KEYGEN: {read_en, key_en, encrypt_11_en} = 3'b010;
          ENCRYPT: {read_en, key_en, encrypt_11_en} = 3'b001;
          DONE: {read_en, key_en, encrypt_11_en} = 3'b000;
        endcase
		
      end

  

endmodule


module datapath_11(input    clk, reset,
                input read_en, key_en, encrypt_11_en,
                input [15:0] input_data,
                output [7:0] ciphertext,
                output do_read);

    wire [7:0] plaintextToEncrypt;
    wire [7:0] keyToKeygen;
    wire [9:0] fullKey;
    wire [15:0] keysOutput;
    wire [7:0] key1ToEncrypt;
    wire [7:0] key2ToEncrypt;
    wire [7:0] encrypt_11Output;

    assign fullKey[9] = 1;
    assign fullKey[8] = 1;
    assign fullKey[7:0] = keyToKeygen;
    
    assign do_read = ((plaintextToEncrypt == input_data[7:0] && keyToKeygen == input_data[15:8]) || reset);

    flopenr_11 plaintext (clk, reset, read_en, input_data[7:0], plaintextToEncrypt);
    flopenr_11 key_input (clk, reset, read_en, input_data[15:8], keyToKeygen);

    keygen_11 key (fullKey, keysOutput);

    flopenr_11 key1 (clk, reset, key_en, keysOutput[15:8], key1ToEncrypt);
    flopenr_11 key2 (clk, reset, key_en, keysOutput[7:0], key2ToEncrypt);

    encrypt_11 enc (plaintextToEncrypt, key1ToEncrypt, key2ToEncrypt, encrypt_11Output);

    flopenr_11 encrypt_11ed (clk, reset, encrypt_11_en, encrypt_11Output, ciphertext);

endmodule


module flopenr_11 (input               clk, reset, en,
                 input   [7:0] d, 
                 output  reg [7:0] q);
 
  always @(posedge clk)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule



// key gen module
module keygen_11 (input  [9:0] in,
                      output  [15:0] out);

  wire [9:0] p10_out;
  wire [9:0] shift_out1;
  wire [9:0] shift_out2;


  permutation10 perm10 (in, p10_out);
  shift shift1 (p10_out, shift_out1);
  permutation8 perm1 (shift_out1, out[7:0]);
  shift shift2 (shift_out1, shift_out2);
  permutation8 perm2 (shift_out2, out[15:8]);

endmodule

// encyrption module

module encrypt_11 (input  [7:0] in,
                input  [7:0] key1,
                input  [7:0] key2,
                output  [7:0] out);

  wire [3:0] IP_out_upper;
  wire [3:0] IP_out_lower;
  wire [7:0] expansion1_out;
  wire [3:0] xor1_out_upper;
  wire [3:0] perm4_out1;
  wire [3:0] xor2_out;
  wire [7:0] expansion2_out;
  wire [3:0] xor3_out_upper;
  wire [3:0] perm4_out2;
  wire [3:0] xor4_out;

  permutationI permI (in, IP_out_upper, IP_out_lower);

  expansion expan_1 (IP_out_lower, expansion1_out);
  xor8to4 x8_1 (expansion1_out, key1, xor1_out_upper);
  permutation4 perm4_1 (xor1_out_upper, perm4_out1);
  xor4 x4_1 (perm4_out1, IP_out_upper, xor2_out);

  expansion expan_2 (xor2_out, expansion2_out);
  xor8to4 x8_2 (expansion2_out, key2, xor3_out_upper);
  permutation4 perm4_2 (xor3_out_upper, perm4_out2);
  xor4 x4_2 (perm4_out2, IP_out_lower, xor4_out);

  permutationIP permIP (xor4_out, xor2_out, out);


endmodule


// shift module
module shift (input  [9:0] in,
                      output  [9:0] out);

  assign out[0] = in[1];
  assign out[1] = in[2];
  assign out[2] = in[3];
  assign out[3] = in[4];
  assign out[4] = in[5];
  assign out[5] = in[6];
  assign out[6] = in[7];
  assign out[7] = in[8];
  assign out[8] = in[9];
  assign out[9] = in[0];



endmodule

// expansion module
module expansion (input  [3:0] in,
                      output  [7:0] out);

  assign out[0] = 1;
  assign out[1] = 0;
  assign out[2] = 1;
  assign out[3] = 0;
  assign out[4] = in[2];
  assign out[5] = in[1];
  assign out[6] = in[3];
  assign out[7] = in[0];


endmodule

// permutation module
module permutation10 (input  [9:0] in,
                      output  [9:0] out);

  assign out[0] = in[2];
  assign out[1] = in[4];
  assign out[2] = in[1];
  assign out[3] = in[6];
  assign out[4] = in[3];
  assign out[5] = in[9];
  assign out[6] = in[0];
  assign out[7] = in[8];
  assign out[8] = in[7];
  assign out[9] = in[5];

endmodule

module permutation8 (input  [9:0] in,
                      output  [7:0] out);

  assign out[0] = in[5];
  assign out[1] = in[2];
  assign out[2] = in[6];
  assign out[3] = in[3];
  assign out[4] = in[7];
  assign out[5] = in[4];
  assign out[6] = in[9];
  assign out[7] = in[8];


endmodule

module permutationI (input  [7:0] in,
                      output  [3:0] out_upper,
                      output  [3:0] out_lower);

  assign out_lower[0] = in[5];
  assign out_lower[1] = in[5];
  assign out_lower[2] = in[2];
  assign out_lower[3] = in[0];
  assign out_upper[0] = in[3];
  assign out_upper[1] = in[7];
  assign out_upper[2] = in[4];
  assign out_upper[3] = in[6];


endmodule

module permutationIP (input  [3:0] in1,
                      input  [3:0] in2,
                      output  [7:0] out);

  assign out[0] = in2[0];
  assign out[1] = in1[0];
  assign out[2] = in1[2];
  assign out[3] = in2[0];
  assign out[4] = in2[2];
  assign out[5] = in1[1];
  assign out[6] = in2[3];
  assign out[7] = in2[1];


endmodule

module permutation4 (input  [3:0] in,
                      output  [3:0] out);

  assign out[0] = in[2];
  assign out[1] = in[1];
  assign out[2] = in[3];
  assign out[3] = in[0];


endmodule

module xor8to4 (input  [7:0] in1,
              input  [7:0] in2,
                      output  [3:0] out);

  assign out[0] = in1[0] ^ in2[0];
  assign out[1] = in1[1] ^ in2[1];
  assign out[2] = in1[2] ^ in2[2];
  assign out[3] = in1[3] ^ in2[3];


endmodule

module xor4 (input  [3:0] in1,
              input  [3:0] in2,
                      output  [3:0] out);

  assign out = in1 ^ in2;


endmodule
