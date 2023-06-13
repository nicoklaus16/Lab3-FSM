#include "Vsinegen.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int simcyc;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vsinegen* top = new Vsinegen;
    //init trace dump
    Verilated::traceEverOn (true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("sinegen.vcd");

    // initialize Vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 2: SineGen");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->en = 0;
    top->incr = 1;

    //run simulation for 150 clock cycles
    for (simcyc=0; simcyc<1000000; simcyc++){

        //dump variables into VCD file and toggle clock
        for (clk=0; clk<2; clk++) {
            tfp->dump (2*simcyc+clk);
            top->clk = !top->clk;
            top->eval ();
        }
        // Get Vbuddy parameter value and assign it to increment
        top->incr = vbdValue();
        //End of Get Vbuddy parameter value and assign it to increment

        // Plot sine
        vbdPlot(int(top->dout), 0, 255);
        // End of plot sine

        vbdCycle(simcyc);

        top->rst = (simcyc<10);
        top->en = (simcyc>20);
        if (Verilated::gotFinish() || vbdGetkey()=='q')  exit(0);
    }
    vbdClose();
    tfp->close();
    exit(0);
}
