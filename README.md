# Verilog Traffic Light Controller

This repository contains a traffic light controller for a two-way intersection, written in Verilog.

## Description

The `traffic_light.v` module implements a finite state machine that controls two traffic lights. It cycles through the states to ensure that one light is green while the other is red, with appropriate yellow light transitions.

### I/O Signals

*   **Input:** `clk` - A 16 MHz clock signal.
*   **Outputs for Traffic Light 1:**
    *   `red1`: Controls the red light (active high).
    *   `yellow1`: Controls the yellow light (active high).
    *   `green1`: Controls the green light (active high).
*   **Outputs for Traffic Light 2:**
    *   `red2`: Controls the red light (active high).
    *   `yellow2`: Controls the yellow light (active high).
    *   `green2`: Controls the green light (active high).

### States and Timing

The state machine has four states that control the lights for the two-way intersection. The green light duration is 30 seconds and the yellow light duration is 5 seconds. The design uses a **one-hot encoded state machine** for reliable state transitions.

| State            | Traffic Light 1 | Traffic Light 2 | Duration   | Encoding   |
|------------------|-----------------|-----------------|------------|------------|
| `S_GREEN1_RED2`  | Green           | Red             | 30 seconds | 4'b0001    |
| `S_YELLOW1_RED2` | Yellow          | Red             | 5 seconds  | 4'b0010    |
| `S_RED1_GREEN2`  | Red             | Green           | 30 seconds | 4'b0100    |
| `S_RED1_YELLOW2` | Red             | Yellow          | 5 seconds  | 4'b1000    |

A 32-bit counter is used to manage the timing for each state, based on the 16 MHz input clock. The controller initializes to the `S_RED1_GREEN2` state.

## Prerequisites

- Icarus Verilog (iverilog) for simulation
- GTKWave for waveform viewing
- Make for build automation
- Apio (optional, for FPGA development)

## Usage

### Simulation

To compile and run the simulation:
```bash
make
```

To run simulation only (after compilation):
```bash
make run
```

To view waveforms in GTKWave:
```bash
make view
```

### Single Test

Run a single simulation test:
```bash
iverilog -o traffic_light.vvp traffic_light.v traffic_light_tb.v && vvp traffic_light.vvp
```

### Apio Commands

For FPGA development with Apio:
```bash
apio sim    # Run simulation
apio build  # Build project
apio upload # Upload to TinyFPGA-B2
```

### Cleanup

Clean generated files:
```bash
make clean
```

## Testbench

The testbench (`traffic_light_tb.v`) instantiates the traffic light controller and provides a clock signal. It monitors the state transitions and light outputs to verify correct operation.

## Project Structure

- `traffic_light.v`: Main traffic light controller module
- `traffic_light_tb.v`: Testbench for simulation
- `traffic_light_tb.gtkw`: GTKWave configuration file
- `Makefile`: Build automation
- `AGENTS.md`: Development guidelines and commands