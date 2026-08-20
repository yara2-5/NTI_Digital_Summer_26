module control (
    input        clk,
    input        rst,
    input        zero,
    input  [2:0] phase,
    input  [2:0] opcode,

    output reg   sel,
    output reg   rd,
    output reg   ld_ir,
    output reg   halt,
    output reg   inc_pc,
    output reg   ld_ac,
    output reg   ld_pc,
    output reg   wr,
    output reg   data_e
);

    localparam INST_ADDR  = 3'b000;
    localparam INST_FETCH = 3'b001;
    localparam INST_LOAD  = 3'b010;
    localparam IDLE       = 3'b011;
    localparam OP_ADDR    = 3'b100;
    localparam OP_FETCH   = 3'b101;
    localparam ALU_OP     = 3'b110;
    localparam STORE      = 3'b111;

    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    reg aluop_c;    
    reg halt_c;    
    reg jmp_c;      
    reg sto_c;      
    reg skz_zero_c; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sel    <= 1'b0;
            rd     <= 1'b0;
            ld_ir  <= 1'b0;
            halt   <= 1'b0;
            inc_pc <= 1'b0;
            ld_ac  <= 1'b0;
            ld_pc  <= 1'b0;
            wr     <= 1'b0;
            data_e <= 1'b0;
        end
        else begin
            aluop_c    = (opcode == ADD) || (opcode == AND) ||
                         (opcode == XOR) || (opcode == LDA);
            halt_c     = (opcode == HLT);
            jmp_c      = (opcode == JMP);
            sto_c      = (opcode == STO);
            skz_zero_c = (opcode == SKZ) && zero;
            sel    <= 1'b0;
            rd     <= 1'b0;
            ld_ir  <= 1'b0;
            halt   <= 1'b0;
            inc_pc <= 1'b0;
            ld_ac  <= 1'b0;
            ld_pc  <= 1'b0;
            wr     <= 1'b0;
            data_e <= 1'b0;

            case (phase)
                INST_ADDR: begin
                    sel <= 1'b1;
                end

                INST_FETCH: begin
                    sel <= 1'b1;
                    rd  <= 1'b1;
                end

                INST_LOAD: begin
                    sel   <= 1'b1;
                    rd    <= 1'b1;
                    ld_ir <= 1'b1;
                end

                IDLE: begin
                    sel   <= 1'b1;
                    rd    <= 1'b1;
                    ld_ir <= 1'b1;
                end

                OP_ADDR: begin
                    halt   <= halt_c;
                    inc_pc <= 1'b1;
                end

                OP_FETCH: begin
                    rd <= aluop_c;
                end

                ALU_OP: begin
                    rd     <= aluop_c;
                    inc_pc <= skz_zero_c;
                    ld_ac  <= aluop_c;
                    ld_pc  <= jmp_c;
                    data_e <= sto_c;
                end

                STORE: begin
                    rd     <= aluop_c;
                    ld_pc  <= jmp_c;
                    wr     <= sto_c;
                    data_e <= sto_c;
                end

                default: begin
                    sel    <= 1'b0;
            	    rd     <= 1'b0;
                    ld_ir  <= 1'b0;
                    halt   <= 1'b0;
                    inc_pc <= 1'b0;
                    ld_ac  <= 1'b0;
                    ld_pc  <= 1'b0;
                    wr     <= 1'b0;
                    data_e <= 1'b0;
                end
            endcase
        end
    end

endmodule
