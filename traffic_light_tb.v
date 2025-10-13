// Testbench for the traffic_light module

`timescale 1ns / 1ps

module traffic_light_tb;

    // Inputs
    reg clk;
    reg mode_switch;

    // Outputs
    wire red1, yellow1, green1;
    wire red2, yellow2, green2;

    // Instantiate the module under test (UUT)
    traffic_light #(
        .GREEN_CYCLES(30),
        .YELLOW_CYCLES(5),
        .RED_RED_CYCLES(2),
        .FLASH_HALF_CYCLES(5) // Slower flash for simulation visibility (5 cycles = ~312.5 ns half-period)
    ) uut (
        .clk(clk),
        .mode_switch(mode_switch),
        .red1(red1),
        .yellow1(yellow1),
        .green1(green1),
        .red2(red2),
        .yellow2(yellow2),
        .green2(green2)
    );

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

    // Task to wait for a specific state
    task wait_for_state;
        input [4:0] expected_state;
        begin
            while (uut.state !== expected_state) begin
                @(posedge clk);
            end
        end
    endtask

    // Simulation control and monitoring
    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, traffic_light_tb);

        // Initialize mode switch
        mode_switch = 1'b1;

        // Initial state check
        wait_for_state(5'b01000); // S_RED1_GREEN2
        #1; check_lights(1, 0, 0, 0, 0, 1);

        // Wait for S_RED1_YELLOW2
        wait_for_state(5'b10000); // S_RED1_YELLOW2
        #1; check_lights(1, 0, 0, 0, 1, 0);

        // Wait for S_RED1_RED2
        wait_for_state(5'b00100); // S_RED1_RED2
        #1; check_lights(1, 0, 0, 1, 0, 0);

        // Wait for S_GREEN1_RED2
        wait_for_state(5'b00001); // S_GREEN1_RED2
        #1; check_lights(0, 0, 1, 1, 0, 0);

        // Wait for S_YELLOW1_RED2
        wait_for_state(5'b00010); // S_YELLOW1_RED2
        #1; check_lights(0, 1, 0, 1, 0, 0);

        // Wait for S_RED1_RED2
        wait_for_state(5'b00100); // S_RED1_RED2
        #1; check_lights(1, 0, 0, 1, 0, 0);

        // Wait for S_RED1_GREEN2
        wait_for_state(5'b01000); // S_RED1_GREEN2
        #1; check_lights(1, 0, 0, 0, 0, 1);

        #1000;
        $finish;
    end

endmodule