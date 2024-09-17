#include "bridge_config.h"
#include "adv7513.h"

const uint8_t cfg_data [ROWS][COLS] = {
    {0x41, 0x10},  //   enable power up
    {0x98, 0x03},  //   must be set for proper operation
    {0x9A, 0xE0},  //   must be set for proper operation
    {0x9C, 0x30},  //   must be set for proper operation
    {0x9D, 0x61},  //   set clock divide
    {0xA2, 0xA4},  //   must be set for proper operation
    {0xA3, 0xA4},  //   must be set for proper operation
    {0xE0, 0xD0},  //   must be set for proper operation 
    {0xF9, 0x00},  //   must be set for proper operation
    {0x15, 0x20},  //   input 444 (RGB or YcrCb) with separate syncs, 48 kHz fs
    {0x16, 0x30},  //   output format 444, 8 bit input color depth, 
    {0x18, 0x46},  //   disable CSC
    {0xAF, 0x06},  //   select HDMI mode and disable HDCP 
    {0x55, 0x10},  //   enable AVI info frame, communicate RGB 4:4:4
    {0x56, 0x08},  //   set AVI format same as aspect ratio
    {0x96, 0xF6},  //   set interrupts (? still unsure about this ?)
    {0x17, 0x02}   //   set aspect ratio to 16:9
};

// write only
void write_h2f_reg(void *lwh2f, uint32_t addr, uint32_t data)
{
    // index the pointer like an array because that is technically what is is
    // indicate to compiler that we are casting the pointer as a 32 bit int
    ((uint32_t *) lwh2f)[addr] = data;
    usleep(5000);
}

// read-modify-write
void rmw_h2f_reg(void *lwh2f, uint32_t addr, uint32_t data, uint32_t mask, uint32_t shift)
{
    uint32_t tmp;
    tmp = ((uint32_t *) lwh2f)[addr];
    printf("rmw tmp: %08X\n", tmp);
    tmp = tmp & ~(mask) | (data << shift);
    printf("rmw tmp new value: %08X\n", tmp);
    ((uint32_t *) lwh2f)[addr] = tmp;
    usleep(5000);
}

/* a void pointer is as wide as the architecture and the correct way to be used ! */
void initialize_adv7513(void *lwh2f)
{
    // indicate the number of configuration entries in the cfg_data array
    write_h2f_reg(lwh2f, ADV7513_DETAIL_OFFSET, ROWS);

    for (int i = 0; i < ROWS; i++){
        write_h2f_reg(lwh2f, ADV7513_CFG_OFFSET + i, ((uint32_t)cfg_data[i][0] << 8 | cfg_data[i][1]));
    }
    printf("End ADV7513 Initialization Register Programming.\n");

    // tell the fpga the hps is done writing data into the configuration registers
    rmw_h2f_reg(lwh2f, ADV7513_DETAIL_OFFSET, 1, ADV7513_CFG_READY_MASK, ADV7513_CFG_READY_SHIFT);
};