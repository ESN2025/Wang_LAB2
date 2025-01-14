#include <io.h>
#include "system.h"
#include <unistd.h> 
#include "sys/alt_stdio.h"

int main(){

unsigned int count = 0;

    while (1) {
    unsigned int value = count;
    unsigned int units = value % 10;    
    value /= 10;
    unsigned int tens  = value % 10;    
    value /= 10;
    unsigned int hundr = value % 10;   

    IOWR_32DIRECT(UNITS_BASE, 0, units);
    IOWR_32DIRECT(TENS_BASE, 0, tens);
    IOWR_32DIRECT(HUND_BASE, 0, hundr);

    count = (count + 1) % 1000; 
    usleep(500000); // 0.5秒
    }
    return 0;
}
