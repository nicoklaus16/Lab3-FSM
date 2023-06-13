module lfsr7 (
    input logic         clk,
    input logic         rst,
    input logic         en,
    output logic [7:1]  data_out
);

logic [7:1] sreg;

always_ff @(posedge clk, posedge rst) begin
    if (rst)
        sreg <= 7'b1;
    else
        if (en == 7'b1)
            sreg <= {sreg[6:1], sreg[7] ^ sreg[3]};
        else
            sreg <= sreg;
end

assign data_out = sreg;
endmodule
