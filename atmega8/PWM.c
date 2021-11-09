#include <avr/io.h>					//Necesaria para registros
void PWM_Init(void){
	cli();							//IMPORTANTE: deshabilitar las interrupcionesa
	TCCR1A|=(1<<COM1A1);			//Setear OC1A en bottom
	TCCR1A|=(1<<COM1B1);			//Seter OC1B en bottom
	TCCR1A|=(1<<WGM11);				//Modo 14: PWM rapido, con tope en ICR1
	TCCR1B|=(1<<WGM12)|(1<<WGM13);	//Modo 14
	TCCR1B|=(1<<CS10);				//No preescalado
	OCR1A=0;						//Duty Cycle 0%-->OCR1A/ICR1*100 bomba
	OCR1B=0;						//Electrovalvulaa
	ICR1=31;						//Frecuencia 31250Hz-->1Mhz/(1*(1+ICR1))
	sei();
}

