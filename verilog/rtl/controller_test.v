module controller_test; 

  localparam integer HLT=0, SKZ=1, ADD=2, AND=3, XOR=4, LDA=5, STO=6, JMP=7;

  reg [5:0] op            ; 
  reg [5:0] funct         ;
  reg       zero          ;
  wire      memread       ;
  wire      memwrite      ;
  wire      alusrca       ;
  wire      memtoreg      ;
  wire      iord          ; 
  wire      pcen          ;
  wire      regwrite      ;
  wire      regdst        ;
  wire [1:0] pcsrc        ;
  wire       alusrcb      ; 
  wire [2:0] alucontrol   ; 
  wire [3:0] irwrite      ;
  


  controller controller_inst 

  (

    .op (op), 
    .funct (funct), 
    .zero (zero), 
    .memread (memread), 
    .memwrite (memwrite), 
    .alusrca (alusrca), 
    .memtoreg (memtoreg), 
    .iord (iord), 
    .pcen (pcen), 
    .regwrite (regwrite), 
    .regdst (regdst), 
    .pcsrc (pcsrc), 
    .alusrcb (alusrcb), 
    .alucontrol (alucontrol), 
    .irwrite (irwrite), 
    
  ); 

  task expect; 
    input [4:0] exp_out; 
    if ({memread, memwrite, alusrca, memtoreg, iord, pcen, regwrite, regdst, pcsrc, alusrcb, alucontrol, irwrite} !== exp_out) begin
      $display("\nTEST FAILED");
      $display("time\top funct zero memtoreg iord pcen regwrite regdst pcsrc alusrcb alucontrol irwrite");
      $display("====\t====== ===== ==== === == ===== ====== ==== ===== ====== ===== ==");
      $display("%0d\t%d      %d     %b    %b   %b  %b     %b      %b    %b     %b      %b     %b",
               $time, op, funct, memtoreg, iord, pcen, regwrite, regdst, pcsrc, alusrcb, alucontrol, irwrite, 
              );
      $display("WANT\t                  %b   %b  %b     %b      %b    %b     %b      %b     %b",
               exp_out[4],exp_out[3],exp_out[2],exp_out[1],exp_out[0]);
      $finish;
    end
  endtask
  
  
  initial begin 

    


  
    


    
    
  
