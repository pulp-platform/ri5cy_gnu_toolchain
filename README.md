This repository is **archived**. For current toolchains, please see the following:

| 🧰 Toolchain | 🎯 Target extensions                            | 💻 Target cores | 🔗 Link                                                                                             |
|--------------|------------------------------------------------|-----------------|-----------------------------------------------------------------------------------------------------|
| GCC7         | `xpulpv2`                                      | RI5CY           | [pulp-platform/pulp-riscv-gnu-toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain) |
| GCC11        | `xpulpv3`                                      | CV32E40P        | [pulp-platform/riscv-gnu-toolchain](https://github.com/pulp-platform/riscv-gnu-toolchain)           |
| LLVM         | `xpulpv2`, `xssr`, `xfrep`, `xdma`, `xmempool` | RI5CY, Snitch   | [pulp-platform/llvm-project](https://github.com/pulp-platform/llvm-project)                         |

# Introduction

This is a port of the RISCV GCC toolchain, which has been extended to support the extensions of the Pulpino core.

# Build

Run the following command to build the toolchain (by default for riscy, see the next section to select another core):

    make

This will download a specific version of the RISCV toolchain based on gcc 5.2, patch it with extensions for Pulpino and compile it.

The resulting toolchains should be in the install directory.

# Supported cores

This toolchain supports the following Pulpino cores :

- Riscy. Compile the toolchain with: make

- Riscy_fpu (riscy with hardare floating point unit). Compile the toolchain with: make RISCY_FPU=1

- Zeroriscy. Compile the toolchain with: make ZERORISCY=1

- Microriscy. Compile the toolchain with: make MICRORISCY=1

# Usage

The toolchain can be used as the standard RISCV toolchain except that one of the following option must be used:

- Riscy: -march=IMXpulpv2

- Riscy_fpu: -march=IMFDXpulpv2 -mhard-float

- Zeroriscy. Compile the toolchain with: -march=IM

- Microriscy. Compile the toolchain with: -march=I -m16r

This option will select the appropriate set of instructions to be used, thus no other RISCV option is needed.



  
