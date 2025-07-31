# Verilog Traffic Light Controller

This repository contains a traffic light controller for a two-way intersection, written in Verilog.

## Description

The `traffic_light.v` module implements a finite state machine that controls two traffic lights. It cycles through the states to ensure that one light is green while the other is red, with appropriate yellow light transitions.

### I/O Signals

*   **Input:** `clk` - A 50 MHz clock signal.
*   **Outputs for Traffic Light 1:**
    *   `red1`: Controls the red light (active high).
    *   `yellow1`: Controls the yellow light (active high).
    *   `green1`: Controls the green light (active high).
*   **Outputs for Traffic Light 2:**
    *   `red2`: Controls the red light (active high).
    *   `yellow2`: Controls the yellow light (active high).
    *   `green2`: Controls the green light (active high).

### States and Timing

The state machine has four states that control the lights for the two-way intersection. The green light duration is 10 seconds and the yellow light duration is 5 seconds.

| State            | Traffic Light 1 | Traffic Light 2 | Duration   |
|------------------|-----------------|-----------------|------------|
| `S_GREEN1_RED2`  | Green           | Red             | 10 seconds |
| `S_YELLOW1_RED2` | Yellow          | Red             | 5 seconds  |
| `S_RED1_GREEN2`  | Red             | Green           | 10 seconds |
| `S_RED1_YELLOW2` | Red             | Yellow          | 5 seconds  |

A 32-bit counter is used to manage the timing for each state, based on the 50 MHz input clock. The controller initializes to the `S_RED1_GREEN2` state.