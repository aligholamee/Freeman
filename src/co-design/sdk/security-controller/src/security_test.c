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
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"
#include <stdlib.h>

#define base 0x44A00000

#define S_SLV_REG0 0
#define S_SLV_REG1 4
#define S_SLV_REG2 8
#define S_SLV_REG3 12
#define S_SLV_REG4 16
#define S_SLV_REG5 20
#define S_SLV_REG6 24
#define S_SLV_REG7 28

#define writeReg(BaseAddress, RegOffset, Data) \
	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define readReg(BaseAddress, RegOffset) \
	Xil_In32((BaseAddress) + (RegOffset))

#define sharpCommand 64
#define starCommand 84


void print(char *str);

int main()
{
    init_platform();
    // ADDING NEW USER
    writeReg(base, S_SLV_REG2, sharpCommand + 1);	// # - 64
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, starCommand + 1);	// * - 84
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, 5);				// 2
    writeReg(base, S_SLV_REG2, 6);				// 3
    writeReg(base, S_SLV_REG2, 9);				// 4
    writeReg(base, S_SLV_REG2, starCommand);	// * - 85
    writeReg(base, S_SLV_REG2, 11);				// 5
    writeReg(base, S_SLV_REG2, 8); 				// 4
    writeReg(base, S_SLV_REG2, 7);				// 3
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, sharpCommand + 1); 	// # - 64

    // UPDATING USER INFO
    writeReg(base, S_SLV_REG2, sharpCommand);	// #
    writeReg(base, S_SLV_REG2, 3);				// 1
    writeReg(base, S_SLV_REG2, starCommand);	// *
    writeReg(base, S_SLV_REG2, 11);				// 5
    writeReg(base, S_SLV_REG2, 8);				// 4
    writeReg(base, S_SLV_REG2, 7); 				// 3
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, starCommand + 1);	// *
    writeReg(base, S_SLV_REG2, 6);				// 3
    writeReg(base, S_SLV_REG2, 5);				// 2
    writeReg(base, S_SLV_REG2, 8);				// 4
    writeReg(base, S_SLV_REG2, 3);				// 1
    writeReg(base, S_SLV_REG2, sharpCommand);	// #


    // TURN ON
    writeReg(base, S_SLV_REG2, sharpCommand + 1);	// #
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, starCommand + 1);	// *
    writeReg(base, S_SLV_REG2, 2);				// 1
    writeReg(base, S_SLV_REG2, sharpCommand + 1);   // #


    cleanup_platform();
    return 0;
}
