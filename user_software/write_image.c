#include <error.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>  // add this to get strcpy

#define HPS_SDRAM 0x00000000
#define HPS_SDRAM_SPAN 0x20000000 

#define SDRAM_BRIDGE 0x20000000 // FPGA2HPS SDRAM memory space starts @ 512Mb via bootparam
#define BRIDGE_SPAN 0x20000000 // this address space is the upper half of 1 Gb ddr and is 512 Mb wide
#define OFFSET 0x0 // register offset from base address 

int main() {

	char *src, *dest;
    size_t filesize; // define variable to hold source file filesize
    // FILE *sfd;
    int sfd = 0;
  	int dfd = 0;

    /* Source File */
	// sfd = fopen("/root/test_image.bin", "rb"); // source file descriptor
    sfd = open("/root/test_image.bin", O_RDONLY); // changed to regular "open" because mmap was complaining about file pointer
    filesize = lseek(sfd, 0, SEEK_END);
	src = (char*)mmap(NULL, HPS_SDRAM_SPAN, PROT_READ,
                               MAP_PRIVATE, sfd, HPS_SDRAM);
    close(sfd);

    /* Destination */
    dfd = open( "/dev/mem", O_RDWR | O_SYNC ); // destination file descriptor

    /* Save this in case I want to create a copy of the src file
        dfd = open("dest", O_RDWR | O_CREAT, 0666);
        ftruncate(dfd, filesize);
    */

    if (dfd < 0){
		printf("failed to open /dev/mem/");
		return -2;
    }
	dest = (char*)mmap(NULL, filesize, PROT_READ | PROT_WRITE,
                               MAP_SHARED, dfd, SDRAM_BRIDGE);
	close(dfd); // safe to close fd after mmap has returned

	if (dest == MAP_FAILED) {
		perror("mmap failed.");
		return -3;
		}

    /* Copy File into Memory */
    memcpy(dest, src, filesize);

	// clean up by unmapping the memmory space
	int result = 0;
	result = munmap(src, filesize);
	if (result < 0) {
	  perror("Couldnt unmap src.");
 	 return -4;
		}

    result = 0;
	result = munmap(dest, filesize);
	if (result < 0) {
	  perror("Couldnt unmap dest.");
 	 return -4;
		}

return 0;
}
