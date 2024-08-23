#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define SOME_LARGE_AMOUNT  	4096
#define FILENAME 		"file.txt"
#define SDRAM_BRIDGE		0xf9000000 /* Use actual address */

int main() {

	/* open File */
	FILE *src = fopen(FILENAME, "rb");
	
	/* Check that it is valid */
	if(src == NULL){
		printf("File %s not found\n", FILENAME);
		return(EXIT_FAILURE);
	}
	
	/* point to end of file */
	fseek(src, 0, SEEK_END);
	
	/* Get file size */
	long fl_size = ftell(src);
	
	/* point back to beginning of file */
	fseek(src, 0, SEEK_SET);

	int dfd = open( "/dev/mem", O_RDWR | O_SYNC ); 
	char *dest = (char*)mmap(NULL, fl_size, PROT_READ | PROT_WRITE,
                               MAP_SHARED, dfd, SDRAM_BRIDGE);
	close(dfd);                  
	
	/* Just read from your file directly into your mapped memory */
	fread(dest, fl_size, 1, src);
	printf("Read %ld bytes into memory\n", fl_size);
	
	fclose(src);
}

