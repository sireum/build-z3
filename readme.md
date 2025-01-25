# Z3 Build

[![Actions Status](https://github.com/sireum/build-z3/workflows/Build/badge.svg)](https://github.com/sireum/build-z3/actions/workflows/Build.yml) 

This repository hosts Z3 build scripts for dynamically-linked macOS arm64/amd64, statically-linked binary Linux amd64/arm64 (glibc/musl+gmp) and Windows amd64 (VS2019) binaries, as well as a universal binary using [Cosmopolitan](https://github.com/jart/cosmopolitan).

The Github Action builds publish to https://github.com/sireum/rolling/releases/tag/z3 (`z3-exe-*.zip`).
