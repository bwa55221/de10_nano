#!/bin/bash

alias mem='busybox devmem'

echo "fpgaportrst reg"
mem 0xFFC25080
echo "staticcfg reg"
mem 0xFFC2505C