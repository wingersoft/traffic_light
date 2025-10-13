# Verilog Traffic Light Controller

A comprehensive traffic light controller for two-way intersections, implemented in Verilog HDL. This project demonstrates advanced digital design concepts including finite state machines, precise timing control, and safety-critical system design.

## Overview

This project implements a reliable traffic light controller that manages state transitions and timing for two traffic lights at an intersection. The controller ensures safe and efficient traffic flow through carefully designed state transitions and includes multiple safety features to prevent accidents during light changes.

The system also includes a maintenance mode with yellow flash functionality, activated via a mode switch input.

### Key Features

- **Finite State Machine**: 5-state FSM with one-hot encoding for reliability
- **Safety First**: Both-red state during all transitions to prevent accidents
- **Precise Timing**: 32-bit counter with 16MHz clock for accurate state durations
- **Direction Tracking**: Intelligent state management remembers transition history
- **Maintenance Mode**: Yellow flash mode for maintenance situations
- **FPGA Ready**: Compatible with TinyFPGA-B2 for hardware deployment
- **Comprehensive Testing**: Full testbench with automated verification

### Educational Value

This project serves as an excellent example of:
- Digital system design and HDL programming
- Finite state machine implementation
- Synchronous design principles
- Safety-critical system development
- Hardware-software co-design

## Architecture

### State Machine Design

The controller uses a one-hot encoded finite state machine with five distinct states:

| State | Light 1 | Light 2 | Duration | Description |
|-------|---------|---------|----------|-------------|
| `S_GREEN1_RED2` | Green | Red | 30s | Primary green phase |
| `S_YELLOW1_RED2` | Yellow | Red | 5s | Transition warning |
| `S_RED1_RED2` | Red | Red | 2s | **Safety transition** |
| `S_RED1_GREEN2` | Red | Green | 30s | Secondary green phase |
| `S_RED1_YELLOW2` | Red | Yellow | 5s | Transition warning |

### Safety Features

- **Both-Red Transitions**: All state changes pass through a both-red state to ensure no conflicting green lights
- **Direction Flag**: Remembers which yellow state led to the both-red state for correct transition back
- **One-Hot Encoding**: Ensures only one state is active at a time, preventing race conditions
- **Synchronous Design**: All state changes triggered by clock edges for predictable behavior

### Technical Implementation

- **Clock**: 16 MHz input frequency (62.5 ns cycle time)
- **Timing**: 32-bit counter supports durations up to ~268 seconds
- **Encoding**: 5-bit one-hot state representation
- **Outputs**: 6 control signals (3 per traffic light)
- **Inputs**: Clock and mode switch for maintenance mode
- **Initialization**: Starts in `S_RED1_GREEN2` state

## I/O Signals

### Inputs
- `clk`: 16 MHz system clock
- `mode_switch`: FPGA pin switch (high for normal operation, low for flash mode)

### Outputs
**Traffic Light 1:**
- `red1`, `yellow1`, `green1`: Light control signals (active high)

**Traffic Light 2:**
- `red2`, `yellow2`, `green2`: Light control signals (active high)

### Maintenance Mode

When the `mode_switch` input is low, the system enters maintenance mode where both yellow lights flash at a 1Hz rate (1 second on, 1 second off). When the mode switch returns to high, the system resumes normal operation starting from the `S_RED1_GREEN2` state.

## Usage

This project is intended for use with the Apio FPGA development toolchain.

```bash
# Install apio
pip install apio

# Run simulation
apio sim

# Synthesize and upload to FPGA
apio build
apio upload
```

## License

This project is open source and available under standard terms.

---
**Note**: This implementation is designed for educational and demonstration purposes. For real-world deployment, additional safety certifications and testing would be required.