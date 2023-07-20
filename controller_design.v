`include "DecInputKey_design.v"
`include "Control_RW_Flow_design.v"

module controller(input InputKey, Clk, ValidCmd, Reset, RW, TxDone, 
                  output Active, Busy, RWMem, AccessMem, Mode, SampleData, TxData);
  
  DecInputKey DIK(InputKey, ValidCmd, Reset, Clk, Active, Mode);
  Control_RW_Flow CRWF(ValidCmd, RW, Reset, Clk, TxDone, Active, Mode,
                       AccessMem, RWMem, SampleData, TxData, Busy);
  
endmodule