//-----------------------------------------------------------------------------
//
// Title       : traffic_light
// Design      : traffic_light
// Author      : 
//
//-----------------------------------------------------------------------------
//
// File        : traffic_light.v
// Generated   : 
// From        : 
// By          : 
//
//-----------------------------------------------------------------------------
//
// Description : Verilog module for a two-way traffic light controller.
//               This module manages the state transitions and timings for
//               two traffic lights at an intersection. The clock frequency
//               is assumed to be 50 MHz.
//
//-----------------------------------------------------------------------------

module traffic_light (
    // Inputs
    input wire clk,           // 50 MHz clock input

    // Outputs for Traffic Light 1
    output reg red1,          // Red light output
    output reg yellow1,       // Yellow light output
    output reg green1,        // Green light output

    // Outputs for Traffic Light 2
    output reg red2,          // Red light output
    output reg yellow2,       // Yellow light output
    output reg green2         // Green light output
);

    // State parameters define the four possible states of the traffic light system.
    // Each state represents a specific combination of lights for the two intersections.
    parameter S_GREEN1_RED2    = 2'b00; // Light 1 is Green, Light 2 is Red
    parameter S_YELLOW1_RED2   = 2'b01; // Light 1 is Yellow, Light 2 is Red
    parameter S_RED1_GREEN2    = 2'b10; // Light 1 is Red, Light 2 is Green
    parameter S_RED1_YELLOW2   = 2'b11; // Light 1 is Red, Light 2 is Yellow

    // Time duration parameters in clock cycles.
    // The system clock is 50 MHz, which means one clock cycle is 20 ns.
    // Green light duration: 30 seconds = 30 / (20 * 10^-9) = 1_500_000_000 cycles
    // Yellow light duration: 5 seconds = 5 / (20 * 10^-9)  = 250,000,000 cycles
    parameter GREEN_CYCLES  = 32'd1_500_000_000;
    parameter YELLOW_CYCLES = 32'd250_000_000;

    // State registers to hold the current and next state of the state machine.
    reg [1:0] state, next_state;

    // Counter to time the duration of each state.
    reg [31:0] counter;

    // Initialization block to set the initial state and outputs at the beginning of the simulation.
    initial begin
        // Start with Light 1 being Red and Light 2 being Green.
        state   = S_RED1_GREEN2;
        red1    = 1'b1;
        yellow1 = 1'b0;
        green1  = 1'b0;
        red2    = 1'b0;
        yellow2 = 1'b0;
        green2  = 1'b1;
        // Initialize the counter to zero.
        counter = 32'd0;
    end

    // This block handles state transitions and the master counter.
    // It is synchronized with the positive edge of the clock.
    always @(posedge clk) begin
        // On each clock cycle, the current state is updated with the next state.
        state <= next_state;
        
        // If the state changes, reset the counter. Otherwise, increment it.
        if (state != next_state) begin
            counter <= 32'd0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Combinational logic to determine the next state based on the current state and the counter.
    always @(*) begin
        // By default, the next state is the same as the current state.
        next_state = state; 
        case (state)
            // If Light 1 is Green and its time is up, switch to Yellow.
            S_GREEN1_RED2: begin
                if (counter >= GREEN_CYCLES - 1) begin
                    next_state = S_YELLOW1_RED2;
                end
            end
            // If Light 1 is Yellow and its time is up, switch to Light 2 being Green.
            S_YELLOW1_RED2: begin
                if (counter >= YELLOW_CYCLES - 1) begin
                    next_state = S_RED1_GREEN2;
                end
            end
            // If Light 2 is Green and its time is up, switch to Yellow.
            S_RED1_GREEN2: begin
                if (counter >= GREEN_CYCLES - 1) begin
                    next_state = S_RED1_YELLOW2;
                end
            end
            // If Light 2 is Yellow and its time is up, switch back to Light 1 being Green.
            S_RED1_YELLOW2: begin
                if (counter >= YELLOW_CYCLES - 1) begin
                    next_state = S_GREEN1_RED2;
                end
            end
            // Default case to prevent latches, though all states are covered.
            default: begin
                next_state = S_GREEN1_RED2;
            end
        endcase
    end

    // This block updates the output signals (the lights) based on the current state.
    // It is synchronized with the positive edge of the clock to ensure stable outputs.
    always @(posedge clk) begin
        case (state)
            // State: Light 1 is Green, Light 2 is Red
            S_GREEN1_RED2: begin
                green1  <= 1'b1;
                yellow1 <= 1'b0;
                red1    <= 1'b0;
                green2  <= 1'b0;
                yellow2 <= 1'b0;
                red2    <= 1'b1;
            end
            // State: Light 1 is Yellow, Light 2 is Red
            S_YELLOW1_RED2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b1;
                red1    <= 1'b0;
                green2  <= 1'b0;
                yellow2 <= 1'b0;
                red2    <= 1'b1;
            end
            // State: Light 1 is Red, Light 2 is Green
            S_RED1_GREEN2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b0;
                red1    <= 1'b1;
                green2  <= 1'b1;
                yellow2 <= 1'b0;
                red2    <= 1'b0;
            end
            // State: Light 1 is Red, Light 2 is Yellow
            S_RED1_YELLOW2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b0;
                red1    <= 1'b1;
                green2  <= 1'b0;
                yellow2 <= 1'b1;
                red2    <= 1'b0;
            end
            // Default case to ensure all lights are in a safe state (e.g., all red)
            // in case of an undefined state.
            default: begin
                green1  <= 1'b0;
                yellow1 <= 1'b0;
                red1    <= 1'b1;
                green2  <= 1'b0;
                yellow2 <= 1'b0;
                red2    <= 1'b1;
            end
        endcase
    end

endmodule
