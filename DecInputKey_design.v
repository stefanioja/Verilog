module DecInputKey(InputKey, ValidCmd, Reset, Clk, Active, Mode);
  input InputKey, ValidCmd, Reset, Clk;
  output reg Active, Mode;
  
  localparam IDLE = 5'b00001;
  localparam S1 = 5'b00010;
  localparam S2 = 5'b00100;
  localparam S3 = 5'b01000;
  localparam S4 = 5'b10000;
  
  reg [4:0] stare_curenta, stare_viitoare;
  reg BitKey;
  reg access;
  reg ModeSet;
  always @(BitKey, stare_curenta) begin
    case(stare_curenta)
      IDLE:
        if(BitKey == 1'b1) stare_viitoare = S1;
     	else stare_viitoare = IDLE;
       S1:
         if(BitKey == 1'b0) stare_viitoare = S2;
     	else stare_viitoare = IDLE;
       S2:
         if(BitKey == 1'b1) stare_viitoare = S3;
     	else stare_viitoare = IDLE;
       S3:
         if(BitKey == 1'b0) begin stare_viitoare = S4; access = 1; end
     	else stare_viitoare = IDLE;
      S4:
        stare_viitoare = S4;
      default: 
        stare_viitoare = IDLE;
    endcase
  end
  
  always @(posedge Clk, posedge Reset) begin
    if(Reset) begin
      access <= 0;
      ModeSet <= 0;
      Active <= 0; Mode <= 0;
      stare_curenta <= IDLE;
      end else begin
        stare_curenta <= stare_viitoare;
      if(ValidCmd) begin
        BitKey <= InputKey;
        if(access) begin
          if(InputKey && ModeSet == 0) begin Active <= 1; Mode <= 1; ModeSet <= 1; end
          else if(ModeSet == 0)begin Active <= 1; Mode <= 0; ModeSet <= 1; end
        end
      end
    end
  end  
endmodule