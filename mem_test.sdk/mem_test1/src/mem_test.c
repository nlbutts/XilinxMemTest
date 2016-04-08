/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"

void print(char *str);

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <xtime_l.h>
#include <xenv_standalone.h>
#include <xil_cache.h>

static void * srcBuf;
static void * dstBuf;

#define BUFFER_ADDR         0x38000000
#define BUFFER_SIZE         10*1024*1024

extern void memcpyasm(void *dst, void *src, uint32_t size);

static void printPerformanceArray(uint32_t tests, double *time, double *throughput, uint32_t size)
{
	printf("%10u, ", (int)size);
	for (int i = 0; i < tests; i++)
	{
		printf("%e seconds, %f MB/sec, ", time[i], throughput[i]);
	}
	printf("\n");
}


static void printPerformance(XTime start, XTime stop, uint32_t size, char * msg)
{
    double diff;
    double throughput;

    diff = stop - start;
    diff /= XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ;
    printf("%s = %f seconds\n", msg, diff);
    throughput = size / diff;
    throughput /= 1000000;
    printf("Throughput = %f MB/sec\n", throughput);
}

static void calcPerformance(XTime start, XTime stop, uint32_t size, double *time, double *throughput)
{
    double diff;

    diff = stop - start;
    diff /= XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ;
    *time = diff;
    *throughput = size / diff;
    *throughput /= 1000000;
}

/**
 * Helper function for allocating DMA memory. Returns 0 on success, -1 on failure
 */
static int requestDmaMem()
{
    srcBuf = NULL;
    dstBuf = NULL;

    //srcBuf = malloc(BUFFER_SIZE);
    srcBuf = (void*)0x2000000;
    printf("malloc srcBuf = %08X\r", (unsigned int)srcBuf);
    //dstBuf = malloc(BUFFER_SIZE);
    dstBuf = (void*)0x3000000;
    printf("malloc dstBuf = %08X\r", (unsigned int)dstBuf);

    if ((srcBuf == NULL) | (dstBuf == NULL))
    {
        printf("Failed to allocate memory\r");
        return -1;
    }

    return 0;
}

static void performMemoryTest(uint32_t size)
{
    XTime start;
    XTime stop;
    double time[3];
    double throughput[3];

    XTime_GetTime(&start);
    memset(srcBuf, 0x55, size);
    XTime_GetTime(&stop);
    calcPerformance(start, stop, size, &time[0], &throughput[0]);

    XTime_GetTime(&start);
    memcpy(dstBuf, srcBuf, size);
    XTime_GetTime(&stop);
    calcPerformance(start, stop, size, &time[1], &throughput[1]);

    XTime_GetTime(&start);
    memcpyasm(dstBuf, srcBuf, size);
    XTime_GetTime(&stop);
    calcPerformance(start, stop, size, &time[2], &throughput[2]);

    printPerformanceArray(3, time, throughput, size);
}

/**
 * Helper function to free DMA memory
 */
static void freeDmaMem()
{
    if(srcBuf != NULL)
    {
        //free(srcBuf);
    }
    srcBuf = NULL;

    if (dstBuf != NULL)
    {
        //free(dstBuf);
    }
}

int main()
{
    printf("Memory test\r");
    Xil_L1DCacheEnable();
    Xil_L2CacheEnable();

    if (requestDmaMem() >= 0)
    {
        printf("Testing with L1D and L2 cache enabled\n");
        performMemoryTest(1024);
        performMemoryTest(1024*32);
        performMemoryTest(1024*128);
        performMemoryTest(1024*256);
        performMemoryTest(1024*512);
        performMemoryTest(1024*1024);
        performMemoryTest(1024*1024*10);

        printf("Disabling L2 cache\n");
        Xil_L2CacheDisable();

        performMemoryTest(1024);
        performMemoryTest(1024*32);
        performMemoryTest(1024*128);
        performMemoryTest(1024*256);
        performMemoryTest(1024*512);
        performMemoryTest(1024*1024);
        performMemoryTest(1024*1024*10);

        printf("Disable L1 cache\n");
        Xil_L1DCacheDisable();

        performMemoryTest(1024);
        performMemoryTest(1024*32);
        performMemoryTest(1024*128);
        performMemoryTest(1024*256);
        performMemoryTest(1024*512);
        performMemoryTest(1024*1024);
        performMemoryTest(1024*1024*10);

    }
    freeDmaMem();

    return 0;
}
