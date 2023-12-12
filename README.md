# Notre Dame Fall 2023 CSE 30342 GF180 Group Projects

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://platform.efabless.com/shuttles/GFMPW-1?_gl=1*128mnaf*_gcl_au*MjA1NzQ1Njk3OS4xNzAyMzM3MDkw*_ga*MTE5OTU4MzM2OC4xNzAyMzM3MDkw*_ga_GHTCZK9NXD*MTcwMjM0OTc5OC4zLjEuMTcwMjM1NjUxNy4yNi4wLjA.)

### Professor

Matthew Morrison, Associate Teaching Professor, University of Notre Dame<br>
<matt.morrison@nd.edu><br>

### Teaching Assistants:
Lindsay Falk	<lfalk2@nd.edu><br>
David Finnell	<dfinnell@nd.edu><br>
Ethan Lau	<elau@nd.edu><br>
Drew Lair	<dlair@nd.edu><br>
Dani Nah	<hnah@nd.edu><br>
Richard McManus	<rmcmanu2@nd.edu><br>
Mike Slusarczyk	<mslusarc@nd.edu><br>
Zack Tyler	<ztyler2@nd.edu><br>

### Overview

This design contains the 12 group projects for the Fall 2023 CSE 30342 Digital Integrated Circuits course at the University of Notre Dame. In this README.md file, the contents of their projects are detailed. The student's work is cited, and the ways to access their specific scope of the project through the wbs_sel_i select signal are detailed. Each student has been added as a collaborator to this project.


### Signals to Projects Correlation 

Here is the correlation between the wbs_sel_i signals and the student projects, as well as student citation:
					
|[3]|[2]|[1]|[0]|Location|Authors|
|---|---|---|---|---|---|
|0|0|0|0|verilog/rtl/projects/proj0_morrison.v|Professor Matthew Morrison|
|0|0|0|1|verilog/rtl/projects/proj1_aoblepia.v|Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young|
|0|0|1|0|verilog/rtl/projects/proj2_akaram.v|Antonio Karam, Sean Froning, Varun Taneja, Brendan McGinn|
|0|0|1|1|verilog/rtl/projects/proj3_dsimone2.v|David Simonetti, Thomas Mercurio, Brooke Mackey|
|0|1|0|0|verilog/rtl/projects/proj4_evstar3.v|Evan Day, Sofia Nelson, James Lindell, Eamon Tracey|
|0|1|0|1|verilog/rtl/projects/proj5_dchirumb.v|Noor Achkar, David Chirumbole, Marc Edde|
|0|1|1|0|verilog/rtl/projects/proj6_jbechte2.v|Josue Guerra, Steven Conaway, Nicholas Palma, Jacob Bechtel|
|0|1|1|1|verilog/rtl/projects/proj7_khjorth.v|Kate Hjorth, Abby Brown, Nathan Piecyk|
|1|0|0|0|verilog/rtl/projects/proj8_lcsaszar.v|Lydia Csaszar, Dan Schrage, Kate Mealey, Phyona Schrader|
|1|0|0|1|verilog/rtl/projects/proj9_skopfer.v|Sarah Kopfer, Anna Briamonte, Gavin Carr, Allison Fleming|
|1|0|1|0|verilog/rtl/projects/proj10_zvincent.v|Zach Vincent, Daniel Yu, Andrew Mitchell|
|1|0|1|1|verilog/rtl/projects/proj11_jfrabut2.v|Jacob Frabutt, Brigid Burns, Rory St. Hilare|
 
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
|WAIT|busy ← 0|if (start) goto INIT; else goto WAIT|
|INIT|i ← -1; j ← 0; busy ← 1; tap0 ← 1; tap1 ←0; switch_shift ← switches; num ← 1|goto FIND_TAP0|
|FIND_TAP0|i ← i + 1; switch_shift ← switch_shift >> 1|if (i == 8) goto CALCULATE;else if (switches[0] == 1) goto UPDATE_TAP0;else goto FIND_TAP0|
|UPDATE_TAP0|tap0 ← i|goto FIND_TAP1|
|FIND_TAP1|i ← i + 1; switch_shift ← switch_shift >> 1|if (i == 8) goto CALCULATE; else if (switches[0] == 1) goto UPDATE_TAP1; else goto FIND_TAP1|
|UPDATE_TAP1|tap1 ← i|goto CALCULATE|
|CALCULATE|j ← j + 1; num ← {num[6:0], num[tap0] ^ num[tap1]}|if (j == seq_num) goto FINISH; else goto CALCULATE|
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

