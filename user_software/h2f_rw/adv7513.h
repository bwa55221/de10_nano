#ifndef __ADV7513_H__
#define __ADV7513_H__

#include "bridge_config.h"

#define ROWS 17
#define COLS 2

void initialize_adv7513(void *lwh2f);
void write_h2f_reg(void *lwh2f, uint32_t addr, uint32_t data);
void rmw_h2f_reg(void *lwh2f, uint32_t addr, uint32_t data, uint32_t mask, uint32_t shift);


#endif /* __ADV7513_H__ */