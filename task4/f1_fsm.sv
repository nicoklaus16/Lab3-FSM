module f1_fsm #(
    parameter WIDTH = 8
) (
    input logic              clk,
    input logic              rst,
    input logic              en,
    input logic              trigger,
    output logic             cmd_seq,
    output logic             cmd_delay,
    output logic [WIDTH-1:0] data_out
);

    // Define our states
    typedef enum {IDLE, S0, S1, S2, S3, S4, S5, S6, S7, S8} f1st;
    f1st current_state, next_state;

    //state registers
    always_ff @(posedge clk, posedge rst) begin
        if (rst)    current_state <= IDLE;
        else        current_state <= next_state;
    end

    //next state logic
    always_comb begin
            case (current_state)
                IDLE:   if (trigger) next_state = S0;
                        else next_state = IDLE;
                S0: if (en && !trigger) next_state = S1;
                    else next_state = S0;
                S1: if (en) next_state = S2;
                    else next_state = S1;
                S2: if (en) next_state = S3;
                    else next_state = S2;
                S3: if (en) next_state = S4;
                    else next_state = S3;
                S4: if (en) next_state = S5;
                    else next_state = S4;
                S5: if (en) next_state = S6;
                    else next_state = S5;
                S6: if (en) next_state = S7;
                    else next_state = S6;
                S7: if (en) next_state = S8;
                    else next_state = S7;
                S8: if (en) next_state = IDLE;
                    else next_state = S8;
                default: next_state = S0;
            endcase
    end

    //output logic
    always_comb begin
        case (current_state)
            IDLE: begin   data_out = 8'b0;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S0: begin data_out = 8'b0;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S1: begin data_out = 8'b1;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S2: begin data_out = 8'b11;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S3: begin data_out = 8'b111;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S4: begin data_out = 8'b1111;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S5: begin data_out = 8'b11111;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S6: begin data_out = 8'b111111;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S7: begin data_out = 8'b1111111;
                    cmd_delay = 1'b0;
                    cmd_seq = 1'b1;
            end
            S8: begin data_out = 8'b11111111;
                cmd_delay = 1'b1;
                cmd_seq = 1'b0;
            end
            default: begin    data_out = 8'b0;
                        cmd_delay = 1'b0;
                        cmd_seq = 1'b0;
            end
        endcase
    end

endmodule