The project starts with a "Start" that is at state 0. The mode will determine if the project encrypts or decrypts. In fact, in the event the mode is equal to 1, it will go through the decryption process and if it is 0, it will encrypt.
Encrypt is at state 3. If the reset is set to 0, it will go to the second encryption that is at state 4. If the reset is set to 1, it will go to the reset at state 1. In the event it goes to the second encryption, it will either go to the "Finish" at state 2 (for reset = 0) or go to the reset when reset is equal to 1.
Decrypt is at state 5. If the reset is set to 0, it will go to the second decryption that is at state 6. If the reset is set to 1, it will go to the reset at state 1. In the event it goes to the second decryption, it will either go to the "Finish" at state 2 (for reset = 0) or go to the reset when reset is equal to 1.
When it gets to the "Finish" state, it will automatically go back to the "Start".
When it gets to the "Reset" state, it also goes automatically to the "Start" state.

 
 
/*****************************************<br>
* Project 6 - GF180 Blind Hangman Project <br>
* Author(s): <br>
 
Josue Guerra <guerra4@nd.edu><br> 
Steven Conaway <sconawa2@nd.edu><br> 
Nicholas Palma <npalma2@nd.edu>
Jacob Bechtel <jbechte2@nd.edu><br>
 *****************************************/<br>
 
Our final project for the Digital Integrated Circuits class at the University of Notre Dame is a game called "Blind Hangman", where the user has 7 tries to guess a 5 letter word. The only feedback on their progress is whether or not they have made a correct guess for a given letter position.

To do this, a 16 state finite state machine was implemented. The game starts in the INIT_GAME state, where it sets the enble and select bits for the game. It then proceeds into the GEN_WORD state, which selects the word from the word ROM based on user input. After the word is selected, it moves to the GUESS state, where the user inputs the letter they guess. Then the FSM proceeds to move through the CHECK_GUESS states, CHECK_GUESS_0, CHECK_GUESS_1, CHECK_GUESS_2, CHECK_GUESS_3, and CHECK_GUESS_4. If the letter matches the letter in that position of the word, it will move to CORRECT_0, CORRECT_1, CORRECT_2, CORRECT_3, or CORRECT_4 from the associated CHECK_GUESS state. It passes back to GUESS from any CORRECT states. If the user guessed a letter not in the word, the FSM moves to the ALL_INCORRECT state. This state increments the tries register, which keeps track of how many incorrect letters the user guessed, like the hangman diagram in the classic game. If all the letters are correct, the FSM moves to the WIN state, and if the user guesses incorrectly seven times, the FSM moves to the LOSE state. It will then go back to the INIT_GAME state for the user to play again.

To implement letters, we used a custom 5 bit encoding for all lowercase English alphabet characters. The letter a is 00000, b is 00001, c is 00010, etc. This was used instead of ASCII to save space as no other characters were necessary for this project. The word ROM stores 64 twenty-five bit words to be selected by the user in the GEN_WORD state. These were generated using a python script and are stored in a text file which is read by verilog to create the ROM. Each words has no duplicate letters, as the FSM was not designed with that in mind.

The chip uses 12 input pins and 7 output pins. The 6 high input pins are used to select which word to play the game with. The next highest pin is the next state pin, which is turned on whenever the FSM needs to change states. The remaining 5 pins are the letter the user guesses using our custom 5 bit letter encoding. The highest output pin is set to one when the user loses the game and the second highest is set to one when the user wins the game. Otherwise, they will remain at zero. The remaining 5 pins turn on if the user correctly guesses the letter in that position. For example, if the word is Notre, if the user guesses an e, the lowest pin will turn to a one.

/*****************************************<br>
* Project 7 - Multiplier Finite State Machine Example <br>
* Author(s): <br>

Kate Hjorth <khjorth@nd.edu><br>
Abby Brown <abrown35@nd.edu><br>
Nathan Piecyk <npiecyk@nd.edu><br>
 *****************************************/<br>
 
Our code multiplies two four bit numbers by use of a combination of a finite state machine and a multiplier, which is made up of half adders and full adders. It utilizes a finite state machine to drive the multiplier, which in itself uses four half adders and eight full adders. These adders are combined in such a way to efficiently multiply two four bit numbers. The finite state machine has six states, IDLE, LOAD, MULTIPLY, CHECK, LOAD_P, and DONE. In the idle state, the P register is initialized. In the load state, inputs A and B are loaded in. In the multiply state, the multiplier is called, and using the half and full adders, it multiplies A and B and stores the result in P. Next, in the check state, we check if P is greater than 15. If it is, we return to the idle state, and if not, we switch to the load_p state, where the result P is loaded into the B input, and then transition to the multiply state again.
 

