# 8-Bit ALU with Tri-State Output Enable

**Verilog HDL Implementation**

---

## 1. Overview

An **Arithmetic Logic Unit (ALU)** is the core computational block of a digital system. It performs arithmetic operations such as addition and multiplication, as well as logical operations such as AND, OR, and XOR.

This project implements an **8-bit combinational ALU** using **Verilog HDL**, capable of performing **16 different operations** selected via a 4-bit control signal. The ALU output is **16 bits wide** to accommodate operations such as multiplication.

A **tri-state output enable (`oe`)** is used to control when the ALU drives the output bus, demonstrating shared-bus behavior commonly found in processor architectures.

---

## 2. ALU Specifications

### Input Signals

| Signal       | Width  | Description      |
| ------------ | ------ | ---------------- |
| `a_in`       | 8 bits | Operand A        |
| `b_in`       | 8 bits | Operand B        |
| `command_in` | 4 bits | Operation select |
| `oe`         | 1 bit  | Output enable    |

### Output Signal

| Signal  | Width   | Description                       |
| ------- | ------- | --------------------------------- |
| `d_out` | 16 bits | ALU result (tri-state controlled) |

---

## 3. Supported ALU Operations

| Opcode | Operation | Description        |
| ------ | --------- | ------------------ |
| `0000` | ADD       | A + B              |
| `0001` | INC       | A + 1              |
| `0010` | SUB       | A − B              |
| `0011` | DEC       | A − 1              |
| `0100` | MUL       | A × B              |
| `0101` | DIV       | A ÷ B              |
| `0110` | SHL       | Shift A left by 1  |
| `0111` | SHR       | Shift A right by 1 |
| `1000` | AND       | A AND B            |
| `1001` | OR        | A OR B             |
| `1010` | INV       | Bitwise NOT of A   |
| `1011` | NAND      | NAND operation     |
| `1100` | NOR       | NOR operation      |
| `1101` | XOR       | XOR operation      |
| `1110` | XNOR      | XNOR operation     |
| `1111` | BUF       | Buffer A           |

---

## 4. What is Tri-State Logic?

A **tri-state signal** can exist in **three possible states**:

1. Logic `0`
2. Logic `1`
3. High-impedance (`Z`)

The high-impedance state electrically disconnects the output from the circuit, allowing multiple modules to safely share a common bus.

---

## 5. Why Tri-State is Used

Tri-state logic is essential in:

* Shared data buses
* Microprocessor architectures
* Memory and peripheral interfacing
* System-on-chip communication

Only one device drives the bus at a time, while others remain in the `Z` state.

---

## 6. Tri-State Implementation in This ALU

```verilog
assign d_out = (oe) ? out : 16'hzzzz;
```

| `oe` | `d_out` Behavior               |
| ---- | ------------------------------ |
| `1`  | ALU drives the result          |
| `0`  | Output is high-impedance (`Z`) |

---

## 7. What Does the BUFFER (BUF) Operation Mean?

### Definition

The **BUFFER (BUF)** operation passes the input operand **A directly to the output without modification**.

```verilog
BUF : out = a_in;
```

In other words:

[
\text{Output} = A
]

---

### Why is BUF Needed in an ALU?

Although it may appear trivial, the buffer operation is **architecturally important**:

1. **Data Transfer Without Computation**
   BUF allows moving data through the ALU without altering it.

2. **Register-to-Bus Transfer**
   In processor datapaths, BUF is commonly used to place a register value onto a shared bus.

3. **Pipeline and Control Operations**
   BUF supports pipeline stages where computation is not required but data forwarding is needed.

4. **Consistency in Opcode Design**
   Including BUF ensures every opcode performs a defined function, avoiding unused control states.

---

### Hardware Interpretation

A buffer is **not memory** and **not amplification**.
It is a **combinational pass-through** logic.

| Concept            | Explanation          |
| ------------------ | -------------------- |
| NOT a latch        | No storage, no clock |
| NOT an amplifier   | Digital logic only   |
| YES a pass-through | Output follows input |

---

### Relationship Between BUF and Tri-State

The BUF operation works together with the tri-state enable:

* `BUF + oe = 1` → A is driven onto the output bus
* `BUF + oe = 0` → Output bus is disconnected (`Z`)

This mimics **CPU bus drivers**, where registers place their contents on the data bus only when enabled.

---

### Bit-Width Justification

* Inputs: 8-bit
* Output: 16-bit
* Prevents overflow during multiplication
* Maintains correctness for arithmetic operations

---

### Division Safety

Division-by-zero is handled safely:

```verilog
DIV : out = (b_in != 0) ? (a_in / b_in) : 16'd0;
```

---

## 8. FPGA Design Note

Modern FPGAs:

* Do not allow internal tri-state nets
* Replace tri-state logic with multiplexers internally

However, tri-state logic remains:

* Conceptually important
* Essential for I/O interfaces
* Common in academic and architectural studies

