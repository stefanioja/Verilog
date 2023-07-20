module memory #(parameter Width = 256, DinLENGTH = 32)
  (Din, Addr, R_W, Valid, Reset, Clk, Dout);
  
  input [DinLENGTH - 1:0] Din;
  input [7:0] Addr;
  input R_W, Valid, Reset, Clk;
  
  output reg[DinLENGTH - 1:0] Dout;
  
  reg [DinLENGTH - 1:0] RegBank [Width - 1:0];
	integer index;
  always @(posedge Clk, posedge Reset) begin
    if(Reset) begin
      Dout <= 0;
      for(index = 0; index < Width;index++) begin
        RegBank[index] <= 0;
      end
    end else if(Clk) begin
      if(Valid == 0) Dout <= 0;
      else begin
        if(R_W == 0) Dout <= RegBank[Addr];
        else  RegBank[Addr] <= Din;
      end
    end
  end
  endmodule