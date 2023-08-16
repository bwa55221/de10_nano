#include <iostream>

#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

int main(int argc, char **argv) {

  constexpr uint32_t BRIDGE = 0xC0000000;
  constexpr uint32_t BRIDGE_SPAN = 0x18;

  constexpr uint32_t ADDER_A = 0x00;
  constexpr uint32_t ADDER_B = 0x08;
  constexpr uint32_t ADDER_SUM = 0x10;

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
    std::cerr << "Only 2 numbers should be passed.\n";
    return -1;
  }

  a = std::stoll(argv[1]);
  b = std::stoll(argv[2]);

  fd = open("/dev/mem", O_RDWR | O_SYNC);

  if (fd < 0) {
    std::cerr << "Couldn't open /dev/mem\n";
    return -2;
  }

  bridge_map = static_cast<uint8_t *>(
      mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, BRIDGE));

  if (bridge_map == MAP_FAILED) {
    std::cerr << "mmap failed.";
    close(fd);
    return -3;
  }

  a_map = bridge_map + ADDER_A;
  b_map = bridge_map + ADDER_B;
  sum_map = bridge_map + ADDER_SUM;

  *(reinterpret_cast<uint64_t *>(a_map)) = a;
  *(reinterpret_cast<uint64_t *>(b_map)) = b;

  sum = *(reinterpret_cast<uint64_t *>(sum_map));

  std::cout << sum << std::endl;

  result = munmap(bridge_map, BRIDGE_SPAN);

  if (result < 0) {
    std::cerr << "Couldnt unmap bridge.\n";
    close(fd);
    return -4;
  }

  close(fd);
  return 0;
}
