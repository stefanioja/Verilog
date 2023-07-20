// Code your testbench here
// or browse Examples
module test;
  reg Clk;
  reg [7:0] InA, InB;
  reg [3:0] Sel;
  TEST_IN inf(Clk);
  TEST_OUT infOut(Clk);
  monitorIn mntIn = new();
  monitorOut mntOut = new();
  top DUT(inf.DUT, infOut.DUT);
  assign InA = inf.InA;
  assign InB = inf.InB;
  assign Sel = inf.Sel;
  initial begin
    mntOut.inf = infOut;
     mntOut.run();
  end
  initial begin
     mntIn.inf = inf;
    mntIn.run();
  end
   initial begin
    $dumpfile("dump.vcd");
     $dumpvars(0, test, DUT);
    Clk = 1; inf.InputKey = 1; inf.ValidCmd = 1; inf.RW = 1; inf.Reset = 1;inf.InA = 8'h01; 
    inf.InB =8'h5; inf.Sel = 4'h0; inf.Din = 32'h2; inf.ConfigDiv = 1; inf.Addr = 8'b0;
 
    #8;
    inf.Reset = 0;
    #8;
    inf.InputKey = 0;
    #8;
    inf.InputKey = 1;
    #8;
    inf.InputKey = 0;
    #8;
    inf.InputKey = 1;
    #8;
    inf.Addr = 8'h01;
    #4;
     inf.ValidCmd = 0;
    #8;
    inf.InA = 8'h6; inf.InB =8'h6;
    #16;
    inf.Addr = 0; inf.ValidCmd = 1;
    #16;
    inf.RW = 0; inf.Addr = 1;
     #8;
     inf.RW = 1; inf.ValidCmd = 0;
    #200;
    inf.Addr = 0; inf.RW = 0; inf.ValidCmd = 1;
    #400;
    $finish;
  end
  always #4 Clk = ~Clk;
endmodule
