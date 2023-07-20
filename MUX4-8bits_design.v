module Mux1To3 #(parameter N = 8)
  (Input, ResetTmp, Output);
  input [N - 1:0] Input;
    input ResetTmp;
  output reg [N - 1:0] Output;

    always @(*) begin
        case(ResetTmp)
            0: Output = Input;
            1: Output = 8'b0;
        endcase
    end
endmodule