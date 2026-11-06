\# Synchronous FIFO RTL Design \& Verification



\## Overview

A synchronous First-In, First-Out (FIFO) buffer designed using Verilog HDL. The design stores data in sequential order and retrieves it in the same order, using clock-synchronized read and write operations.



\## Features

\- 8-bit data width

\- FIFO depth of 8 entries

\- Synchronous reset

\- Read and write pointer logic

\- Occupancy counter

\- Full and empty status flags

\- Overflow and underflow protection

\- Simultaneous read/write support when the FIFO is neither full nor empty



\## Architecture

The design consists of:

\- \*\*Memory Array:\*\* Stores the FIFO data.

\- \*\*Write Pointer:\*\* Tracks the next memory location for writing.

\- \*\*Read Pointer:\*\* Tracks the next memory location for reading.

\- \*\*Occupancy Counter:\*\* Tracks the number of stored entries.

\- \*\*Status Logic:\*\* Generates full and empty flags.



\## Verification

The RTL was simulated using Icarus Verilog with a testbench.



Test scenarios:

\- Reset behavior

\- FIFO filling and full flag assertion

\- Overflow protection

\- FIFO data ordering

\- Empty flag assertion

\- Underflow protection

\- Simultaneous read/write operation

\- Occupancy count validation



\*\*Simulation Result: All implemented test cases passed.\*\*



\## Tools Used

\- Verilog HDL

\- Icarus Verilog

\- VVP Simulation Runtime

\- GTKWave (planned for waveform inspection)



\## Repository Structure

```text

synchronous\_fifo/

├── rtl/

│   └── synchronous\_fifo.v

├── tb/

│   └── synchronous\_fifo\_tb.v

├── sim/

│   └── fifo\_waveform.vcd

└── README.md

```



\## Future Improvements

\- Parameterized depth and data-width verification

\- Additional randomized test scenarios

\- Formal verification

\- FPGA synthesis and implementation

\- Waveform analysis using GTKWave



\## Learning Outcomes

This project demonstrates RTL design, synchronous control logic, FIFO pointer management, status flag generation, and functional simulation-based verification.



