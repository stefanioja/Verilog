module FrequencyDivider(Din, ConfigDiv, Reset, Clk, Enable, ClkOut);
  input [32 - 1:0] Din;
  input ConfigDiv, Reset, Clk, Enable;
  output reg ClkOut;
  
  reg [32 - 1:0] configure;
  reg[32 - 1:0] counter = 0;
  always @(posedge Clk, negedge Clk) begin
    if(Reset) begin
      ClkOut <= 0;
      configure <= 1;
      counter <= 0; 
    end else if (Clk) begin
      if(Enable == 0) begin 
        ClkOut <= 0;
        if(ConfigDiv == 1 && Din != 0) begin configure <= Din; counter <= 0;end
      end else begin
        if(configure != 1) begin
          counter <= counter + 1;
        if(counter < configure / 2) ClkOut = 1;
        else ClkOut = 0;
        if(counter == configure - 1) counter <= 0;
        end else ClkOut = Clk;
      end
    end else if(configure == 1) ClkOut = Clk; 
  end
endmodule