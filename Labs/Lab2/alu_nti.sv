module alu #(parameter WIDTH = 8) 
(
 input wire [WIDTH-1:0] in_a, in_b, 
 input wire [2:0] opcode, 
 output reg [WIDTH-1:0] alu_out, 
 output wire a_is_zero 
); 
 logic [WIDTH-1:0] sum; 
logic carry; 
FA_parametrized #(WIDTH) fa0 (in_a, in_b, 1'b0, sum, carry); 
always_comb begin
        case (opcode)
            3'b000: alu_out = in_a; 
	    3'b001: alu_out = in_a; 
	    3'b010: alu_out = sum; 
	    3'b011: alu_out = in_a & in_b; 
	    3'b100: alu_out = in_a ^ in_b; 
	    3'b101: alu_out = in_b;
	    3'b110: alu_out = in_a;  
	    3'b111: alu_out = in_a;
	    default: alu_out = '0; 
        endcase
    end

assign a_is_zero = (in_a == '0); 
endmodule
