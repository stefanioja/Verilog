`include "MUX4-8bits_design.v"
`include "ALU_design.v"
`include "MUX32bits_design.v"
`include "concatenator_design.v"
`include "ST_design.v"
`include "FD_design.v"
`include "controller_design.v"
`include "memory_design.v"
`include "monitor.sv"
module top #(parameter N = 4)
  (inf, infOut);
  
  TEST_IN inf;
  TEST_OUT infOut;
  
  wire [7:0] OutALU, OutA, OutB;
  wire [3:0] FlagALU, OutSel;
  wire [31:0] OutConcatenate, OutMem, DataIn;
  wire TxDone;
  
  wire SampleData, TxData, RWMem, AccessMem;
  Mux1To3 #(8) M1(inf.InA, inf.Reset, OutA);
  Mux1To3 #(8) M2(inf.InB, inf.Reset, OutB);
  Mux1To3 #(4) M3(inf.Sel, inf.Reset, OutSel);
  ALU M_ALU(OutA, OutB, OutSel, OutALU, FlagALU);
  concatenator Concatenator(OutA, OutB, OutALU, OutSel ,FlagALU, OutConcatenate);
  SerialTransceiver #(N) ST(DataIn, SampleData, TxData, TxDone, inf.Reset, inf.Clk, infOut.ClkTx, infOut.DOutValid,
                            infOut.DataOut);
  FrequencyDivider FD(inf.Din, inf.ConfigDiv, inf.Reset, inf.Clk, infOut.CalcActive, infOut.ClkTx);
  controller CRW(inf.InputKey, inf.Clk, inf.ValidCmd, inf.Reset, inf.RW, TxDone, infOut.CalcActive, infOut.Busy,
                 RWMem, AccessMem, infOut.CalcMode, SampleData, TxData);
  memory #(256, 32) MEM(OutConcatenate, inf.Addr, RWMem, AccessMem, inf.Reset, inf.Clk, OutMem);
  Mux4 M4(OutConcatenate, OutMem, infOut.CalcMode, DataIn);
endmodule
