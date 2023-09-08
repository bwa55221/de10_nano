# de10_nano

This repo serves to aid in experimentation with FPGA/HPS bridge structures. It primarily facilities a test space for experimentation with Avalon Streaming and Memory Mapped interfaces and their interaction with user-space. Future use of hardware test vector control from user-space intended. 

Initial setup code based off of tutorial, here: https://github.com/zangman/de10-nano

Additional scripts created to automate some of the build process.

## Users should add the following lines to their ~/.bashrc file.

### setup alias for DE10-Nano FPGA working directory
```
export DEWD=/home/<username>/DE10_wrk
```

### Cross compiler for DE10 Nano
```
export CROSS_COMPILE=/home/<username>/DE10_wrk/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
```
