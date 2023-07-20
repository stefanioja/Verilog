module Mux4(InputALU, InputMemory, CTRL_MODE, Output);
    input [31:0] InputALU, InputMemory;
    input CTRL_MODE;
    output reg [31:0] Output;

    always @(*) begin
        case(CTRL_MODE)
            0: Output = InputALU;
            1: Output = InputMemory;
        endcase
    end
endmodule