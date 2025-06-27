# FIFO Verification Project

A comprehensive SystemVerilog and UVM-based verification environment for a parameterized FIFO (First-In-First-Out) design. 

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
- [Verification Methodology](#verification-methodology)
- [Coverage Analysis](#coverage-analysis)
- [Advanced Features](#advanced-features)
- [Educational Resources](#educational-resources)


## 🎯 Overview

This project implements a complete verification environment for a parameterized FIFO design using SystemVerilog and the Universal Verification Methodology (UVM). The environment includes comprehensive stimulus generation, self-checking capabilities, functional coverage collection, and assertion-based verification.

### Key Highlights
- ✅ **Industry-Standard UVM Methodology**
- ✅ **Comprehensive Functional Coverage**
- ✅ **SystemVerilog Assertions (SVA)**
- ✅ **Self-Checking Testbench**
- ✅ **Parameterized and Configurable Design**

## 🏗️ Project Structure

```
Synchronous-FIFO-UVM-Verification/
├── README.md                    # This file
├── run.do                       # ModelSim/QuestaSim simulation script
├── final_src1.txt              # File list for compilation
│
├── Core Infrastructure/
│   ├── shared_pkg.sv           # Global parameters and utilities
│   ├── FIFO_interface.sv       # SystemVerilog interface
│   ├── FIFO.sv                 # DUT (Device Under Test)
│   └── FIFO_top.sv             # Top-level testbench module
│
├── UVM Verification Components/
│   ├── FIFO_seq_item.sv        # Transaction/sequence item
│   ├── FIFO_driver.sv          # UVM driver
│   ├── FIFO_Monitor.sv         # UVM monitor
│   ├── FIFO_sequencer.sv       # UVM sequencer
│   ├── FIFO_agent.sv           # UVM agent
│   ├── FIFO_env.sv             # UVM environment
│   ├── FIFO_test.sv            # UVM test classes
│   ├── FIFO_config.sv          # Configuration object
│   ├── FIFO_sequence.sv        # Stimulus sequences
│   ├── FIFO_Scoreboard.sv      # Self-checking component
│   └── FIFO_Coverage.sv        # Functional coverage collector
│
├── Assertion-Based Verification/
│   └── FIFO_SVA.sv             # SystemVerilog Assertions
            # Legacy testbench (educational)
```

## ✨ Features

### FIFO Design Features
- **Parameterized Width and Depth**: Configurable data width (default 16-bit) and depth (default 8 entries)
- **Standard FIFO Interface**: Read/write enables, data ports, status flags  
- **Status Flags**: Empty, full, almost_empty, almost_full indicators
- **Error Detection**: Overflow and underflow detection with flags
- **Write Acknowledge**: Confirmation of successful write operations
- **Synchronous Operation**: Single clock domain with active-low reset

### Verification Environment Features
- **Complete UVM Architecture**: All standard UVM components implemented
- **Comprehensive Test Suite**: Multiple test scenarios and configurations
- **Advanced Sequences**: Directed, random, stress, and corner-case testing
- **Self-Checking**: Automatic result verification with detailed reporting
- **Functional Coverage**: Comprehensive coverage collection and analysis
- **Assertion-Based Verification**: SystemVerilog assertions for protocol checking
- **Configurable Environment**: Flexible test configuration and control
- **Debug Support**: Extensive logging and debugging capabilities

## 🔧 Prerequisites

### Software Requirements
- **Simulator**: ModelSim, QuestaSim, VCS, or other SystemVerilog-compatible simulator
- **UVM Library**: UVM 1.2 or later
- **SystemVerilog Support**: IEEE 1800-2017 or compatible

### Knowledge Prerequisites
- Basic understanding of SystemVerilog
- Familiarity with UVM methodology (helpful but not required)
- Basic knowledge of FIFO operation principles

## 🚀 Quick Start

### 1. Clone/Download the Project
```bash
# Navigate to your workspace
cd /path/to/your/workspace
```

### 2. Compile and Run (ModelSim/QuestaSim)
```bash
# Using the provided script
vsim -do run.do

# Or step by step:
vlib work
vlog -f final_src1.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
run -all
```

### 3. Basic Command Line Options
```bash
# Run with specific test
vsim work.top +UVM_TESTNAME=FIFO_basic_test

# Enable VCD dumping
vsim work.top +DUMP_VCD

# Set simulation timeout
vsim work.top +SIM_TIMEOUT=50000

# Adjust clock period (in ns)
vsim work.top +CLOCK_PERIOD=10.0
```

## 📚 Detailed Usage

### Test Selection

The environment includes multiple pre-defined tests:

```systemverilog
// Available test classes:
FIFO_basic_test        // Basic read/write operations
FIFO_stress_test       // High-frequency operations
FIFO_corner_case_test  // Edge cases and boundary conditions
FIFO_error_test        // Error injection and recovery
FIFO_performance_test  // Throughput and latency analysis
```

### Configuration Options

Customize the verification environment through plusargs:

```bash
# Test configuration
+UVM_TESTNAME=<test_name>          # Select specific test
+UVM_VERBOSITY=UVM_HIGH            # Set verbosity level
+FIFO_DEPTH=16                     # Override FIFO depth
+FIFO_WIDTH=32                     # Override data width

# Simulation control
+SIM_TIMEOUT=100000                # Simulation timeout (ns)
+CLOCK_PERIOD=5.0                  # Clock period (ns)
+SEED=12345                        # Random seed

# Debug and analysis
+DUMP_VCD                          # Enable VCD dumping
+ENABLE_COVERAGE                   # Enable coverage collection
+DEBUG_MODE                        # Enhanced debug output
```

### Sequence Usage

Generate specific stimulus patterns:

```systemverilog
// Example: Run write-only sequence
`uvm_do_with(write_seq, {
    num_transactions == 100;
    data_pattern == SEQUENTIAL;
})

// Example: Mixed read/write with constraints
`uvm_do_with(mixed_seq, {
    write_percentage == 70;
    read_percentage == 30;
    burst_mode == 1;
})
```

## 🔬 Verification Methodology

### UVM Architecture

The verification environment follows standard UVM architecture:

```
Test
├── Environment
    ├── Agent
    │   ├── Sequencer  ←→  Driver  ←→  Interface  ←→  DUT
    │   └── Monitor  ←→  Analysis Port
    ├── Scoreboard  ←→  Reference Model
    └── Coverage Collector
```

### Verification Plan

| Feature | Test Type | Coverage Goal |
|---------|-----------|---------------|
| Basic Operations | Directed | 100% |
| FIFO States | Random | 100% |
| Error Conditions | Directed | 100% |
| Performance | Stress | 95% |
| Corner Cases | Directed | 100% |

### Self-Checking Strategy

1. **Reference Model**: Software model predicts expected behavior
2. **Scoreboard**: Compares actual vs. expected results
3. **Assertions**: Real-time protocol checking
4. **Coverage**: Ensures all scenarios tested

## 📊 Coverage Analysis

### Functional Coverage Groups

```systemverilog
// Main coverage areas:
- FIFO Operations (read, write, simultaneous)
- FIFO States (empty, full, almost_empty, almost_full)
- Data Patterns (sequential, random, walking patterns)
- Error Conditions (overflow, underflow)
- Transition Coverage (state changes)
- Cross Coverage (operation × state combinations)
```

### Coverage Commands

```bash
# Generate coverage report
coverage report -detail -file coverage_report.txt

# View coverage in GUI
coverage load coverage.ucdb
```

### Coverage Goals

- **Functional Coverage**: > 95%
- **Code Coverage**: > 90%
- **Assertion Coverage**: 100%
- **FSM Coverage**: 100%

## 🎛️ Advanced Features

### Debug and Analysis

```systemverilog
// Enable debug features
+define+DEBUG_ENABLE
+define+WAVE_DUMP_ENABLE
+define+ASSERTION_REPORT_ENABLE
```

### Performance Analysis

```systemverilog
// Performance monitoring
- Transaction throughput measurement
- Latency analysis
- Resource utilization tracking
- Bottleneck identification
```

### Regression Testing

```bash
# Run regression suite
make regression

# Run specific test category
make stress_tests
make corner_case_tests
make performance_tests
```




### Performance Optimization

```bash
# Optimize simulation speed
vsim -voptargs="+acc=npr" work.top

# Reduce logging for performance
+UVM_VERBOSITY=UVM_LOW
```

## 📈 Extending the Project

### Adding New Tests

```systemverilog
// 1. Create new test class in FIFO_test.sv
class my_new_test extends FIFO_base_test;
    `uvm_component_utils(my_new_test)
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Custom configuration
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        // Custom test logic
    endtask
endclass
```

### Adding New Sequences

```systemverilog
// 2. Create new sequence in FIFO_sequence.sv
class my_custom_sequence extends FIFO_base_sequence;
    // Implementation
endclass
```

### Customizing Coverage

```systemverilog
// 3. Add coverage points in FIFO_Coverage.sv
covergroup my_custom_cg;
    option.per_instance = 1;
    // Custom coverage points
endgroup
```
