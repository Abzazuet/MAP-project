#include <avr/io.h>					//Necesaria para registros
#include "MPU6050_res_define.h"		//Libreria del giroscopio

float Acc_x,Acc_y,Acc_z,Temperature,Gyro_x,Gyro_y,Gyro_z;
void Gyro_Init(){
	_delay_ms(150);		/* Power up time >100ms */
	I2C_Start_Wait(0xD0);	/* Start with device write address */
	I2C_Write(SMPLRT_DIV);	/* Write to sample rate register */
	I2C_Write(0x07);	/* 1KHz sample rate */
	I2C_Stop();

	I2C_Start_Wait(0xD0);
	I2C_Write(PWR_MGMT_1);	/* Write to power management register */
	I2C_Write(0x01);	/* X axis gyroscope reference frequency */
	I2C_Stop();

	I2C_Start_Wait(0xD0);
	I2C_Write(CONFIG);	/* Write to Configuration register */
	I2C_Write(0x00);	/* Fs = 8KHz */
	I2C_Stop();

	I2C_Start_Wait(0xD0);
	I2C_Write(GYRO_CONFIG);	/* Write to Gyro configuration register */
	I2C_Write(0x18);	/* Full scale range +/- 2000 degree/C */
	I2C_Stop();

	I2C_Start_Wait(0xD0);
	I2C_Write(INT_ENABLE);	/* Write to interrupt enable register */
	I2C_Write(0x01);
	I2C_Stop();
}
void MPU_Start_Loc(){
	I2C_Start_Wait(0xD0);	/* I2C start with device write address */
	I2C_Write(ACCEL_XOUT_H);/* Write start location address from where to read */
	I2C_Repeated_Start(0xD1);/* I2C start with device read address */				
}
void Read_RawValue()
{
	MPU_Start_Loc();									/* Read Gyro values */
	Acc_x = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/16384.0;
	Acc_y = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/16384.0;
	Acc_z = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/16384.0;
	Temperature = ((((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/340)+36.53;
	Gyro_x = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/16.4;
	Gyro_y = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack())/16.4;
	Gyro_z = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Nack())/16.4;
	I2C_Stop();
}
