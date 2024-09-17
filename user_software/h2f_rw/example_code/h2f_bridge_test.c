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

// virtual address pointers
void *h2f_virtual_base;
void *src_vbase;

// /dev/mem file id
int fd;	
// source file descriptor
int sfd;
size_t filesize;

// temp data holders
uint32_t return_data_a;
uint32_t return_data_b;
uint64_t reg64_i;

uint32_t read_h2f_bridge(int *hps2fpga, unsigned short addr)
{
	uint32_t data;
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
    // close the file descriptor
    close( sfd );


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

    // ----- Read and Write Operations ------
	// write_h2f_bridge(h2f_virtual_base, 0, 'a');
	// read_h2f_bridge(h2f_virtual_base, 0);

    // copy data from test_file.txt to the avalon registers
	memcpy(h2f_virtual_base, src_vbase, filesize);

    // issue 2 32 bit reads     
    return_data_a = read_h2f_bridge(h2f_virtual_base, 0);
    printf("Return data from address 0: %08X\n", return_data_a);
    return_data_b = read_h2f_bridge(h2f_virtual_base, 1);
    printf("Return data from address 1: %08X\n", return_data_b);

    // concatenate return data and report the 64 bit register value
    reg64_i = (uint64_t) return_data_b << 32 | return_data_a;
    printf("Total register contents: 0x%" PRIx64 "\n", reg64_i);


    // unmape the memory spaces
	if (munmap(h2f_virtual_base, H2F_BRIDGE_SPAN) < 0) {
		perror( "Couldn't unmap H2F bridge...\n" );
	}
    if (munmap(src_vbase, filesize) < 0) {
		perror( "Couldn't unmap source file...\n" );
	}

	return 0;

}
