interface TEST_IN(input Clk);
  logic InputKey, ValidCmd, RW, ConfigDiv, Reset;
  logic [7:0] Addr, InA, InB;
  logic [3:0] Sel;
  logic [31:0] Din;
  
  modport DUT(input InputKey, ValidCmd, RW, Addr, InA, InB, Sel, ConfigDiv,
              Din, Reset, Clk);
endinterface

interface TEST_OUT(input Clk);
  logic CalcActive, Busy, CalcMode, DOutValid, ClkTx;
  logic [4 - 1:0] DataOut;
  
  modport DUT(output CalcActive, Busy, CalcMode, DOutValid, ClkTx, DataOut);
endinterface