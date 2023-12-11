# GF180 MIPS Demo Project Example

Professor: Matthew Morrison, Associate Teaching Professor, University of Notre Dame
Email:  matt.morrison@nd.edu
Push Date: 12/11/2023

This project contains the 16 group projects for the CSE 30342 Digital Integrated Circuits course. In this README.md file, the contents of their projects are detailed. The student's work is cited, and the ways to access their specific scope of the project through the wbs_sel_i select signal are detailed. Each student has been added as a collaborator to this project.

/*****************************************
 * Signals to Projects Correlation 
 *****************************************/

Here is the correlation between the wbs_sel_i signals and the student projects:
					
|[3]|[2]|[1]|[0]|Location|Authors|
|---|---|---|---|---|---|
|0|0|0|0|verilog/rtl/proj0.v|Professor Matthew Morrison|
|0|0|0|1|verilog/rtl/proj1.v|Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young|
|0|0|1|0|verilog/rtl/proj2.v|Antonio Karam, Sean Froning, Varun Taneja, Brendan McGinn|
|0|0|1|1|verilog/rtl/proj3.v|David Simonetti, Thomas Mercurio, and Brooke Mackey|
|0|1|0|0|verilog/rtl/proj4.v|Evan Day, Sofia Nelson, James Lindell, Eamon Tracey|
|0|1|0|1|verilog/rtl/proj5.v|Noor Achkar, David Chirumbole, Marc Edde|
|0|1|1|0|verilog/rtl/proj6.v|Josue Guerra, Steven Conaway, Nicholas Palma, Jacob Bechtel|
|0|1|1|1|verilog/rtl/proj7.v| |
|1|0|0|0|verilog/rtl/proj8.v| |
|1|0|0|1|verilog/rtl/proj9.v| |
|1|0|1|0|verilog/rtl/proj10.v| |
|1|0|1|1|verilog/rtl/proj11.v| |
|1|1|0|0|verilog/rtl/proj12.v| |
|1|1|0|1|verilog/rtl/proj13.v| |
|1|1|1|0|verilog/rtl/proj14.v| |
|1|1|1|1|verilog/rtl/proj15.v| |
 
/*****************************************<br>
 * Project 0 - MIPS Demo <br>
 * Author(s): Professor Morrison<br> 
 *<br>
 * Email - <matt.morrison@nd.edu> <br>
 *****************************************/<br>

Developed to demonstrate open source flow using the GF 180 flow using EFabless to students in my CSE 30342 Digital Integrated Circuits course.

The user_proj_example.v file contains a description of an 8-bit MIPS microprocessor with a datapath with a controller, and memory elements.

The tutorials for setting up this flow (with some limitations for introductory CSE 30342 students)

1) Setting up the EFabless Environment - https://github.com/mmorri22/cse30342/blob/main/Resources/Final%20Project%20-%20Setup.ipynb

2) Running through the Project, including how to map the Verilog to user_proj_example.v, and how to map the user_proj_example module to the user_project_wrapper. Finally, the student learns how to push the project to the EFabless GitHub repository, and how to perform MPW and Tapeout Checks - https://github.com/mmorri22/cse30342/blob/main/Resources/Final%20Project%20-%20Implementation.ipynb


/*****************************************<br>
 * Project 1 - Parity Checker <br>
 * Author(s): Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young<br>
 *<br>
 Aidan Oblepias <aoblepia@nd.edu><br>
 Allison Gentry <agentry2@nd.edu><br>
 Garrett Young <gyoung7@nd.edu>,<br>
 Leo Herman <lherman@nd.edu>,<br>
 *****************************************/<br>
 
## Overview

This repository contains the Verilog implementation of an 8-bit parity checker designed to be synthesized on the EFabless Caravel OpenLane flow. The circuit is intended for use with the Global Foundries gf180mcuD Process Development Kit as part of the coursework for CSE 30342 - Digital Integrated Circuits at the University of Notre Dame.

## Circuit Description

