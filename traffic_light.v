// Verilog module for a traffic light controller
// Clock frequency: 50 MHz

module traffic_light (
    input wire clk,           // 50 MHz clock input
    output reg red1,          // Red light output for traffic light 1
    output reg yellow1,       // Yellow light output for traffic light 1
    output reg green1,        // Green light output for traffic light 1
    output reg red2,          // Red light output for traffic light 2
    output reg yellow2,       // Yellow light output for traffic light 2
    output reg green2         // Green light output for traffic light 2
);

    // Parameters for state definitions
    parameter S_GREEN1_RED2    = 2'b00;
    parameter S_YELLOW1_RED2   = 2'b01;
    parameter S_RED1_GREEN2    = 2'b10;
    parameter S_RED1_YELLOW2   = 2'b11;

    // Parameters for time durations in clock cycles
    // Clock is 50 MHz, so 1 cycle = 20 ns
    // Green light: 10 seconds = 10 / (20 * 10^-9) = 500,000,000 cycles
    // Yellow light: 5 seconds = 5 / (20 * 10^-9)  = 250,000,000 cycles

    parameter GREEN_CYCLES  = 32'd500_000_000;
    parameter YELLOW_CYCLES = 32'd250_000_000;

    // State register
    reg [1:0] state, next_state;

    // Counter to time the states
    reg [31:0] counter;

    // Initialize state and outputs
    initial begin
        state   = S_RED1_GREEN2;
        red1    = 1'b1;
        yellow1 = 1'b0;
        green1  = 1'b0;
        red2    = 1'b0;
        yellow2 = 1'b0;
        green2  = 1'b1;
        counter = 32'd0;
    end

    // State transition and counter logic
    always @(posedge clk) begin
        state <= next_state;
        // Increment counter or reset it on state change
        if (state != next_state) begin
            counter <= 32'd0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // Default to stay in the current state
        case (state)
            S_GREEN1_RED2: begin
                if (counter >= GREEN_CYCLES - 1) begin
                    next_state = S_YELLOW1_RED2;
                end
            end
            S_YELLOW1_RED2: begin
                if (counter >= YELLOW_CYCLES - 1) begin
                    next_state = S_RED1_GREEN2;
                end
            end
            S_RED1_GREEN2: begin
                if (counter >= GREEN_CYCLES - 1) begin
                    next_state = S_RED1_YELLOW2;
                end
            end
            S_RED1_YELLOW2: begin
                if (counter >= YELLOW_CYCLES - 1) begin
                    next_state = S_GREEN1_RED2;
                end
            end
            default: begin
                next_state = S_GREEN1_RED2;
            end
        endcase
    end

    // Output logic based on the current state
    always @(posedge clk) begin
        case (state)
            S_GREEN1_RED2: begin
                green1  <= 1'b1;
                yellow1 <= 1'b0;
                red1    <= 1'b0;
                green2  <= 1'b0;
                yellow2 <= 1'b0;
                red2    <= 1'b1;
            end
            S_YELLOW1_RED2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b1;
                red1    <= 1'b0;
                green2  <= 1'b0;
                yellow2 <= 1'b0;
                red2    <= 1'b1;
            end
            S_RED1_GREEN2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b0;
                red1    <= 1'b1;
                green2  <= 1'b1;
                yellow2 <= 1'b0;
                red2    <= 1'b0;
            end
            S_RED1_YELLOW2: begin
                green1  <= 1'b0;
                yellow1 <= 1'b0;
                red1    <= 1'b1;
                green2  <= 1'b0;
                yellow2 <= 1'b1;
                red2    <= 1'b0;
            end
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