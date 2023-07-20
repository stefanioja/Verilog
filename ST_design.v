module SerialTransceiver #(parameter N = 1)
  (DataIn, Sample, StartTx, TxDone, Reset, Clk, ClkTx, Txbusy, Dout);
  input [32 - 1:0] DataIn;
  input Sample, StartTx, Reset, Clk, ClkTx;
  output reg TxDone, Txbusy;
  output reg [N - 1:0] Dout;
  
  reg [N - 1:0] concatenate  = 0;
  reg transfer = 0;
  reg [32:0] counter = 0;
  reg done = 0;
  reg [32 - 1:0] RegBank;
  integer index;

  always @(posedge Reset, posedge Clk) begin
    if(Reset) begin
      done <= 0;
      TxDone <= 0;
      Dout <= 0;
      Txbusy <= 0;
      transfer <= 0;
    end else if(Clk) begin
      if(Sample) begin RegBank <= DataIn; counter <= 0; end
      if(StartTx && counter == 0) transfer <= 1;
      if(done) TxDone <= 1;
      if(TxDone) begin
        TxDone <= 0;
        done <= 0;
        transfer <= 0;
      end
    end
  end
  
  always @(posedge ClkTx) begin
    if(!Reset) begin
      if(transfer || Clk && StartTx) begin
        if(counter < 32) Txbusy <= 1;
      Dout <= RegBank[32 - 1:32 - N];
      RegBank <= { RegBank[32 - 1 - N:0], concatenate};
      counter <= counter + N;
      end else Txbusy <= 0;
      if(counter == (32 - N)) begin done <= 1; Txbusy <= 0; end
    end
  end
endmodule