#include <avr/io.h>						//Necesaria para registros
int adl, adcval;						//Valores de ADC
void ADC_Init(void){					//Configuracion inicial de ADC
	ADCSRA |=(1<<ADPS1) | (1<<ADPS0);	//Preescalar de 1MHz a 125Khz
}

char *lectura_Analogica(				//Seleccion de canal a leer
		unsigned int mux3, 
		unsigned int mux2, 
		unsigned int mux1, 
		unsigned int mux0){
	cli();								//Deshabilitar interrupciones
	ADCSRA &=~(1<<ADSC);				//Apagar las conversiones ADC
	ADCSRA &=~(1<<ADEN);				//Apagar el ADC
	adl=ADCL;							//Leer los primeros 8 para tener acceso a los otros dos
	adcval=(ADCH<<8) | adl;				//Leer los ultimos dos para tener permisos
	ADMUX=(mux3<<MUX3) | (mux2<<MUX2) |	
		(mux1<<MUX1) | (mux0<<MUX0);	//Seleccion de canal
	ADCSRA |=(1<<ADEN);					//Habilitar el ADC
	ADCSRA|=(1<<ADSC);					//Comenzar conversion
	while (!(ADCSRA &(1<<ADIF)));		//Hacer nada mientras convierte
	adl=ADCL;							//Lectura de los 8 primeros 
	adcval=(8<<ADCH)|adl;				//Lecutra de los 2 ultimos
	itoa(ADCW,buffer,10);				//Conversion de int a char
	sei();								//Habilitar interrupciones
	return buffer;						//Regresar el valor leido en char *
}
