#include "Vlfsr7.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int simcyc;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vlfsr7* top = new Vlfsr7;
    //init trace dump
    Verilated::traceEverOn (true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("lfsr7.vcd");

    // initialize Vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 3: PRBS");

    vbdSetMode(1);

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->en = 0;

    //run simulation for 150 clock cycles
    for (simcyc=0; simcyc<1000000; simcyc++){

        //dump variables into VCD file and toggle clock
        for (clk=0; clk<2; clk++) {
            tfp->dump (2*simcyc+clk);
            top->clk = !top->clk;
            top->eval ();
        }

        // Display the 4-bit value on the 7-segment displays
        vbdHex(2, (top->data_out >> 4) & 0xF);
        vbdHex(1, top->data_out & 0xF);

        // Display the 4-bit value on the neopixel strip
        vbdBar(top->data_out & 0xFF);

        vbdCycle(simcyc);

        top->rst = (simcyc<2);
        top->en = vbdFlag();
        if (Verilated::gotFinish() || vbdGetkey()=='q')  exit(0);
    }
    vbdClose();
    tfp->close();
    exit(0);
}
