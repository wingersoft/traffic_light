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

    // Override parameters for faster simulation
    defparam uut.GREEN_CYCLES = 30;
    defparam uut.YELLOW_CYCLES = 5;
    defparam uut.RED_RED_CYCLES = 2;

    // Clock generation
    initial begin
        clk = 0;
        forever #31.25 clk = ~clk; // 16 MHz clock (62.5 ns period)
    end

    // Task to check light states
    task check_lights;
        input expected_red1, expected_yellow1, expected_green1;
        input expected_red2, expected_yellow2, expected_green2;
        begin
            if (red1 !== expected_red1 || yellow1 !== expected_yellow1 || green1 !== expected_green1 ||
                red2 !== expected_red2 || yellow2 !== expected_yellow2 || green2 !== expected_green2) begin
                $display("ERROR at time %0t: Expected Light1 R=%b Y=%b G=%b, Light2 R=%b Y=%b G=%b",
                         $time, expected_red1, expected_yellow1, expected_green1,
                         expected_red2, expected_yellow2, expected_green2);
                $display("Actual: Light1 R=%b Y=%b G=%b, Light2 R=%b Y=%b G=%b",
                         red1, yellow1, green1, red2, yellow2, green2);
            end else begin
                $display("PASS at time %0t: Lights match expected state", $time);
            end
        end
    endtask

    // Simulation control and monitoring
    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, traffic_light_tb);

        // Initial state check (should be Red1, Green2)
        #10 check_lights(1, 0, 0, 0, 0, 1);

        // Wait for green cycles (30 cycles ~1875ns) and check Red1 Yellow2
        #1900 check_lights(1, 0, 0, 0, 1, 0);

        // Wait for yellow cycles (5 cycles ~312ns) and check Red1 Red2
        #320 check_lights(1, 0, 0, 1, 0, 0);

        // Wait for red-red cycles (2 cycles ~125ns) and check Green1 Red2
        #130 check_lights(0, 0, 1, 1, 0, 0);

        // Wait for green cycles and check Yellow1 Red2
        #1900 check_lights(0, 1, 0, 1, 0, 0);

        // Wait for yellow cycles and check Red1 Red2
        #320 check_lights(1, 0, 0, 1, 0, 0);

        // Wait for red-red cycles (2 cycles ~125ns) and check Red1 Green2
        #130 check_lights(1, 0, 0, 0, 0, 1);

        // Run for extended time and then stop
        #5000 $finish;
    end

endmodule
