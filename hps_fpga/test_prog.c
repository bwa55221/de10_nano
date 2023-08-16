#include <error.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#define BRIDGE 0xC0000000
#define BRIDGE_SPAN 0x18

#define ADDER_A 0x00
#define ADDER_B 0x08
#define ADDER_SUM 0x10

int main(int argc, char **argv) {
  uint64_t a = 0;
  uint64_t b = 0;
  uint64_t sum = 0;

  uint8_t *a_map = NULL;
  uint8_t *b_map = NULL;
  uint8_t *sum_map = NULL;

  uint8_t *bridge_map = NULL;

  int fd = 0;
  int result = 0;

  if (argc != 3) {
    perror("Only 2 numbers should be passed.");
    return -1;
  }

  a = strtoull(argv[1], NULL, 10);
  b = strtoull(argv[2], NULL, 10);

//  printf("%" PRIu64 "\n", a);
//  printf("%" PRIu64 "\n", b);
  printf("Attempting to open /dev/mem\n");
  fd = open("/dev/mem", O_RDWR | O_SYNC);

  printf("Opened /dev/mem\n");

  if (fd < 0) {
    perror("Couldn't open /dev/mem\n");
    return -2;
  }

  printf("Starting memory map\n");
  bridge_map = (uint8_t *)mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT_WRITE,
                               MAP_SHARED, fd, BRIDGE);

  if (bridge_map == MAP_FAILED) {
    perror("mmap failed.");
    close(fd);
    return -3;
  }

  a_map = bridge_map + ADDER_A;
  b_map = bridge_map + ADDER_B;
  sum_map = bridge_map + ADDER_SUM;

  *((uint64_t *)a_map) = a;
  *((uint64_t *)b_map) = b;
  sum = *((uint64_t *)sum_map);
  printf("Calculated sum\n");

  printf("%" PRIu64 "\n", sum);

  result = munmap(bridge_map, BRIDGE_SPAN);

  if (result < 0) {
    perror("Couldnt unmap bridge.");
    close(fd);
    return -4;
  }

  close(fd);
  return 0;
}
