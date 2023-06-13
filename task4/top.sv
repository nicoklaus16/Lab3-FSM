module top#(
        parameter WIDTH = 8
    )(
    input logic                 clk,
    input logic                 rst,
    input logic                 trigger,
    output logic                reacflag,
    output logic [WIDTH-1:0]    data_out
);

    logic [WIDTH-1:0]   f1lfsrout;
    logic               f1delayout;
    logic               f1clktickout;
    logic               enable;
    logic               cmd_seq;
    logic               cmd_delay;

    lfsr7 f1lfsr (
            .clk(clk),
            .rst(rst),
            .en(1),
            .data_out(f1lfsrout)
    );

    delay f1delay (
            .clk(clk),
            .rst(rst),
            .trigger(cmd_delay),
            .n (f1lfsrout),
            .time_out (f1delayout)
    );

    clktick f1clktick (
                .clk (clk),
                .rst (rst),
                .en (cmd_seq),
                .N (6'd53),
                .tick (f1clktickout)
    );

    always_comb
        if (cmd_seq)    enable = f1clktickout;
        else            enable = f1delayout;
    
    f1_fsm #(WIDTH) inst_f1_fsm (
            .clk (clk),
            .rst (rst),
            .en (enable),
            .trigger (trigger),
            .cmd_seq (cmd_seq),
            .cmd_delay (cmd_delay),
            .data_out (data_out)
    );

    assign reacflag = f1delayout;
    
endmodule
