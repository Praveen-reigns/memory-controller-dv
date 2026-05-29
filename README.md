# Memory Controller — Design & Verification

> UVM-based functional verification of a memory controller with complete read, write, and reset test scenarios.

---

## 📌 Project Overview

This project covers the **RTL design and UVM verification** of a synchronous memory controller. The verification environment exercises all functional modes of the controller and measures functional and code coverage.

### Key Features Verified
- Read/write operations
- Reset behaviour (sync and async)
- Back-to-back transactions
- Error/illegal address handling

---

## 🗂️ Directory Structure

```
memory-controller-dv/
├── rtl/
│   └── mem_ctrl.sv              # Memory controller RTL
├── tb/
│   ├── mem_ctrl_pkg.sv          # Package — all imports
│   ├── mem_ctrl_if.sv           # Interface
│   ├── mem_ctrl_seq_item.sv     # UVM sequence item
│   ├── mem_ctrl_sequence.sv     # UVM sequences (read, write, reset)
│   ├── mem_ctrl_driver.sv       # UVM driver
│   ├── mem_ctrl_monitor.sv      # UVM monitor
│   ├── mem_ctrl_scoreboard.sv   # UVM scoreboard
│   ├── mem_ctrl_coverage.sv     # Functional coverage groups
│   ├── mem_ctrl_agent.sv        # UVM agent
│   ├── mem_ctrl_env.sv          # UVM environment
│   └── mem_ctrl_tb_top.sv       # Top-level testbench
├── tests/
│   ├── mem_ctrl_base_test.sv
│   ├── mem_ctrl_write_test.sv
│   ├── mem_ctrl_read_test.sv
│   └── mem_ctrl_reset_test.sv
├── sim/
│   └── run.do                   # QuestaSim run script
└── README.md
```

---

## 🧱 UVM Testbench Architecture

```
uvm_test
   └── uvm_env
         ├── uvm_agent (active)
         │     ├── uvm_driver     ──▶  DUT (via interface)
         │     ├── uvm_monitor    ◀──  DUT
         │     └── uvm_sequencer
         ├── uvm_scoreboard       (self-checking)
         └── uvm_coverage         (functional coverage)
```

---

## ✅ Test Plan

| Test Name | Scenario | Expected Result |
|---|---|---|
| `write_test` | Random write transactions | Data written to correct address |
| `read_test` | Read after write | Data matches reference model |
| `reset_test` | Assert reset mid-transaction | Controller returns to idle |
| `back2back_test` | Consecutive R/W | No data corruption |

---

## 📊 Coverage Goals

| Coverage Type | Target |
|---|---|
| Functional (write/read/reset) | 100% |
| Code (line/branch) | ≥ 90% |
| Cross coverage (addr × op) | ≥ 85% |

---

## 🛠️ Tools & Languages

- **Language:** SystemVerilog, UVM
- **Simulator:** QuestaSim / Synopsys VCS / Cadence Xcelium

---

## ▶️ How to Run (QuestaSim)

```bash
cd sim/
vsim -do run.do
```

---

## 👤 Author

**Gangaramaina Praveen** | DV Training @ VLSIGURU, Bengaluru
📧 praveentech56@gmail.com
