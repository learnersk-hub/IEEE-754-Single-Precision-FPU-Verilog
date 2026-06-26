# IEEE-754 Inspired 32-bit Single Precision Floating Point Unit (FPU) in Verilog

<p align="center">

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![IEEE-754](https://img.shields.io/badge/IEEE-754%20Single%20Precision-green)
![Simulation](https://img.shields.io/badge/Simulation-Icarus%20Verilog-orange)
![Waveform](https://img.shields.io/badge/Waveform-GTKWave-yellow)

</p>

---

# Overview

This project presents the design and implementation of a **32-bit Single Precision Floating Point Unit (FPU)** based on the **IEEE-754 floating-point representation** using **Verilog HDL**. The design follows a **modular RTL architecture**, where each major function of the floating-point datapath is implemented as an independent hardware module. This modular approach improves readability, maintainability, verification, and scalability while closely resembling real-world digital hardware design methodologies.

The FPU supports the four fundamental floating-point arithmetic operations:

* Floating Point Addition
* Floating Point Subtraction
* Floating Point Multiplication
* Floating Point Division

In addition to arithmetic operations, the design also incorporates:

* Operand unpacking
* IEEE-754 special case detection
* Mantissa normalization
* IEEE-754 inspired rounding
* Top-level operation selection
* Individual module verification
* Complete system simulation

The project has been developed as part of a Digital VLSI learning project and focuses on clean RTL design principles while maintaining compatibility with open-source simulation tools such as **Icarus Verilog** and **GTKWave**.

---

# Features

* IEEE-754 Inspired 32-bit Single Precision Floating Point Arithmetic
* Modular RTL Design
* Floating Point Addition
* Floating Point Subtraction
* Floating Point Multiplication
* Floating Point Division
* Operand Unpacking Module
* Special Case Detection
* Mantissa Normalization
* Round-to-Nearest-Even Logic
* Individual Testbench for Every Module
* Top-Level FPU Module
* GTKWave Compatible Simulation
* Synthesizable RTL

---

# IEEE-754 Single Precision Floating Point Format

Each floating-point number is represented using **32 bits**.

| Field               |   Width |
| ------------------- | ------: |
| Sign                |   1 Bit |
| Exponent            |  8 Bits |
| Mantissa (Fraction) | 23 Bits |

```
 ---------------------------------------------------------
| Sign |      Exponent (8 Bits)      | Fraction (23 Bits) |
 ---------------------------------------------------------
```

The actual mantissa used during arithmetic is:

```
1.Fraction
```

where the leading **1** is the hidden bit for normalized numbers.

---

# Project Architecture

```
                  +-------------------+
                  |     fp_top.v      |
                  +-------------------+
                           |
        -------------------------------------------------
        |               |             |                |
      fp_add         fp_sub        fp_mul          fp_div
        |               |             |                |
        -------------------------------------------------
                           |
             --------------------------------
             |             |                |
         unpack.v    special_case.v   normalize.v
                              |
                          round.v
```

---

# Project Directory Structure

```
IEEE-754-Single-Precision-FPU-Verilog
│
├── rtl
│   ├── unpack.v
│   ├── special_case.v
│   ├── normalize.v
│   ├── round.v
│   ├── fp_add.v
│   ├── fp_sub.v
│   ├── fp_mul.v
│   ├── fp_div.v
│   └── fpu_top.v
│
├── tb
│   ├── unpack_tb.v
│   ├── special_case_tb.v
│   ├── normalize_tb.v
│   ├── round_tb.v
│   ├── fp_add_tb.v
│   ├── fp_sub_tb.v
│   ├── fp_mul_tb.v
│   ├── fp_div_tb.v
│   └── fpu_top_tb.v
│
├── docs
│
└── README.md
```

---

# Module Description

## 1. unpack.v

The unpack module extracts the three major components of an IEEE-754 floating-point number.

### Inputs

* 32-bit Floating Point Number

### Outputs

* Sign Bit
* Exponent
* Mantissa with Hidden Bit

Responsibilities

* Extract sign
* Extract exponent
* Restore hidden leading 1
* Prepare operands for arithmetic units

---

## 2. special_case.v

This module detects all IEEE special numbers before arithmetic begins.

Supported Cases

* Zero
* Infinity
* NaN
* Normal Numbers
* Subnormal Numbers

This prevents invalid arithmetic and ensures correct IEEE-style behavior.

---

## 3. normalize.v

Normalization ensures that the mantissa always remains in normalized IEEE representation after arithmetic.

Responsibilities

* Left Normalization
* Overflow Normalization
* Zero Detection
* Exponent Adjustment

This module is shared across arithmetic operations to simplify the datapath.

---

## 4. round.v

The rounding module implements **IEEE-754 inspired Round-to-Nearest-Even** logic.

Features

* Guard Bit
* Round Bit
* Sticky Bit
* Mantissa Overflow Detection
* Exponent Update after Rounding

---

# Floating Point Addition

Addition is one of the most complex floating-point operations.

The implemented algorithm performs:

```
Unpack

↓

Special Case Detection

↓

Exponent Comparison

↓

Mantissa Alignment

↓

Addition/Subtraction

↓

Normalization

↓

Rounding

↓

Pack Result
```

Supported Cases

* Positive + Positive
* Positive + Negative
* Negative + Positive
* Negative + Negative
* Zero
* Infinity
* NaN

---

# Floating Point Subtraction

Subtraction is implemented by changing the sign of the second operand and reusing the floating-point adder.

```
A - B

↓

A + (-B)
```

Advantages

* Less hardware
* Higher modularity
* Reduced code duplication

---

# Floating Point Multiplication

Multiplication follows the IEEE multiplication algorithm.

```
Sign

↓

Exponent Addition

↓

Mantissa Multiplication

↓

Normalization

↓

Rounding
```

Sign Calculation

```
Sign = SignA XOR SignB
```

Exponent

```
Exp = ExpA + ExpB - Bias
```

Supported Cases

* Normal Numbers
* Zero
* Infinity
* NaN

---

# Floating Point Division

Division performs floating-point division using direct mantissa division.

Algorithm

```
Sign

↓

Exponent Subtraction

↓

Mantissa Division

↓

Normalization

↓

Rounding
```

Special Cases Supported

* Divide by Zero
* Zero Dividend
* Infinity
* NaN
* Infinity / Infinity

---

# Top-Level FPU

The top-level module integrates all arithmetic units into a single processing block.

Operation Selection

| Opcode | Operation      |
| ------ | -------------- |
| 00     | Addition       |
| 01     | Subtraction    |
| 10     | Multiplication |
| 11     | Division       |

This allows one FPU to perform multiple floating-point operations through opcode selection.

---

# Verification

Each RTL module has an independent verification environment.

Modules Verified

* unpack
* special_case
* normalize
* round
* fp_add
* fp_sub
* fp_mul
* fp_div
* fpu_top

Simulation Tools

* Icarus Verilog
* GTKWave

---

# Example Test Cases

| Operation    | Expected Result |
| ------------ | --------------- |
| 2 + 1        | 3               |
| 2 + (-1)     | 1               |
| -2 + (-1)    | -3              |
| 2 - 1        | 1               |
| 2 × 4        | 8               |
| -2 × 4       | -8              |
| 8 ÷ 2        | 4               |
| -8 ÷ 2       | -4              |
| Inf + Inf    | Inf             |
| Inf + (-Inf) | NaN             |
| Inf × 0      | NaN             |
| 5 ÷ 0        | Inf             |
| 0 ÷ 0        | NaN             |

---

# How to Simulate

Compile

```bash
iverilog -o fpu_top_sim \
rtl/unpack.v \
rtl/special_case.v \
rtl/normalize.v \
rtl/round.v \
rtl/fp_add.v \
rtl/fp_sub.v \
rtl/fp_mul.v \
rtl/fp_div.v \
rtl/fpu_top.v \
tb/fpu_top_tb.v
```

Run

```bash
vvp fpu_top_sim
```

Open GTKWave

```bash
gtkwave fpu_top.vcd
```


---

# Learning Outcomes

This project demonstrates practical implementation of:

* IEEE-754 Floating Point Representation
* RTL Design Methodology
* Verilog HDL
* Modular Hardware Design
* Floating Point Arithmetic
* Digital VLSI Design
* Hardware Verification
* Functional Simulation
* Waveform Analysis
* FPGA/ASIC Design Concepts

---

# Acknowledgements

This project was developed as part of a Digital VLSI learning initiative to strengthen understanding of floating-point arithmetic, IEEE-754 representation, RTL design, and digital hardware verification using open-source EDA tools.

---

# License

This project is intended for educational and research purposes. Feel free to use, modify, and extend the design with proper attribution.
