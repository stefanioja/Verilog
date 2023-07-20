module ALU(A, B, Sel, Out, Flag);
  input [7:0] A, B;
  input [3:0] Sel;
  output reg [7:0] Out;
  output reg[3:0] Flag;
  
  reg [7:0] shift2;
  always @(*) begin
    Flag = 4'h0;
    case(Sel)
        4'h0: begin
          Flag[1] = (A + B > 255) ? 1 : 0; 
          Out = A + B;
        end
        4'h1: begin
          Flag[3] = (A < B) ? 1 : 0;
          Out = A - B;
        end
        4'h2: begin
          Flag[2] = (A * B > 255) ? 1 : 0;
          Out = A * B;
        end
        4'h3: begin
          	Flag[3] = (A < B) ? 1 : 0; 
            Out = A / B;
        end
        4'h4:begin
          if(B >= 8) Flag[1] = 1;
          else begin
            shift2 = (2 << B);
            if(A * shift2 > 255) Flag[1] = 1;
          end
          Out =  A << B;
        end
        4'h5: begin
          if(B >= 8) Flag[1] = 1;
          else begin
            shift2 = (2 << B);
            if(A < shift2) Flag[1] = 1;
          end
          Out = A >> B;
        end
        4'h6: Out =  A & B;
        4'h7: Out =  A | B;
        4'h8: Out = A ^ B;
        4'h9: Out =  ~(A ^ B);
        4'hA: Out =  ~(A & B);
        4'hB: Out = ~(A | B);
        default: begin
            Out = 8'h00;
            Flag = 4'h0;
        end
    endcase
    Flag[0] = (Out == 0 && Sel >= 4'h0 && Sel <= 4'hB) ? 1 : 0;
  end
endmodule