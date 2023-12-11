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
 
 <br>
 
 /*****************************************<br>
 * Project 2 - Cool Ranch <br>
 * Author(s): <br>
 *<br>
	Varun Taneja <vtaneja@nd.edu><br>
	Brendan McGinn <bmcginn2@nd.edu><br>
	Sean Froning <sfroning@nd.edu><br>
	Antonio Karam <akaram@nd.edu><br>
 *****************************************/<br>

Our final project is an implementant of a Linear Shift Feedback Register (LSFR) in verilog.

An LSFR acts as a pseudorandom number generator.

inputs: switches [7:0], seq_num [7:0], start

outputs: num[7:0], busy

internal variables: tap0[3:0], tap1[3:0], i[3:0], j[7:0], switch_shift[7:0]

An N-bit linear feedback shift register (LFSR) produces an N-bit pseudo random number.

The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers.

For example, in L17, the registers were initialized to 0001 and the taps were on q[3] and q[0].

The verilog emulates as if the inputs were switches on an FGPA board, from SW0 - SW15.

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
 
Developed as a final project for the University of Notre Dame's Digital Integrated Circuits class. It plays a game of blind hangman using a finite state machine.