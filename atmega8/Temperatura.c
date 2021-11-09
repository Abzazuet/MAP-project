#include <avr/io.h>
#include "Temperatura.h"

float celcius;
uint16_t read_reg(uint8_t a)
{
	uint16_t u16;
	I2C_Start(MLX90614_I2CADDR_w);
	I2C_Write(a);
	I2C_Repeated_Start(MLX90614_I2CADDR_r);
	u16 =   I2C_Read_Ack();                   
	u16 |=  (I2C_Read_Ack() << 8);
	I2C_Read_Nack();
    	I2C_Stop();
	return u16;
}

void TempC_Read(void)
{   
	uint16_t t;	
	 int data_low = 0;
	 int data_high = 0;
	 t=read_reg(MLX90614_TOBJ1);
	 data_low=t&0xff;
	 data_high=(t>>8)&0xff;
	 double tempFactor = 0.02; 
	 double tempData = 0; 
	 tempData = (double)(((data_high & 0x007F) << 8) + data_low);
	 tempData = (tempData * tempFactor)-0.01;
	 celcius = tempData - 273.15;
}

void TempCAmb(void)
{
	uint16_t t;
	int data_low = 0;
	int data_high = 0;
	t=read_reg(MLX90614_TA);
	data_low=t&0xff;
	data_high=(t>>8)&0xff;
	double tempFactor = 0.02;
	double tempData = 0;
	tempData = (double)(((data_high & 0x007F) << 8) + data_low);
	tempData = (tempData * tempFactor)-0.01;
	celcius = tempData - 273.15;
}
