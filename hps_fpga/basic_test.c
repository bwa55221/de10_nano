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
	printf("entered main\n");
	printf("going to print again!\n");

	printf("printing args\n");
	a = strtoull(argv[1], NULL, 10);
	printf("%" PRIu64 "\n", a);
	b = strtoull(argv[2], NULL, 10);
	printf("%" PRIu64 "\n", b);

	fd = open( "/dev/mem", O_RDWR | O_SYNC );

	if (fd < 0){
		printf("failed to open /dev/mem/");
		return -2;
	}
  	printf("Opened /dev/mem successfully!\n");

	bridge_map = mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT_WRITE,
                               MAP_SHARED, fd, BRIDGE);

	close(fd); // safe to close fd after mmap has returned

	if (bridge_map == MAP_FAILED) {
		perror("mmap failed.");
		close(fd);
		return -3;
		}
	a_map = bridge_map + ADDER_A;
	b_map = bridge_map + ADDER_B;
	sum_map = bridge_map + ADDER_SUM;
	printf("%" PRIu8 "\n", bridge_map);
	printf("%" PRIu8 "\n", a_map);
	printf("%" PRIu8 "\n", b_map);
	printf("%" PRIu8 "\n", sum_map);


	*((uint64_t *) a_map) = a;
	*((uint64_t *) b_map) = b;
	sum = *((uint64_t *) sum_map);

	printf("%" PRIu64 "\n", sum);

return 0;
}
