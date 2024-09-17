
#include "bridge_config.h"
#include "adv7513.h"
#include "configure_adv7513.c"

void init_hdmi_tcvr();
void copy_image();

int main(int argc, char *argv[])
{
    if (argc > 1)
    {
        /* Can use this section later to load different images to SDRAM based on argv */
        printf("Argc non-zero!\n");
    }
    else
    {
        copy_image();
        init_hdmi_tcvr();
    }
}

void init_hdmi_tcvr()
{
    int fd;
    void *lwh2f;

    if ( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 )
    {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
	} 

    lwh2f = mmap(NULL, LW_H2F_BRIDGE_SPAN, (PROT_READ | PROT_WRITE ), MAP_SHARED, fd, LW_H2F_BRIDGE_BASE_ADDR);

    printf("Entered into ADV7513 main.cpp initialization function...\n");

    initialize_adv7513(lwh2f);

    printf("Exiting ADV7513 main.cpp init function\n");

    if (munmap ( lwh2f, LW_H2F_BRIDGE_SPAN ) != 0)
    {
        printf( "ERROR: munmap() failed...\n" );
        close( fd );
    }
}

void copy_image()
{

    int imagefd;
    size_t filesize;
    void *image;

    // open image
    imagefd = open("raw_image.raw", O_RDONLY);
    filesize = lseek(imagefd, 0, SEEK_END);
    image = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, imagefd, 0);
    close( imagefd );

    // open /dev/mem
    int fd;
    if ( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 )
    {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
	} 

    void *sdram_virtual_base;
    // map the first image buffer
	sdram_virtual_base = mmap(NULL, IMAGE_SPAN_70MBIT, (PROT_READ | PROT_WRITE ), MAP_SHARED, fd, F2H_SDRAM_BRIDGE_BASE_ADDR);
	if ( sdram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap of FPGA reserved SDRAM failed...\n" );
		close( fd );
	}
    close( fd );

    // copy image to image buffer in sdram
    memcpy(sdram_virtual_base, image, filesize);

    //munmap
    if (munmap(sdram_virtual_base, IMAGE_SPAN_70MBIT) < 0) {
		perror( "Couldn't unmap FPGA reserved SDRAM...\n" );
	}
    if (munmap(image, filesize) < 0) {
		perror( "Couldn't unmap source file...\n" );
	}
}
