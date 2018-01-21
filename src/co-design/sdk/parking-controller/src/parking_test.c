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

#define S_SLV_REG0 0	//  COMMAND (32 BITS)
#define S_SLV_REG1 4	// COMMAND READY
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

// Holds the number of loop iterations
# define num_of_cars 20
#define plate_max 99999
#define plate_min 11111
#define loc_max 90
#define loc_min 1
#define sharpCommand 64
#define starCommand 84


void print(char *str);

int main()
{
    init_platform();

	// Command(0) = 0
	writeReg(base, S_SLV_REG0, sharpCommand + 1);	// Command(0) = 1 #
	writeReg(base, S_SLV_REG0, 6);					// Command(0) = 0 3
	writeReg(base, S_SLV_REG0, 5);					// Command(0) = 1 2
	writeReg(base, S_SLV_REG0, 4); 					// Command(0) = 0 2
	writeReg(base, S_SLV_REG0, 5); 					// Command(0) = 1 2
	writeReg(base, S_SLV_REG0, 2); 					// Command(0) = 0 1
	writeReg(base, S_SLV_REG0, starCommand + 1); 	// Command(0) = 1 *
	writeReg(base, S_SLV_REG0, 6);					// Command(0) = 0 3
	writeReg(base, S_SLV_REG0, 3);					// Command(0) = 1 1
	//////////////////////////// Command Ready Enable ////////////////////////
	writeReg(base, S_SLV_REG7, 0xFFFFFFFF);			// CommandReady = 1
	writeReg(base, S_SLV_REG0, sharpCommand);		// Command(0) = 0 #
	//////////////////////////// Command Ready Disable ////////////////////////
	writeReg(base, S_SLV_REG7, 0x00000000);			// CommandReady = 0


	// Command(0) = 0
	writeReg(base, S_SLV_REG0, sharpCommand + 1);	// Command(0) = 1 #
	writeReg(base, S_SLV_REG0, 8);					// Command(0) = 0 4
	writeReg(base, S_SLV_REG0, 5);					// Command(0) = 1 2
	writeReg(base, S_SLV_REG0, 4); 					// Command(0) = 0 2
	writeReg(base, S_SLV_REG0, 5); 					// Command(0) = 1 2
	writeReg(base, S_SLV_REG0, 2); 					// Command(0) = 0 1
	writeReg(base, S_SLV_REG0, starCommand + 1); 	// Command(0) = 1 *
	writeReg(base, S_SLV_REG0, 2);					// Command(0) = 0 1
	writeReg(base, S_SLV_REG0, 5);					// Command(0) = 1 4
	//////////////////////////// Command Ready Enable ////////////////////////
	writeReg(base, S_SLV_REG7, 0xFFFFFFFF);			// CommandReady = 1
	writeReg(base, S_SLV_REG0, sharpCommand);		// Command(0) = 0 #
	//////////////////////////// Command Ready Disable ////////////////////////
	writeReg(base, S_SLV_REG7, 0x00000000);			// CommandReady = 0


    												// Command(0) = 0
    writeReg(base, S_SLV_REG0, sharpCommand + 1);	// Command(0) = 1 #
    writeReg(base, S_SLV_REG0, 10);					// Command(0) = 0 5
    writeReg(base, S_SLV_REG0, 5);					// Command(0) = 1 2
    writeReg(base, S_SLV_REG0, 4); 					// Command(0) = 0 2
    writeReg(base, S_SLV_REG0, 5); 					// Command(0) = 1 2
    writeReg(base, S_SLV_REG0, 2); 					// Command(0) = 0 1
    writeReg(base, S_SLV_REG0, starCommand + 1); 	// Command(0) = 1 *
    writeReg(base, S_SLV_REG0, 4);					// Command(0) = 0 2
    writeReg(base, S_SLV_REG0, 5);					// Command(0) = 1 4
    //////////////////////////// Command Ready Enable ////////////////////////
    writeReg(base, S_SLV_REG7, 0xFFFFFFFF);			// CommandReady = 1
    writeReg(base, S_SLV_REG0, sharpCommand);		// Command(0) = 0 #
    //////////////////////////// Command Ready Disable ////////////////////////
    writeReg(base, S_SLV_REG7, 0x00000000);			// CommandReady = 0



    /*writeReg(base, S_SLV_REG0, 10);				// 5	even
    writeReg(base, S_SLV_REG0, 9);				// 4	odd
    writeReg(base, S_SLV_REG0, 4);				// 2	even
    // #55231*12#
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 6);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 2);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, starCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 2);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0xFFFFFFFF);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0x00000000);
    writeReg(base, S_SLV_REG0, 0);

    // #22345*16#
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 6);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 8);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, starCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 2);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0xFFFFFFFF);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0x00000000);
    writeReg(base, S_SLV_REG0, 0);


    // #35245*25#
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 6);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 8);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, starCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 4);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, 10);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0xFFFFFFFF);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG0, sharpCommand);
    writeReg(base, S_SLV_REG0, 0);
    writeReg(base, S_SLV_REG1, 0x00000000);
    writeReg(base, S_SLV_REG0, 0); */

    /*int i;
    int loc_gen;
    srand(0);
    for(i = num_of_cars; i != 0; i = i - 1) {

    	// Push the sharp command :D
    	writeReg(base, S_SLV_REG0, sharpCommand);

    	// Push the digits of randNum one by one :)
    	int randNum = rand() % (plate_max - plate_min + 1) + plate_min;
    	int randLoc = rand() % (loc_max - loc_min + 1) + loc_min;

    	int j;
    	int digitizer = randNum;

    	for(j = 5; j != 0; j = j - 1) {
    		writeReg(base, S_SLV_REG0, digitizer % 10);
    		digitizer /= 10;
    	}

    	// Push the star command :)))
    	writeReg(base, S_SLV_REG0, starCommand);


    	// Push the parking location
    	writeReg(base, S_SLV_REG0, randLoc%10);
    	randLoc /= 10;
    	writeReg(base, S_SLV_REG0, randLoc%10);

    	// Command ready signal
    	writeReg(base, S_SLV_REG1, 0xFFFFFFFF);

    	// Push the final sharp command :D
    	writeReg(base, S_SLV_REG0, sharpCommand);

    	// Disable command ready signal
    	writeReg(base, S_SLV_REG1, 0x00000000);
    }
	*/
    // print("Hello World\n\r");

    /* ********************************** */
    /* ******************** ************** */
    /* END OF PARKING CONTROLLER INITIALIZATION */
    /* ********************************** */
    /* ********************************** */


    /* ********************************** */
    /* ********************************** */
    /* WATERING CONTROLLER INITIALIZATION */
    /* ********************************** */
    /* ********************************** */


    cleanup_platform();
    return 0;
}
