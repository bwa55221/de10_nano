#include <error.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>  // add this to get strcpy

#define BRIDGE 0xC0000000
#define BRIDGE_SPAN 0x3C000000
#define OFFSET 0x0 // register offset from base address 

int main() {

	uint32_t a = 0; // 32 bit value stored in memory, produced by fpga
	char* virtual_base;
	// uint32_t* a_map;
	char* a_map;

  	int fd = 0;

	fd = open( "/dev/mem", O_RDWR | O_SYNC );

	if (fd < 0){
		printf("failed to open /dev/mem/");
		return -2;
	}
  	printf("Opened /dev/mem successfully!\n");

	virtual_base = (char*)mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT_WRITE,
                               MAP_SHARED, fd, BRIDGE);

	close(fd); // safe to close fd after mmap has returned

	if (virtual_base == MAP_FAILED) {
		perror("mmap failed.");
		close(fd);
		return -3;
		}
	a_map = (char *)(virtual_base + (OFFSET));

	// printf("virtual_base: %08X\n", virtual_base);
	// printf("a_map: %08X\n", a_map);

	strcpy(a_map, "test_string"); // this is 12 characters (including null terminator) / 32 bit writes = 3 write commands


	// writing command

	
	// reading command 
	// a = *((uint32_t *) a_map); // map memory value to userspace variable
	// printf("%08X\n", a); // print variable

	// clean up by unmapping the memmory space
	int result = 0;
	result = munmap(virtual_base, BRIDGE_SPAN);
	
	if (result < 0) {
	  perror("Couldnt unmap bridge.");
	  close(fd);
 	 return -4;
		}

return 0;
}
