# Makefile for simulating the traffic light module

# Compiler and simulator
VERILOG = iverilog
SIMULATOR = vvp
WAVEFORM_VIEWER = gtkwave

# Source files
SOURCES = traffic_light.v traffic_light_tb.v

# Output files
TARGET = traffic_light.vvp
WAVEFORM = traffic_light_tb.gtkw

# Default target
all: $(TARGET)
	$(SIMULATOR) $(TARGET)

# Rule to compile the Verilog code
$(TARGET): $(SOURCES)
	$(VERILOG) -o $(TARGET) $(SOURCES)

# Target to run the simulation
run: all

# Target to view the waveform
view: $(WAVEFORM)
	$(WAVEFORM_VIEWER) $(WAVEFORM)

# The simulation generates the VCD file, so this is a dependency
$(WAVEFORM): all

# Target to clean up generated files
clean:
	rm -f $(TARGET)

.PHONY: all run view clean
