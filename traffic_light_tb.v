
// Testbench for the traffic_light module

`timescale 1ns / 1ps

module traffic_light_tb;

    // Inputs
    reg clk;

    // Outputs
    wire red;
    wire yellow;
    wire green;

    // Instantiate the module under test (UUT)
    traffic_light uut (
        .clk(clk),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Override parameters for simulation
    defparam uut.GREEN_CYCLES = 10;
    defparam uut.YELLOW_CYCLES = 5;
    defparam uut.RED_CYCLES = 15;


    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock (20 ns period)
    end

    // Simulation control and monitoring
    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars();

        // Monitor the outputs
        $monitor("Time = %0t, red = %b, yellow = %b, green = %b", $time, red, yellow, green);

        // Run for a certain number of cycles and then stop
        #1000 $finish;
    end

endmodule
