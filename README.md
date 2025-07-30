# Verilog Traffic Light Controller

This repository contains a simple traffic light controller written in Verilog.

## Description

The `traffic_light.v` module implements a finite state machine that cycles through a standard green-yellow-red light sequence.

### I/O Signals

*   **Input:** `clk` - A 50 MHz clock signal.
*   **Outputs:**
    *   `red`: Controls the red light (active high).
    *   `yellow`: Controls the yellow light (active high).
    *   `green`: Controls the green light (active high).

### States and Timing

The state machine has three states with the following durations:

| State    | Light  | Duration   |
|----------|--------|------------|
| `S_GREEN`| Green  | 10 seconds |
| `S_YELLOW`| Yellow | 5 seconds  |
| `S_RED`  | Red    | 30 seconds |

A 32-bit counter is used to manage the timing for each state, based on the 50 MHz input clock. The controller initializes to the `S_RED` state.