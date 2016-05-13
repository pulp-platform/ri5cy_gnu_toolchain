# Introduction

This is a port of the RISCV GCC toolchain, which has been extended to support the extensions of the Pulpino core.

# Build

Run the following command to build the toolchain:

  make

This will download a specific version of the RISCV toolchain based on gcc 5.3, patch it with extensions for Pulpino and compile it.

The resulting toolchains should be in the install directory.

# Supported cores

This toolchain supports the following Pulpino cores :

- Honey bunny, referred as pulpv0

- Imperio, referred as pulpv1

- Latest version, referred as pulpv2

# Usage

The toolchain can be used as the standard RISCV toolchain except that one of the following option must be used:

  -march=IXpulpv0
  -march=IXpulpv1
  -march=IXpulpv2

This option will select the appropriate set of instructions to be used, thus no other RISCV option is needed.



  