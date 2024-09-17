#ifndef __BRIDGE_CONFIG_H__
#define __BRIDGE_CONFIG_H__

#include <error.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>


/* Base address and Spans are byte addresses */
#define H2F_BRIDGE_BASE_ADDR        0xC0000000
#define H2F_BRIDGE_SPAN             0x3C000000

#define LW_H2F_BRIDGE_BASE_ADDR     0xFF200000
#define LW_H2F_BRIDGE_SPAN          0x001FFFFF

#define F2H_SDRAM_BRIDGE_BASE_ADDR  0x20000000 // starts at +512Mb from 0 address in SDRAM (DDR3)
#define F2H_SDRAM_BRIDGE_SPAN       0x1FFFFFFF // 512 Mb span

#define IMAGE_SPAN_70MBIT           0x42D0000


/* Once a pointer is mapped to the memory location, offsets are represented as 
word addresses since we are completeing 32 bit accessess */
#define ADV7513_DETAIL_OFFSET       0x00000002
#define ADV7513_DETAIL_SHIFT        0
#define ADV7513_DETAIL_MASK         ( 0xFF << ADV7513_DETAIL_SHIFT )
#define ADV7513_CFG_READY_SHIFT     16
#define ADV7513_CFG_READY_MASK      ( 1 << ADV7513_CFG_READY_SHIFT )


#define ADV7513_CFG_OFFSET          0x00000003

#endif /* __BRIDGE_CONFIG_H__ */
