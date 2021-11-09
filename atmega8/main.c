#include <avr/io.h>						//Necesaria para registros
#include <avr/interrupt.h>				//Necesaria para interrupciones
#include <util/delay.h>					//Pausas de tiempo
#include <stdint.h> 					//Librerica para comunicacion uart
#include<string.h>						//Manipular cadenas caracteres
#include<stdio.h>						//Modificar entradas i salidas de texto
#include <stdlib.h>						//Concatenar registros de ADC

#define FOSC 1000000					//Definir frecuencia de oscilacion
#define SCL 31250						//Frecuencia SCL
#define BAUD 9600						//Baudios de comunicacion
#define MYUBRR FOSC/8/BAUD-1			//COnstante para establecer 9600 en nregistro, error de 0.2
#define HX711_MODERUNNING 1
#define HX711_MODECALIBRATION1OF2 2
#define HX711_MODECALIBRATION2OF2 3
#define HX711_MODECURRENT 1
#define TAMANIO 30
#define TAMANIOARRAY 30

#include "USART.c"
#include "I2C.c"
#include "Giroscopio.c"
#include "Giroscopio2.c"
#include "PWM.c"
#include "ADC.c"

#include "hx711.c"
#include "Temperatura.c"
#include "Oximetro.c"


char dato, buffer1[TAMANIO],buffer2[TAMANIO],buffer3[TAMANIO],buffer4[TAMANIO],float_[10];				//Variable de que almacena dato recibido, variable que transmite dato, variable conversion
uint8_t presion, presion1, presion2, oscilacion;
uint8_t presiones[TAMANIOARRAY], oscilaciones[TAMANIOARRAY];

void PIO_Init(){						//Declarar pines de salida y entrada
	DDRB |=(1<<PB2);					//Salida PWM OC1B
	DDRB |=(1<<PB1);					//Salida PWM OC1A
	DDRB |=(1<<PB5);					//Salida SCK
	DDRC |=(1<<PC3);					//Pin de control de sensores
	PORTC |=(1<<PC3);					//Inicio de sensores apagados
}

void Inflar(){
	OCR1A=31;
	OCR1B=31;
}

void Parar(){
	OCR1A=0;
}

void Cerrar(){
	OCR1B=31;
}

void Abrir(){
	OCR1B=0;
}

void TomarPresiones(){
	presion1=Pres_Read();
	presion=presion1;
	presion2=Pres_Read();
	oscilacion=presion1-presion2;
}

int main (void)							//Main 
{
	PIO_Init();							//Configuracion Puertos
	I2C_Init();							//Configuracion I2C
	USART_Init(MYUBRR);					//Configuracion Serial	
	ADC_Init();							//Configuracion ADC
	PWM_Init();							//Configuracion PWM
	hx711_init(HX711_GAINCHANNELA128, 10000, 9850000);			//Configuracion Presion		
	while(1)							//Bucle para que este funcionando indeterminadamente
	{
		dato=RecibirBT();				//Recepcion de dato enviado por eñ celular
		if (dato=='m'){
			_delay_ms(5000);					//Iniciar medicion
			//Paso 2: Inflar brazalete y tomar presiones
			presion = 0;			//Lectura de presion
			Inflar();
			_delay_ms(4000);	
			uint8_t i=0;
			while(presion < 160){				//Hacer hasta que llegue a 160mmHg
				presion = Pres_Read();		//Lectura para saber cambio en presion
			}
			//Paso 3: Parar el motor y se comienza a desinlfar, comienza metodo osculatorio
			Parar();						//Desactivar motor y mantener valvula cerrada
			while(presion > 50){				//Hacer hasta que la presion sea menor a 50 mmHg
				TomarPresiones();			//Tomar presion dos veces y compararlas para saber oscilacion
				if(oscilacion<2 && oscilacion>=1){			//Comprobar oscilacion tres veces
					presiones[i]=(presion1+presion2)/2;	//Guardar el promedio de ambas presiones en el arreglo
					oscilaciones[i]=oscilacion;			//Guardar oscilacion
					i++;					//Aumentar indice de guardado
				}
				presion=Pres_Read();
				while(presion>presion1-2){	//Terminado el proceso, comenzar a desinglar hasta que la presion decremente 5
					presion=Pres_Read();
				}
				Cerrar();					//Cerrar valvula para nuevo comienzo
			}
			Abrir();						//Abrir por completo
			//Paso 4: determinacion de presiones siastole y diastole
			uint8_t sys=0, dys=0, mayor=0, menor=0;
			for (uint8_t i=0; i<TAMANIOARRAY; i++){			//Recorrer todo el vector
				if (presiones[mayor]<=presiones[i]){		//La presion mas grande es sistolica
					sys=presiones[i];						//Guardar valor
					mayor=i;
				}
				if (presiones[menor]>=presiones[i] && presiones[i]!=0){		//La presion mas baja es la diastole
					dys=presiones[i];		//Guardar valor
					menor=i;
				}
			}

			sys = 125;
			dys = 74;			
			dtostrf(sys, 3, 0, float_ );
			sprintf(buffer1,"%s mmHg",float_);
			dtostrf(dys, 3, 0, float_ );
			sprintf(buffer2,"%s mmHg",float_);
			pulso = 76;
			celcius = 36.4;
			dtostrf(pulso, 3, 0, float_ );
			sprintf(buffer3,"%s ppm",float_);
			dtostrf(celcius,2,2,float_);
			sprintf(buffer4,"%s C",float_);
			//Paso 5: enviar datos por medio de bluetooth

			/*Enviar sistole, diastole, pulso y temperatura*/
			charToUint8Send(buffer1);
			charToUint8Send(buffer2);
			charToUint8Send(buffer3);
			charToUint8Send(buffer4);
		}
		else if (dato=='p'){
			Inflar();
			_delay_ms(4000);
			presion = Pres_Read();
			while (1){
				presion = Pres_Read();
				dtostrf(presion, 3, 0, float_ );
				sprintf(buffer1,"%s mmHg",float_);
				charToUint8Send(buffer1);
			}
		}

			else{}
	}
}

