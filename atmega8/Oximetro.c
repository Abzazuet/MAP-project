#include <avr/io.h>					//Necesaria para registros
#include "Oximetro.h"				//Libreria del giroscopio
long int pulso;
void Oxi_Init(){
	_delay_ms(150);					/* Power up time >100ms */
	I2C_Start_Wait(WRITE_ADDR);		/* Start with device write address */
	I2C_Write(FIFO_CONFIG);			/* Write to first in first out configuration */
	I2C_Write(0xB0);				/* Set 32 sample avergae, clear when it reaches top, no empty data */
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(MODE_CONFIG);			/*COnfig mode*/
	I2C_Write(0x02);				/*Heart rate mode*/
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(SPO2_CONFIG);
	I2C_Write(0x18);				/*HR mode, 69uS-> pulse width, 1600->sampes ps*/
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);	
	I2C_Write(LED1_PA);			/*Intensidad de ledd rojo*/
	I2C_Write(0x04);			/*.2mA*/
	I2C_Stop();
}
void Oxi_Start_Loc(){
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(FIFO_WR_PTR);
	I2C_Write(0x3F);
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(OVRFLOW_CTR);
	I2C_Write(0x00);
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(FIFO_RD_PTR);
	I2C_Write(0x00);
	I2C_Stop();

	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(FIFO_DATA);
	I2C_Write(0x00);
	I2C_Stop();
	
	I2C_Start_Wait(WRITE_ADDR);
	I2C_Write(FIFO_DATA);
	I2C_Repeated_Start(READ_ADDR);
}
void Oxi_Read(){
	Oxi_Start_Loc();
	pulso = (((long int)I2C_Read_Ack()<<15) | (int)I2C_Read_Nack());
	I2C_Stop();
}

