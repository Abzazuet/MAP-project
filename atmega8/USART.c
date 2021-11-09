#include <avr/io.h>						//Necesaria para registros
#include <stdint.h> 					//Librerica para comunicacion uart
#include<string.h>						//Manipular cadenas caracteres
#include<stdio.h>						//Modificar entradas i salidas de texto
#include <stdlib.h>						//Concatenar registros de ADC
#define FOSC 1000000					//Definir frecuencia de oscilacion
#define BAUD 9600						//Baudios de comunicacion
#define MYUBRR FOSC/8/BAUD-1			//COnstante para establecer 9600 en nregistro, error de 0.2
char dato, buffer[30];					//Variable de que almacena dato recibido, variable que transmite dato generado

void USART_Init(unsigned int ubrr){		//Inicio comunicacion bluetooth
	cli();								//Desahbilitar interrupciones
	UBRRH=(unsigned char)(ubrr>>8);		//Establecer baudios en registro	
	UBRRL=(unsigned char)ubrr;
	UCSRB=(1<<RXEN) | (1<<TXEN);		//Habilitar Tx y Rx
	UCSRC=(1<<URSEL) | (3<<UCSZ0);		//Modo de transmision, 8 bits transferencia y 1 bit parada
	UCSRA=(1<<U2X);						//Preescalar para mayor velocidad
	sei();								//Habilitar interrupciones
}
void TransmitirBT (uint8_t data){		//Datos a transmitir en mismo formato que app movil
	while (!(UCSRA&(1<<UDRE)));			//Esperar a que el registro este vacio
	UDR=data;							//Poner datos a mandar en registro
}

unsigned char RecibirBT(void){			//Datos a recibir
	while (!(UCSRA & (1<<RXC)));		//Esperar a que todos los datos sean recibidos
	return UDR;							//Regresar el valor recibido para asignar en variable
}
void enviarMensaje(uint8_t valor){		//Normalizacion de mensaje a enviar	
	TransmitirBT(valor);				//Transmitir valor analogica
}

void charToUint8Send(char *cadena){		//Mandar mensaje caracter por caracter
	enviarMensaje(13);
	enviarMensaje(10);
	for (uint8_t i=0;i<strlen(cadena);i++){	
		uint8_t t=cadena[i];			//Seleccion el caracter de la cadena de texto
		enviarMensaje(t);				//Transmision de caracter seleccionado
	}
	enviarMensaje(13);
	enviarMensaje(10);
}
