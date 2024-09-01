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
#define IMAGE_SPAN_70MBIT 0x42D0000



#define OFFSET 0x0 // register offset from base address 
#define WAIT {}

// virtual address pointers
void *sdram_virtual_base;
void *h2f_virtual_base;
void *src_vbase;

// /dev/mem file id
int fd;	
// source file descriptor
int sfd;
size_t filesize;

void write_h2f_bridge(int *hps2fpga, unsigned short addr, unsigned long data)
{
    printf("Writing data to interface...\n");
	*(hps2fpga + addr) = data; 
}

int trigger_sdram_reader() {

    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		// return( 1 );
	}

	h2f_virtual_base = mmap(NULL, H2F_BRIDGE_SPAN, (PROT_READ | PROT_WRITE ), MAP_SHARED, fd, H2F_BRIDGE_BASE_ADDR);
	if ( h2f_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap of H2F Bridge failed...\n" );
		close( fd );
        return(1);
	}
	close( fd ); 

    write_h2f_bridge(h2f_virtual_base, 0, 1); // write a single 1 to register 0

    // unmape the memory spaces
	if (munmap(h2f_virtual_base, H2F_BRIDGE_SPAN) < 0) {
		perror( "Couldn't unmap H2F bridge...\n" );
	}


}

void copy_pixel2sdram(void){
    // open source file
	sfd = open("raw_image.raw", O_RDONLY);
	filesize = lseek(sfd, 0, SEEK_END);
	printf("Filesize (bytes): %08d\n", filesize);
	// map source file
	src_vbase = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, sfd, 0);	
    // close the file descriptor
    close( sfd );


    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		// return( 1 );
	}

	// get the virtual address that maps to the physcial address of the h2f bridge
	sdram_virtual_base = mmap(NULL, IMAGE_SPAN_70MBIT, (PROT_READ | PROT_WRITE ), MAP_SHARED, fd, F2H_SDRAM_BRIDGE_BASE_ADDR);
	if ( sdram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap of FPGA reserved SDRAM failed...\n" );
		close( fd );
		// return(1);
	}

	// safe to close this after mmap has returned
	close( fd ); 

    // copy data to SDRAM
	memcpy(sdram_virtual_base, src_vbase, filesize);

    // unmape the memory spaces
	if (munmap(sdram_virtual_base, IMAGE_SPAN_70MBIT) < 0) {
		perror( "Couldn't unmap FPGA reserved SDRAM...\n" );
	}
    if (munmap(src_vbase, filesize) < 0) {
		perror( "Couldn't unmap source file...\n" );
	}
}

int main(void) {
    printf("Copying pixel file to SDRAM...\n");
    copy_pixel2sdram();
    printf("Writing to H2F control register...\n");
    trigger_sdram_reader();
    printf("Write done...\n");

	return 0;

}