The parity checker circuit takes an 8-bit binary input (`data_in`) and checks for even and odd bit parity. The calculation is triggered by a rising edge on the `start` pin. The circuit operates using the clock signal (`clk`). The results are indicated through the following output pins:

- `busy`: Goes high when calculations are being performed and drops low when results are ready.
- `even_parity`: Set if `data_in` contains even bit parity.
- `odd_parity`: Set if `data_in` contains odd bit parity.

## Inputs and Outputs

### Inputs

- `clk`: Clock signal
- `start`: Start pin (calculation begins when set high)
- `data_in`: 8 bits of binary input

### Outputs

- `busy`: High when calculations are being performed. Drops low when results are ready.
- `even_parity`: Set if `data_in` contains even bit parity.
- `odd_parity`: Set if `data_in` contains odd bit parity.

 
 /*****************************************<br>
 * Project 2 - Cool Ranch <br>
 * Author(s): <br>
 *<br>
	Varun Taneja <vtaneja@nd.edu><br>
	Brendan McGinn <bmcginn2@nd.edu><br>
	Sean Froning <sfroning@nd.edu><br>
	Antonio Karam <akaram@nd.edu><br>
 *****************************************/<br>

Our final project, <i>Cool Ranch</i>, is a chip implementation of a Linear Feedback Shift Register (LFSR), a form of pseudorandom number generator. The pseudorandom number is a product of the LFSR “taps” and the starting value “sequence number” stored in the registers. Both taps and sequence numbers are input given by the user.

Our verilog implementation was a six state High Level State Machine (HLSM), detailed in the table below.
<code>inputs:			switches [7:0], seq_num [7:0], start</code><br>
<code>outputs:		num[7:0], busy</code><br>
<code>internal variables:	tap0[3:0], tap1[3:0], i[3:0], j[7:0], switch_shift[7:0]</code><br>

The LFSR works as follows:<br>
An N-bit linear feedback shift register (LFSR) produces an N-bit pseudo random number. The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers. We will be generating an 8-bit pseudo random number. Taps for the LFSR will be set via the SW input.  SW[0] indicates one of the taps is on bit 0, SW[1] indicates a tap on bit 1 … SW[7] indicates a tap on bit 7. The output for our chip is a 9-bit number. Out[0] will be our busy signal, which indicates that our HLSM is currently running and there is no output. The other 8 bits will be the randomly generated number.

|STATE|ACTION|TRANSITION|
|---|---|---|
|WAIT|busy ← 0|if (start) goto INIT<br>else goto WAIT|
|INIT|i ← -1<br>j ← 0<br>busy ← 1<br>tap0 ← 1<br>tap1 ←0<br>switch_shift ← switches<br>num ← 1|goto FIND_TAP0|
|FIND_TAP0|i ← i + 1<br>switch_shift ← switch_shift >> 1<br>|
if (i == 8) goto CALCULATE<br>
else if (switches[0] == 1) goto UPDATE_TAP0<br>
else goto FIND_TAP0<br>|
|UPDATE_TAP0|tap0 ← i|goto FIND_TAP1|
|FIND_TAP1|i ← i + 1<br>switch_shift ← switch_shift >> 1<br>|
if (i == 8) goto CALCULATE<br>
else if (switches[0] == 1) goto UPDATE_TAP1<br>
else goto FIND_TAP1|
|UPDATE_TAP1|tap1 ← i|goto CALCULATE|
|CALCULATE|
j ← j + 1<br>
num ← {num[6:0], num[tap0] ^ num[tap1]}|
if (j == seq_num) goto FINISH<br>
else goto CALCULATE|
|FINISH|busy ← 0|goto WAIT|

 /*****************************************<br>
 * Project 3 - GF180 RSA Encryption Project <br>
 * Author(s): <br>
 *<br>
	David Simonetti <vtaneja@nd.edu><br>
	Thomas Mercurio <bmcginn2@nd.edu><br>
	Brooke Mackey <sfroning@nd.edu><br>
 *****************************************/<br>
 
 Goal: Our project performs an RSA encryption of an 8-byte input, with changable public key values.
 
## Encryption Process
 
