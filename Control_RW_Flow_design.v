module Control_RW_Flow(input ValidCmd, RW, Reset, Clk, TxDone, Active, Mode,
                       output reg AccessMem, RWMem, SampleData, TxData, Busy);
  
  localparam IDLE = 7'b0000001;
  localparam READMEMORY = 7'b0000010;
  localparam SAMPLETRANSCEIVER = 7'b0000100;
  localparam STARTTRANSFER = 7'b0001000;
  localparam WAITTRANSFER = 7'b0010000;
  localparam WRITEMEMORY = 7'b0100000;
  localparam SAMPLESERIAL = 7'b1000000;
  
  reg [6:0] stare_curenta, stare_viitoare;
  always @(ValidCmd, Active, Mode, RW, TxDone, stare_curenta) begin
    case(stare_curenta)
      IDLE:
        if(ValidCmd == 1 && Active == 1 && Mode == 1 && RW == 0)
          stare_viitoare = READMEMORY;
      else if(ValidCmd == 1 && Active == 1 && Mode == 1 && RW == 1)
        stare_viitoare = WRITEMEMORY;
      else if(ValidCmd == 1 && Active == 1 && Mode == 0)
        stare_viitoare = SAMPLESERIAL;
       else stare_viitoare = IDLE;
    
      READMEMORY:
        if(Active && Mode && TxDone == 0)
          stare_viitoare = SAMPLETRANSCEIVER;
      else stare_viitoare = IDLE;
      
      SAMPLETRANSCEIVER:
        if(Active && TxDone == 0)
          stare_viitoare = STARTTRANSFER;
      else stare_viitoare = IDLE;
      
      STARTTRANSFER:
        if(Active && TxDone == 0)
          stare_viitoare = WAITTRANSFER;
      	else stare_viitoare = IDLE;
      
      WAITTRANSFER:
        if(Active && TxDone == 0)
          stare_viitoare = WAITTRANSFER;
      	else stare_viitoare = IDLE;
      
      WRITEMEMORY:
        stare_viitoare = IDLE;
      
      SAMPLESERIAL:
        if(Active && Mode == 0 && TxDone == 0)
          stare_viitoare = STARTTRANSFER;
        else stare_viitoare = IDLE;
      
      default: stare_viitoare = IDLE;
    endcase
  end
  
  always @(posedge Clk, posedge Reset) begin
    if(Reset) begin
      stare_curenta <= IDLE;
      AccessMem <= 0;
      RWMem <= 0;
      SampleData <= 0;
      TxData <= 0;
      Busy <= 0;
    end else if(Clk) begin
      stare_curenta <= stare_viitoare;
    end
  end
  
  always @(stare_curenta) begin
    case(stare_curenta)
      IDLE: begin
      AccessMem = 0;
      RWMem = 0;
      SampleData = 0;
      TxData = 0;
      Busy = 0;
      end
        
      READMEMORY:
        begin AccessMem=1; RWMem=0; Busy = 1; end 
      
      SAMPLETRANSCEIVER:
        begin AccessMem = 0; SampleData = 1; end
      
      STARTTRANSFER:
        begin TxData = 1; SampleData = 0; end
      
      WAITTRANSFER:
        begin TxData = 1; end
      
      WRITEMEMORY:
        begin AccessMem=1; RWMem=1; Busy=1; end 
      
      SAMPLESERIAL:
        begin SampleData = 1; Busy = 1; end
        
    endcase
  end
endmodule