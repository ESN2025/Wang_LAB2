#include <stdint.h>
#include <unistd.h>      // usleep() 等函数
#include "system.h"      // 这里面包含 DECO7SEG_AVALON_0_BASE 等宏定义
#include "io.h"          // IOWR_32DIRECT, IORD_32DIRECT 等宏
#include "sys/alt_stdio.h"

int main(void)
{
    uint32_t i = 0;
alt_printf("Show digit: on 7-seg\n");

    while (1)
    {

        IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 0, (i & 0xF));

        
        usleep(500000);
	i = (i + 1) % 10;
    }

    return 0;
}