This process occurs outside of the circuit. The values that result from this process can be fed into the chip in order to set the public encryption key.
 
1) Generate the Public Key
    - We must find two values: n and e
    - n: the product of two prime numbers (the larger the better, but n must fit in 13 bits)
        - We used p = 53 and q = 61 where n = p * q = 3233.
    - e: to find e...
        - Compute the Carmichael's Totient Function of the product as λ(n) = lcm(p − 1, q − 1).
            - λ(n) = lcm(p − 1, q − 1) = λ(3233) = lcm(53 − 1, 61 − 1) = 780
        - Choose any number 2 < e < 780 that is coprime to 780.
            - We used e = 17.
 
2) Generate the Private Key
 
    - d: to find d...
        - Compute the modular multiplicative inverse of e (mod λ(n)) = 17 (mod λ(3233)).
        - d = 413 because 1 = (17 * 413) mod 780
 
3) Encryption Function
 
The encryption function for the input data (x) and encrypted output (y) is `y = x^e mod n`.
 
4) Decryption Function
 
The encryption function for the input data (x) and encrypted output (y) is `y = x^d mod n`.
 
## Our Project
 
In order to perform RSA encryption, we have have a 5 state finite state machine (FSM), and two additional states allow a user to change the values of n and e. The job of the finite state machine is to peform the above encryption algorithm without losing data to integer overflow. Based on the input_data_type, a user can choose which operation they would like to perform.
 
The finite state machine in the controller to perform the encryption is as follows:
 
State 1: WAITING
 
    - In the waiting state, the FSM will only transition out of the state when an operation is chosen by the user.
    - If the input_data_type is 1 (DATA_INPUT), the FSM will transition to INITIALIZE to begin the encryption process.
    - If the input_data_type is 2 (N_INPUT), the FSM will transition to UPDATE_N. This allows updating the part of the public key stored on the circuit.
    - If the input_data_type is 3 (E_INPUT), the FSM will transition to UPDATE_E. This allows updating the part of the public key stored on the circuit.
 
State 2: INITIALIZE
 
    - The initialize flag is set to 1, which signals to the datapath to store the data input, initialize a temporary value to x to help calculate x^e, and initialize iterations_left to e.
    - If is_init_done, which checks if the number of iterations left is equal to e, is true, then the FSM will transition to MULTIPLY.
        - When the number of iterations left is equal to e, this means that the encryption process is at the very start because the multiply operation will be performed e times to get the value x^e.
    - If not, then the FSM will remain in the INITIALIZE state.
 
State 3: MULTIPLY
 
    - If is_multiplication_done, which checks if the number of iterations left is equal to 1, is true, then the FSM will transition to DONE.
    - If not, then the flag en_multiply is set to 1, which signals to the datapath to multiply the temporary variable by x again, and the FSM will transition to MODULO.
 
State 4: MODULO
 
    - The FSM will stay in this state until we have performed a whole mod operation, which may take many cycles.
    - While the en_modulo flag is set to 1, the datapath will subtract temporary variable by n until it is less then n, and the FSM transitions to MULTIPLY.
 
State 5: DONE
 
    - The done flag is set to 1, which signals to the datapath to store the temporary variable in the output variable, and the FSM transitions to WAITING. The encrypted value is now safe to be real off of the output pins.
 
State 6: UPDATE_E
 
    - The update_e flag is set to 1, which signals to the datapath to store the input in the e variable, and the FSM transitions to WAITING.
 
State 7: UPDATE_N
 
    - The update_n flag is set to 1, which signals to the datapath to store the input in the n variable, and the FSM transitions to WAITING.


 /*****************************************<br>
 * Project 4 - Regular Expression PhoneNumber Checker <br>
 * Author(s): <br>
 *<br>
 
 Evan Day <eday3@nd.edu><br>
 Sofia Nelson <snelso24@nd.edu> <br>
 James Lindell <jlindel2@nd.edu><br> 
 Eamon Tracey <etracey@nd.edu><br>
 *****************************************/<br>
 
 Our design implements a regular expression validator for phone numbers. We define a phone number to have 10 digits (including the area code), with the digits separated by either dashes, dots, or spaces.

