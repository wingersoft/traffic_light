// Testbench for the traffic_light module

`timescale 1ns / 1ps

module traffic_light_tb;

    // Inputs
    reg clk;

    // Outputs
    wire red1, yellow1, green1;
    wire red2, yellow2, green2;

    // Instantiate the module under test (UUT)
    traffic_light uut (
        .clk(clk),
        .red1(red1),
        .yellow1(yellow1),
        .green1(green1),
        .red2(red2),
        .yellow2(yellow2),
        .green2(green2)
    );

    // Override parameters for simulation
    defparam uut.GREEN_CYCLES = 10;
    defparam uut.YELLOW_CYCLES = 5;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock (20 ns period)
    end

    // Simulation control and monitoring
    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, uut);

        // Monitor the outputs
        $monitor("Time = %0t, Light 1: R=%b Y=%b G=%b, Light 2: R=%b Y=%b G=%b",
                 $time, red1, yellow1, green1, red2, yellow2, green2);

        // Run for a certain number of cycles and then stop
        #1000 $finish;
    end

endmodule