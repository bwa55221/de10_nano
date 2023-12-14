#!/bin/bash

cat /sys/clas/fpga_bridge/*/state


<<comment
                fpga_bridge0: fpga_bridge@ff400000 {
                        compatible = "altr,socfpga-lwhps2fpga-bridge";
                        reg = <0xff400000 0x100000>;
                        resets = <&rst LWHPS2FPGA_RESET>;
                        clocks = <&l4_main_clk>;
                        status = "disabled";
                };

                fpga_bridge1: fpga_bridge@ff500000 {
                        compatible = "altr,socfpga-hps2fpga-bridge";
                        reg = <0xff500000 0x10000>;
                        resets = <&rst HPS2FPGA_RESET>;
                        clocks = <&l4_main_clk>;
                        status = "disabled";
                };

                fpga_bridge2: fpga-bridge@ff600000 {
                        compatible = "altr,socfpga-fpga2hps-bridge";
                        reg = <0xff600000 0x100000>;
                        resets = <&rst FPGA2HPS_RESET>;
                        clocks = <&l4_main_clk>;
                        status = "disabled";
                };

                fpga_bridge3: fpga-bridge@ffc25080 {
                        compatible = "altr,socfpga-fpga2sdram-bridge";
                        reg = <0xffc25080 0x4>;
                        status = "disabled";
                };
comment