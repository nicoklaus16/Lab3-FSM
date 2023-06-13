module f1_fsm #(
    parameter WIDTH = 8
) (
    input logic              clk,
    input logic              rst,
    input logic              en,
    output logic [WIDTH-1:0] data_out
);

    // Define our states
    typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} f1st;
    f1st current_state, next_state;

    //state registers
    always_ff @(posedge clk, posedge rst) begin
        if (rst)    current_state <= S0;
        else        current_state <= next_state;
    end

    always_comb begin
            case (current_state)
                S0: if (en) next_state = S1;
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
                S8: if (en) next_state = S0;
                    else next_state = S8;
                default: next_state = S0;
            endcase
    end
    always_comb begin
        case (current_state)
            S0: data_out = 8'b0;
            S1: data_out = 8'b1;
            S2: data_out = 8'b11;
            S3: data_out = 8'b111;
            S4: data_out = 8'b1111;
            S5: data_out = 8'b11111;
            S6: data_out = 8'b111111;
            S7: data_out = 8'b1111111;
            S8: data_out = 8'b11111111;
            default data_out = 8'b0;
        endcase
    end

endmodule
