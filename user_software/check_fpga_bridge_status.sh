#!/bin/bash
echo "-- Checking the status of the FPGA bridges --"
cat /sys/class/fpga_bridge/*/state 