/*****************************************<br>
* Project 8 - Traffic Light Controller <br>
* Author(s): <br>

Dan Schrage <dschrag2@nd.edu><br>
Lydia Csaszar <lcsaszar@nd.edu><br>
Kate Mealey <kmealey2@nd.edu><br>
Phyona Schrader <pschrad2@nd.edu><br>
 *****************************************/<br>

### Project: Traffic Light Controller
#### About
This project is based on the examples in section **2.4.5** of Digital Electronics 3: Finite-state Machines, and the FSM state machine example from Chapter 5 Section 5 of Figure 5.5 of The Zen of Exotic Computing [2][1]. There are two modules to the design: the controller and the counter. The counter has the inputs of EN =1, clk, clr (clear) with the outputs of rco<sub>L</sub> (long count), rco<sub>s</sub> (short count). The counter-output values are fed into S and L controller inputs, respectively. Then, the controller has the remaining R, C, and clk inputs, with IC, NR, NG, NY, ER, EG, and EY outputs. The outputs of the N value represent the state of the traffic light facing north-south streets, while the output of the values starting with E represents the state of the traffic light facing east and west. By default, the North/South street is green, while the East/West street is red. Changes in state color are determined by the value of C "detecting" a car present on the East-West street(s).

![image](https://github.com/lcsaszar01/Signal_Sages/assets/78165687/59580a2d-fd60-4695-9f06-5a8f22887549) [2]

|References|
|------------------------|
|[1] Kogge, P. M. (2022). The Zen of Exotic Computing. United States: Society for Industrial and Applied Mathematics.|
|[2] Ndjountche, T. (2016). Digital Electronics 3: Finite-state Machines. United Kingdom: Wiley.|

 
/*****************************************<br>
* Project 9 - Netflix Behavior Predictor <br>
* Author(s): <br>

Sarah Kopfer <skopfer@nd.edu><br>
Anna Briamonte <abriamon@nd.edu><br>
Gavin Carr <gcarr2@nd.edu><br>
Allison Fleming <aflemin7@nd.edu><br>
 *****************************************/<br>

`netflix.v` is a Verilog module designed to predict weekly Netflix user behavior in the context of a five-season show. It estimates the user's current viewing state, the number of complete show viewings (up to a maximum of three), and tracks the total number of weeks the simulation has been running. The module also counts the number of users simulated, with a new user's behavior prediction starting upon a reset. The week counter is cumulative throughout the simulation.

## Inputs and Outputs
- **Inputs:**
  - `clk`: Clock input.
  - `rst`: Reset input to begin tracking a new user.
  - `tl`: 2-bit input representing time availability (`t`) and liking of the show (`l`).

- **Outputs:**
  - `output_result`: 15-bit output encoding various statistics. This output is divided into four sections:
    - **Person Counter (Bits 14:12 - 3 bits):** Tracks the number of users simulated. Increments with each reset, indicating a new user.
    - **Week Counter (Bits 11:5 - 7 bits):** Represents the cumulative count of weeks since the simulation started. It continuously increments, independent of resets.
    - **Finished Counter (Bits 4:3 - 2 bits):** Counts how many times the user has watched the entire show, with a maximum count of 3.
    - **State (Bits 2:0 - 3 bits):** Indicates the current state of the user's viewing progress, ranging from 'Not Started' to 'Finished' (covering all five seasons).

## States
- `NS` (Not Started)
- `S1` to `S5` (Season 1 to Season 5)
- `F` (Finished)

## Functionality
- **State Machine:** The module operates as a state machine, progressing through states based on the `tl` input and the current state.
- **Week Counter:** Increments each clock cycle, tracking the simulation duration.
- **Person Counter:** Increments upon a reset (`rst`), signaling a new user.
- **Finished Counter:** Tracks the number of times the user has finished the show.
- **Next State Logic:** Determines the next state based on the current state, time availability (`t`), and show liking (`l`).

## Simulation Details
- The user progresses through the seasons based on their time availability and liking for the show.
- Once a user finishes the show, the `finished` counter increments. If it hasn't reached the maximum count (3), the state resets to `NS`.
- The `week_counter` and `person_counter` provide an ongoing tally of the simulation's duration and the number of users simulated, respectively.

## State Transition Logic

The state machine employed uses a combination of user's time availability and show liking to determine the transitions between different states. Here's a detailed breakdown of what is required for a user to move from one state to another and the rationale behind it:

### State Transitions
- **Not Started (NS) to Season 1 (S1):** 
  - **Requirement:** User must have both time (`t`) and a liking (`l`) for the show.
  - **Rationale:** Starting a new show typically requires both an interest in the content and availability of free time.

- **Season 1 (S1) to Season 2 (S2), and so on up to Season 4 (S4):**
  - **Requirement:** Continued time availability and liking for the show.
  - **Rationale:** Progression through consecutive seasons is based on the user continuing to enjoy the show and having time to watch it.

- **Season 4 (S4) to Season 5 (S5):**
  - **Requirement:** Liking for the show, irrespective of time availability.
  - **Rationale:** By the time a user reaches the fourth season, it is assumed that they are invested enough in the show to find time to watch the final season, reflecting a typical binge-watching behavior.

- **Season 5 (S5) to Finished (F):**
  - **Requirement:** Either time availability or liking for the show.
  - **Rationale:** Completion of the final season and thereby the entire series occurs if the user continues to like the show or has spare time. This accounts for the tendency to complete a series even if interest wanes slightly, just to see how it ends.

- **Finished (F) to Not Started (NS) or Stay in Finished (F):**
  - **Requirement:** Depends on the number of times the show has been finished.
  - **Rationale:** Once a user finishes the show, they may choose to rewatch it. This cycle can occur up to three times, reflecting typical viewer behavior where some shows are rewatched multiple times. After three complete viewings, the user remains in the Finished state, assuming they move on to other content.

### Additional Notes
- **Time (t) and Liking (l) Logic:** The model uses these two binary inputs to simulate the decision-making process of a viewer. While simplistic, they capture two critical factors in content consumption: availability and interest.
- **Week Counter:** The week counter increases regardless of state changes, indicating the passage of time in the simulation.

### Implications
- This state transition logic models typical user behavior patterns in consuming a multi-season television show.
- It reflects the balance between interest in content (liking) and practical considerations (time availability).
- The model's simplicity makes it broadly applicable but may not capture the nuances of individual viewing habits or external factors influencing viewing decisions.

## Limitations
- This model is a simplification and may not accurately predict all user behaviors.
- The prediction is based solely on the binary inputs of time availability and show liking, which may not encompass all factors influencing user behavior.

## Future Enhancements
- Introducing more nuanced metrics for time and interest, possibly on a scale, to better capture varying degrees of viewer engagement.
- Considering external factors like peer influence, marketing, or platform recommendations which might alter viewing patterns.
 
 
 /*****************************************<br>
* Project 10 - Traffic Stop Simulator <br>
* Author(s): <br>

Zach Vincent <zvincent@nd.edu><br>
Daniel Yu <dyu4@nd.edu><br>
Andrew Mitchell <amitch27@nd.edu><br>
 *****************************************/<br>

This project lays out a processor that acts as a traffic controller, deciding the traffic signals at a 4-way intersection. It takes in 4 1-bit inputs (named the cardinal directions `n`, `e`, `s`, `w`) representing the presence of a car at each of the four streets. It then determines what color the street lights should be, and outputs an 8-bit number representing the state of the lights with 2 bits for each direction. `00` represents a red light, `01` represents a yellow light, and `10` represents a green light. For example, the output `00100010` would represent green lights in the east and west directions. The chip is programmed only to change the lights when there are cars waiting at the cross street. If there are no cars with a red light at the intersection, the light will stay green in the current direction. When signals need to switch, the green and yellow lights employ a minimum wait time so that the lights are guaranteed to stay the same for a certain number of clock cycles before allowing input changes to affect the state.


/*****************************************<br>
* Project 11 - DES Encryption Simulator <br>
* Author(s): <br>

Jacob Frabutt <jfrabut2@nd.edu><br>
Brigid Burns <bburns4@nd.edu><br>
Rory St. Hilaire <rsthila2@nd.edu><br>
 *****************************************/<br>
 
Our project creates hardware to implement a simple encryption algorithm: simple DES. Simple DES takes in 8-bits of plaintext and 10-bit key. Since we only have 16-bits of input, the 2 most significant bits of the key are simply pre-set. This one 10-bit key then goes through some shift and permutation operations to create two 8-bit keys which are used internally. The plaintext and keys are then used as inputs to an encryption module. This module contains multiple steps of permutations, expansion, XOR, and shifting to generate the ciphertext. The full simple DES algorithm also implements something called switch functions, but because these require memory to be implemented, and due to the scope and time limitations of our project, we did not include this step. The output of our module is the 8-bit ciphertext that resulted from encryption.
