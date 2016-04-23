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

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <xtime_l.h>
#include <xenv_standalone.h>
#include <xil_cache.h>
#include <xdmaps.h>
#include <xscugic.h>

static void * srcBuf;
static void * dstBuf;

#define BUFFER_ADDR             0x38000000
#define BUFFER_SIZE             10*1024*1024
#define TIMEOUT_LIMIT           100000
#define DMA_DEVICE_ID           XPAR_XDMAPS_1_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_SCUGIC_SINGLE_DEVICE_ID

#define DMA_DONE_INTR_0         XPAR_XDMAPS_0_DONE_INTR_0
#define DMA_DONE_INTR_1         XPAR_XDMAPS_0_DONE_INTR_1
#define DMA_DONE_INTR_2         XPAR_XDMAPS_0_DONE_INTR_2
#define DMA_DONE_INTR_3         XPAR_XDMAPS_0_DONE_INTR_3
#define DMA_DONE_INTR_4         XPAR_XDMAPS_0_DONE_INTR_4
#define DMA_DONE_INTR_5         XPAR_XDMAPS_0_DONE_INTR_5
#define DMA_DONE_INTR_6         XPAR_XDMAPS_0_DONE_INTR_6
#define DMA_DONE_INTR_7         XPAR_XDMAPS_0_DONE_INTR_7
#define DMA_FAULT_INTR          XPAR_XDMAPS_0_FAULT_INTR


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
    printf("%d bytes copied. Throughput = %f MB/sec\n", size, throughput);
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

int SetupInterruptSystem(XScuGic *GicPtr, XDmaPs *DmaPtr)
{
    int Status;
#ifndef TESTAPP_GEN
    XScuGic_Config *GicConfig;


    Xil_ExceptionInit();

    /*
     * Initialize the interrupt controller driver so that it is ready to
     * use.
     */
    GicConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == GicConfig) {
        return XST_FAILURE;
    }

    Status = XScuGic_CfgInitialize(GicPtr, GicConfig,
                       GicConfig->CpuBaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Connect the interrupt controller interrupt handler to the hardware
     * interrupt handling logic in the processor.
     */
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
                 (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                 GicPtr);
#endif
    /*
     * Connect the device driver handlers that will be called when an interrupt
     * for the device occurs, the device driver handler performs the specific
     * interrupt processing for the device
     */

    /*
     * Connect the Fault ISR
     */
    Status = XScuGic_Connect(GicPtr,
                 DMA_FAULT_INTR,
                 (Xil_InterruptHandler)XDmaPs_FaultISR,
                 (void *)DmaPtr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Connect the Done ISR for all 8 channels of DMA 0
     */
    Status = XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_0,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_0,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_1,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_1,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_2,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_2,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_3,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_3,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_4,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_4,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_5,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_5,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_6,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_6,
                 (void *)DmaPtr);
    Status |= XScuGic_Connect(GicPtr,
                 DMA_DONE_INTR_7,
                 (Xil_InterruptHandler)XDmaPs_DoneISR_7,
                 (void *)DmaPtr);

    if (Status != XST_SUCCESS)
        return XST_FAILURE;

    /*
     * Enable the interrupts for the device
     */
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_0);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_1);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_2);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_3);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_4);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_5);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_6);
    XScuGic_Enable(GicPtr, DMA_DONE_INTR_7);
    XScuGic_Enable(GicPtr, DMA_FAULT_INTR);

    Xil_ExceptionEnable();

    return XST_SUCCESS;

}

static void DmaDoneHandler(unsigned int channel, XDmaPs_Cmd * cmd, void * callbackref)
{
    int* done = (int*)callbackref;
    *done = 1;
}

static void testDMA(uint32_t size)
{
    int Status;
    XScuGic GicPtr;
    XDmaPs_Cmd DmaCmd;
    XDmaPs DmaInst;
    XDmaPs_Config *DmaCfg;
    int Channel = 0;
    int Checked = 0;
    int TimeOutCnt;
    XTime start;
    XTime stop;

    memset(&DmaCmd, 0, sizeof(XDmaPs_Cmd));

    DmaCmd.ChanCtrl.SrcBurstSize = 8;
    DmaCmd.ChanCtrl.SrcBurstLen = 32;
    DmaCmd.ChanCtrl.SrcInc = 1;
    DmaCmd.ChanCtrl.DstBurstSize = 8;
    DmaCmd.ChanCtrl.DstBurstLen = 32;
    DmaCmd.ChanCtrl.DstInc = 1;
    DmaCmd.BD.SrcAddr = (u32) srcBuf;
    DmaCmd.BD.DstAddr = (u32) dstBuf;
    DmaCmd.BD.Length = size;

    /*
     * Initialize the DMA Driver
     */
    DmaCfg = XDmaPs_LookupConfig(XPAR_PS7_DMA_S_DEVICE_ID);
    if (DmaCfg == NULL) {
        printf("Error finding DMA\n");
    }

    Status = XDmaPs_CfgInitialize(&DmaInst,
                   DmaCfg,
                   DmaCfg->BaseAddress);
    if (Status != XST_SUCCESS) {
        printf("Error configuring the DMA\n");
    }


    /*
     * Setup the interrupt system.
     */
    Status = SetupInterruptSystem(&GicPtr, &DmaInst);
    if (Status != XST_SUCCESS) {
        printf("Failed to configure interrupts\n");
    }

    memset(dstBuf, 0, size);

    XDmaPs_SetDoneHandler(&DmaInst,
                   Channel,
                   DmaDoneHandler,
                   (void *)&Checked);


    XTime_GetTime(&start);
    Status = XDmaPs_Start(&DmaInst, Channel, &DmaCmd, 0);
    if (Status != XST_SUCCESS) {
        printf("Failed to start DMA\n");
    }

    TimeOutCnt = 0;

    /* Now the DMA is done */
    while (!Checked
           && TimeOutCnt < (TIMEOUT_LIMIT)) {
        TimeOutCnt++;
        usleep(1);
    }

    XTime_GetTime(&stop);
    if (TimeOutCnt >= TIMEOUT_LIMIT) {
        printf("DMA took too long\n");
    }
    printPerformance(start, stop, size, "DMA Transfer");
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
    	while (1)
    	{
			printf("Testing with L1D and L2 cache enabled\n");
    		Xil_L1DCacheEnable();
    		Xil_L2CacheEnable();
			performMemoryTest(1024);
			performMemoryTest(1024*32);
			performMemoryTest(1024*128);
			performMemoryTest(1024*256);
			performMemoryTest(1024*512);
			performMemoryTest(1024*1024);
			performMemoryTest(1024*1024*10);
			testDMA(1024*1024);
			testDMA(1024*1024*10);

			printf("Disabling L2 cache\n");
			Xil_L2CacheDisable();

			performMemoryTest(1024);
			performMemoryTest(1024*32);
			performMemoryTest(1024*128);
			performMemoryTest(1024*256);
			performMemoryTest(1024*512);
			performMemoryTest(1024*1024);
			performMemoryTest(1024*1024*10);
			testDMA(1024*1024*10);

			printf("Disable L1 cache\n");
			Xil_L1DCacheDisable();

			performMemoryTest(1024);
			performMemoryTest(1024*32);
			performMemoryTest(1024*128);
			performMemoryTest(1024*256);
			performMemoryTest(1024*512);
			performMemoryTest(1024*1024);
			performMemoryTest(1024*1024*10);
			testDMA(1024*1024*10);
    	}
    }
    freeDmaMem();

    return 0;
}
