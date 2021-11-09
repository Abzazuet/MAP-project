/*
 * MPU6050_res_define.h
 *
 * Created: 04/21/2016 22:47:10
 *  Author: Suraj
 */ 


#ifndef OXIMETRO_H_
#define OXIMETRO_H_

#include <avr/io.h>

#define INT_STATUS_1   0x00  // Which interrupts are tripped
#define INT_STATUS_2   0x01  // Which interrupts are tripped
#define INT_ENABLE_1   0x02  // Which interrupts are active
#define INT_ENABLE_2   0x03  // Which interrupts are active
#define FIFO_WR_PTR    0x04  // Where data is being written
#define OVRFLOW_CTR    0x05  // Number of lost samples
#define FIFO_RD_PTR    0x06  // Where to read from
#define FIFO_DATA      0x07  // Ouput data buffer
#define FIFO_CONFIG    0x08  // Control register
#define MODE_CONFIG    0x09  // Control register
#define SPO2_CONFIG    0x0A  // Oximetry settings
#define LED1_PA        0x0C  // Pulse width and power of LED 1
#define LED2_PA        0x0D  // Pulse width and power of LED 2
#define PILOT_PA       0x10  // Proximity mode led pulse amplitude
#define MODE_LED_CON   0x11  //Slot 1 2
#define MODE_LED_CON_2 0x12  //Slot 3 4
#define TEMP_INTG      0x1F  // Temperature value, whole number
#define TEMP_FRAC      0x20  // Temperature value, fraction
#define TEMP_CONFIG    0x21  // Temperature value, fraction
#define PROX_INT_THRESH 0x30 //Proximity interrupt threshold
#define REV_ID         0xFE  // Part revision
#define PART_ID        0xFF  // Part ID, normally 0x11
#define WRITE_ADDR     0xAE  //Write adress circuit	
#define READ_ADDR      0xAF  //Read address circuit
#endif /* OXIMETRO_H_ */