```regex
[0-9]{3}(-[0-9]{3}-[0-9]{4}|\.[0-9]{3}\.[0-9]{4}| [0-9]{3} [0-9]{4})
```

To implement our design in the circuitry, we utilize a controller and datapath. The controller represents the finite state machine that corresponds to the above regular expression. The datapath feeds the input to the controller to determine how to perform each state transition.

The chip takes 3 inputs, `char_in[7:0]`, `reset`, and `process`. The `char_in[7:0]` input is the next character on the input string to be validated, in the form of an 8-bit ASCII value. The `reset` input resets the state of the controller to the initial state. Finally, the `process` input is used to tell the circuit to process the current signals on `char_in[7:0]` and `reset`. Our design works asynchronously, so you must raise `process` from low to high for each state transition to occur. Finally, the `match` output is a boolean value that indicates whether the expression matches.
 
 
/*****************************************<br>
 * Project 5 - Encryption Co Processor <br>
 * Author(s): <br>
 *<br>
 
 Noor Achkar <nachkar@nd.edu><br>
 Marc Edde <medde@nd.edu> <br>
 David Chirumbole <dchirumb@nd.edu><br> 
 *****************************************/<br>
 
 
 
 /*****************************************<br>
 * Project 6 - GF180 Blind Hangman Project <br>
 * Author(s): <br>
 *<br>
 
Josue Guerra <guerra4@nd.edu><br> 
Steven Conaway <sconawa2@nd.edu><br> 
Nicholas Palma <npalma2@nd.edu>
Jacob Bechtel <jbechte2@nd.edu><br>
 *****************************************/<br>
 
Our final project for the Digital Integrated Circuits class at the University of Notre Dame is a game called "Blind Hangman", where the user has 7 tries to guess a 5 letter word. The only feedback on their progress is whether or not they have made a correct guess for a given letter position.

To do this, a 16 state finite state machine was implemented. The game starts in the INIT_GAME state, where it sets the enble and select bits for the game. It then proceeds into the GEN_WORD state, which selects the word from the word ROM based on user input. After the word is selected, it moves to the GUESS state, where the user inputs the letter they guess. Then the FSM proceeds to move through the CHECK_GUESS states, CHECK_GUESS_0, CHECK_GUESS_1, CHECK_GUESS_2, CHECK_GUESS_3, and CHECK_GUESS_4. If the letter matches the letter in that position of the word, it will move to CORRECT_0, CORRECT_1, CORRECT_2, CORRECT_3, or CORRECT_4 from the associated CHECK_GUESS state. It passes back to GUESS from any CORRECT states. If the user guessed a letter not in the word, the FSM moves to the ALL_INCORRECT state. This state increments the tries register, which keeps track of how many incorrect letters the user guessed, like the hangman diagram in the classic game. If all the letters are correct, the FSM moves to the WIN state, and if the user guesses incorrectly seven times, the FSM moves to the LOSE state. It will then go back to the INIT_GAME state for the user to play again.

To implement letters, we used a custom 5 bit encoding for all lowercase English alphabet characters. The letter a is 00000, b is 00001, c is 00010, etc. This was used instead of ASCII to save space as no other characters were necessary for this project. The word ROM stores 64 twenty-five bit words to be selected by the user in the GEN_WORD state. These were generated using a python script and are stored in a text file which is read by verilog to create the ROM. Each words has no duplicate letters, as the FSM was not designed with that in mind.

The chip uses 12 input pins and 7 output pins. The 6 high input pins are used to select which word to play the game with. The next highest pin is the next state pin, which is turned on whenever the FSM needs to change states. The remaining 5 pins are the letter the user guesses using our custom 5 bit letter encoding. The highest output pin is set to one when the user loses the game and the second highest is set to one when the user wins the game. Otherwise, they will remain at zero. The remaining 5 pins turn on if the user correctly guesses the letter in that position. For example, if the word is Notre, if the user guesses an e, the lowest pin will turn to a one.