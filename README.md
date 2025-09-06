# Verilog Traffic Light Controller

A comprehensive traffic light controller for two-way intersections, implemented in Verilog HDL. This project demonstrates advanced digital design concepts including finite state machines, precise timing control, and safety-critical system design.

## Overview

This project implements a reliable traffic light controller that manages state transitions and timing for two traffic lights at an intersection. The controller ensures safe and efficient traffic flow through carefully designed state transitions and includes multiple safety features to prevent accidents during light changes.

### Key Features

- **Finite State Machine**: 5-state FSM with one-hot encoding for reliability
- **Safety First**: Both-red state during all transitions to prevent accidents
- **Precise Timing**: 32-bit counter with 16MHz clock for accurate state durations
- **Direction Tracking**: Intelligent state management remembers transition history
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
- **Encoding**: 4-bit one-hot state representation
- **Outputs**: 6 control signals (3 per traffic light)
- **Initialization**: Starts in `S_RED1_GREEN2` state

## I/O Signals

### Inputs
- `clk`: 16 MHz system clock

### Outputs
**Traffic Light 1:**
- `red1`, `yellow1`, `green1`: Light control signals (active high)

**Traffic Light 2:**
- `red2`, `yellow2`, `green2`: Light control signals (active high)

## Prerequisites

- **Icarus Verilog** (iverilog) - Verilog compiler and simulator
- **GTKWave** - Waveform viewer for signal analysis
- **GNU Make** - Build automation
- **Apio** (optional) - FPGA development toolchain

## Usage

### Quick Start

```bash
# Compile and run simulation
make

# View waveforms
make view

# Clean generated files
make clean
```

### Detailed Workflow

1. **Simulation**:
   ```bash
   make          # Compile and run
   make run      # Run only (after compilation)
   ```

2. **Waveform Analysis**:
   ```bash
   make view     # Open GTKWave with saved configuration
   ```

3. **Single Test**:
   ```bash
   iverilog -o traffic_light.vvp traffic_light.v traffic_light_tb.v
   vvp traffic_light.vvp
   ```

4. **FPGA Deployment** (with Apio):
   ```bash
   apio sim      # Run simulation
   apio build    # Synthesize for FPGA
   apio upload   # Program TinyFPGA-B2
   ```

## Project Structure

```
.
├── traffic_light.v           # Main FSM controller module
├── traffic_light_tb.v        # Comprehensive testbench
├── traffic_light_tb.gtkw     # GTKWave configuration
├── Makefile                  # Build automation
├── README.md                 # This file
├── AGENTS.md                 # Development guidelines
└── .kilocode/
    └── rules/
        └── memory-bank/      # Project documentation
            ├── brief.md      # Project overview
            ├── product.md    # Purpose and goals
            ├── context.md    # Current status
            ├── architecture.md # Technical details
            └── tech.md       # Development setup
```

## Testbench

The testbench (`traffic_light_tb.v`) provides:
- 16 MHz clock generation
- Automated state transition verification
- Light output monitoring
- Timing validation
- VCD file generation for waveform analysis

### Running Tests

```bash
make                    # Full simulation with verification
make view              # Analyze waveforms in GTKWave
```

## Development

### Coding Standards

- **Modules**: `lowercase_underscore` naming
- **Parameters**: `UPPERCASE_UNDERSCORE` constants
- **States**: `S_STATE_NAME` format
- **Signals**: `lowercase_underscore`
- **Logic**: Separate combinational (`@*`) and sequential (`posedge clk`) blocks

### Build System

The Makefile provides:
- Automated compilation
- Simulation execution
- Waveform generation
- Cleanup operations
- Dependency management

## Documentation

Comprehensive project documentation is available in the Memory Bank (`.kilocode/rules/memory-bank/`):

- **brief.md**: Project overview and specifications
- **product.md**: Purpose, problems solved, and goals
- **context.md**: Current development status
- **architecture.md**: Technical architecture details
- **tech.md**: Development setup and tools

## Contributing

1. Follow the established coding standards
2. Add tests for new features
3. Update documentation as needed
4. Ensure all simulations pass

## License

This project is open source and available under standard terms.

---

**Note**: This implementation is designed for educational and demonstration purposes. For real-world deployment, additional safety certifications and testing would be required.