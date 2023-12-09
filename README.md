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
|0|0|0|0|verilog/rtl/proj0.v|Professor Matthew Morrison 
|0|0|0|1|verilog/rtl/proj1.v|Aidan Oblepias, Leo Herman, Allison Gentry, Garrett Young
|0|0|1|0|verilog/rtl/proj2.v|Antonio Karam, Sean Froning, Varun Taneja, Brendan McGinn
|0|0|1|1|verilog/rtl/proj3.v| |
|0|1|0|0|verilog/rtl/proj4.v| |
|0|1|0|1|verilog/rtl/proj5.v| |
|0|1|1|0|verilog/rtl/proj6.v| |
|0|1|1|1|verilog/rtl/proj7.v| |
|1|0|0|0|verilog/rtl/proj8.v| |
|1|0|0|1|verilog/rtl/proj9.v| |
|1|0|1|0|verilog/rtl/proj10.v| |
|1|0|1|1|verilog/rtl/proj11.v| |
|1|1|0|0|verilog/rtl/proj12.v| |
|1|1|0|1|verilog/rtl/proj13.v| |
|1|1|1|0|verilog/rtl/proj14.v| |
|1|1|1|1|verilog/rtl/proj15.v| |
 
/*****************************************
 * Project 0 - MIPS Demo 
 * Author(s): Professor Morrison 
 *
 * Email - matt.morrison@nd.edu 
 *****************************************/

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
	Varun Taneja vtaneja@nd.edu<br>
	Brendan McGinn bmcginn2@nd.edu<br>
	Sean Froning sfroning@nd.edu<br>
	Antonio Karam akaram@nd.edu<br>
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