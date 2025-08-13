# AGENTS.md - Verilog Traffic Light

## Commands
- `make` - Compile + run simulation
- `make run` - Run simulation only  
- `make view` - View GTKWave
- `make clean` - Clean files
- `iverilog -o traffic_light.vvp traffic_light.v traffic_light_tb.v && vvp traffic_light.vvp` - Single test
- `apio sim` - Run simulation with apio
- `apio build` - Build with apio
- `apio upload` - Upload to TinyFPGA-B2

## Style
- **Modules**: lowercase_underscore
- **Parameters**: UPPERCASE_UNDERSCORE
- **States**: S_STATE_NAME (UPPERCASE)
- **Signals**: lowercase_underscore
- **Comments**: `//` inline, blocks for headers
- **Indent**: 4 spaces
- **Logic**: separate combinational (`@(*)`) and sequential (`posedge clk`)
- **Testbench**: `uut` instance, `defparam` for params