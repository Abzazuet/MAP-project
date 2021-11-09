#Microcontroller:
MCU = atmega8

#Clock
CLOCK = 1000000

#Programmer
PROG = usbasp-clone

#Compiler options:
CFLAGS = -Wall -Os -mmcu=${MCU} -DF_CPU=${CLOCK}

#Filename and extension to compiled output
TARGET=main

#Source filename
SRCS = main.c

compile:
	#Compile from C code to elf file
	avr-gcc ${CFLAGS} -o ${TARGET}.elf ${SRCS}
	#Check elf file size
	avr-size --mcu=${MCU} --format=avr ${TARGET}.elf
	#Convert elf file to hex file to upload this one
	avr-objcopy -j .text -j .data -O ihex ${TARGET}.elf ${TARGET}.hex

flash:
	#Write the hex code to microcontroller
	avrdude -p ${MCU} -c ${PROG} -U flash:w:${TARGET}.hex:a
clean:
	rm ${TARGET}.elf ${TARGET}.hex
