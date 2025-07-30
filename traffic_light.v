
// Verilog module for a traffic light controller
// Clock frequency: 50 MHz

module traffic_light (
    input wire clk,          // 50 MHz clock input
    output reg red,          // Red light output
    output reg yellow,       // Yellow light output
    output reg green         // Green light output
);

    // Parameters for state definitions
    parameter S_GREEN  = 2'b00;
    parameter S_YELLOW = 2'b01;
    parameter S_RED    = 2'b10;

    // Parameters for time durations in clock cycles
    // Clock is 50 MHz, so 1 cycle = 20 ns
    // Green light: 10 seconds = 10 / (20 * 10^-9) = 500,000,000 cycles
    // Yellow light: 5 seconds = 5 / (20 * 10^-9)  = 250,000,000 cycles
    // Red light: 30 seconds = 30 / (20 * 10^-9)   = 1,500,000,000 cycles
    parameter GREEN_CYCLES  = 32'd500_000_000;
    parameter YELLOW_CYCLES = 32'd250_000_000;
    parameter RED_CYCLES    = 32'd1_500_000_000;

    // State register
    reg [1:0] state, next_state;

    // Counter to time the states
    reg [31:0] counter;

    // Initialize state and outputs
    initial begin
        state  = S_RED;
        red    = 1'b1;
        yellow = 1'b0;
        green  = 1'b0;
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
            S_GREEN: begin
                if (counter >= GREEN_CYCLES - 1) begin
                    next_state = S_YELLOW;
                end
            end
            S_YELLOW: begin
                if (counter >= YELLOW_CYCLES - 1) begin
                    next_state = S_RED;
                end
            end
            S_RED: begin
                if (counter >= RED_CYCLES - 1) begin
                    next_state = S_GREEN;
                end
            end
            default: begin
                next_state = S_RED;
            end
        endcase
    end

    // Output logic based on the current state
    always @(posedge clk) begin
        case (state)
            S_GREEN: begin
                green  <= 1'b1;
                yellow <= 1'b0;
                red    <= 1'b0;
            end
            S_YELLOW: begin
                green  <= 1'b0;
                yellow <= 1'b1;
                red    <= 1'b0;
            end
            S_RED: begin
                green  <= 1'b0;
                yellow <= 1'b0;
                red    <= 1'b1;
            end
            default: begin
                green  <= 1'b0;
                yellow <= 1'b0;
                red    <= 1'b1;
            end
        endcase
    end

endmodule
