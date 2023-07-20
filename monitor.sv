`include "interface_top.sv"
class monitorIn;
  virtual TEST_IN inf;
  
  function new();
  endfunction
  
  task run();
    forever begin
      @(posedge inf.Clk);
      $display("[$monitorInput] time = %0t, InputKey=%0b, ValidCmd=%0b, RW=%0b, ConfigDiv=%0b, Reset=%0b, Addr=0x%0h, InA=0x%0h, InB=0x%0h, Sel=0x%0h", $time, inf.InputKey, inf.ValidCmd, inf.RW, inf.ConfigDiv, inf.Reset, inf.Addr, inf.InA, inf.InB, inf.Sel, inf.Din);
    end
  endtask
endclass

class monitorOut;
  virtual TEST_OUT inf;
  
  function new();
  endfunction
  
  task run();
    forever begin
      @(posedge inf.Clk);
      $display("[$monitorOutput] time = %0t, CalcActive=%0b, Busy=%0b, CalcMode=%0b, DOutValid=%0b, ClkTx==%0b, DataOut=0x%0h", $time, inf.CalcActive, inf.Busy, inf.CalcMode, inf.DOutValid, inf.ClkTx, inf.DataOut);
    end
  endtask
endclass
