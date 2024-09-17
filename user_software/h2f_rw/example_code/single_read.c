#include <error.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>

#define H2F_BRIDGE_BASE_ADDR 0xC0000000
#define H2F_BRIDGE_SPAN 0x3C000000
#define LW_H2F_BRIDGE_BASE_ADDR 0xFF200000
#define LW_H2F_BRIDGE_SPAN 0x001FFFFF
#define F2H_SDRAM_BRIDGE_BASE_ADDR 0x20000000 // starts at +512Mb from 0 address in SDRAM (DDR3)
#define F2H_SDRAM_BRIDGE_SPAN 0x1FFFFFFF // 512 Mb span


#define OFFSET 0x0 // register offset from base address 
#define WAIT {}

void *h2f_virtual_base;
void *src_vbase;

// /dev/mem file id
int fd;	
// source file descriptor
int sfd;
size_t filesize;

unsigned char read_h2f_bridge(int *hps2fpga, unsigned short addr)
{
	unsigned char data;
	data = *(hps2fpga + addr);
	return data;
}

void write_h2f_bridge(int *hps2fpga, unsigned short addr, unsigned char data)
{
	*(hps2fpga + addr) = data; 
}

int main(void) {


	// open source file
	sfd = open("test_file.txt", O_RDONLY);
	filesize = lseek(sfd, 0, SEEK_END);

	printf("Filesize (bytes): %08d\n", filesize);

	// map source file
	src_vbase = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, sfd, 0);	


    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	// get the virtual address that maps to the physcial address of the h2f bridge
	h2f_virtual_base = mmap(NULL, H2F_BRIDGE_SPAN, (PROT_READ | PROT_WRITE ), MAP_SHARED, fd, H2F_BRIDGE_BASE_ADDR);
	if ( h2f_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap of H2F Bridge failed...\n" );
		close( fd );
		return(1);
	}

	// safe to close this after mmap has returned
	close( fd ); 

	// write_h2f_bridge(h2f_virtual_base, 0, 'a');
	// read_h2f_bridge(h2f_virtual_base, 0);

	memcpy(h2f_virtual_base, src_vbase, filesize);


	if (munmap(h2f_virtual_base, H2F_BRIDGE_SPAN) < 0) {
		perror( "Couldn't unmap H2F bridge...\n" );
	}




	return 0;

// 	uint32_t a = 0; // 32 bit value stored in memory, produced by fpga
// 	char* virtual_base;
// 	uint32_t* a_map;

//   	int fd = 0;

// 	fd = open( "/dev/mem", O_RDWR | O_SYNC );

// 	if (fd < 0){
// 		printf("failed to open /dev/mem/");
// 		return -2;
// 	}
//   	printf("Opened /dev/mem successfully!\n");

// 	virtual_base = mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT_WRITE,
//                                MAP_SHARED, fd, BRIDGE);

// 	close(fd); // safe to close fd after mmap has returned

// 	if (virtual_base == MAP_FAILED) {
// 		perror("mmap failed.");
// 		close(fd);
// 		return -3;
// 		}
// 	a_map = (uint32_t *)(virtual_base + (OFFSET));

// 	printf("virtual_base: %08X\n", virtual_base);
// 	printf("a_map: %08X\n", a_map);

// 	a = *((uint32_t *) a_map); // map memory value to userspace variable
// 	printf("%08X\n", a); // print variable

// 	// clean up by unmapping the memmory space
// 	int result = 0;
// 	result = munmap(virtual_base, BRIDGE_SPAN);
	
// 	if (result < 0) {
// 	  perror("Couldnt unmap bridge.");
// 	  close(fd);
//  	 return -4;
// 		}

// return 0;
}
