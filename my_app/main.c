#include <io.h>
#include "system.h"
#include <unistd.h> 
#include "sys/alt_stdio.h"

int main(){
    unsigned int count=0;
    while(1) {
        IOWR_32DIRECT(SEL_BASE, 0, count & 0xF);
	//IOWR(SEL_BASE, 0, count & 0xF);
        count = (count + 1) % 10;
	alt_printf("Hello");
        usleep(500000);
    }
    return 0;
}