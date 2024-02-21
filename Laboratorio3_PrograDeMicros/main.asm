//*****************************************************************************
// Universidad del Valle de Guatemala
// IE2023 Programacion de Microcontroladores
// Proyecto: Laboratorio3
// Descripcion: Contador binario de 4 bits
// Hardware: ATMega328P
// Created: 14/02/2024
// Author : Mateo
//*****************************************************************************
// ENCABEZADO
//*****************************************************************************

.INCLUDE "M328PDEF.inc"
.CSEG
.ORG 0x00
jmp MAIN
.org 0x0008
jmp Interrupcion
.org 0x0020
jmp Int_T0

//*****************************************************************************
// STACK POINTER 
//*****************************************************************************
MAIN:
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R17, HIGH(RAMEND)
	OUT SPH, R17 



//*****************************************************************************
// CONFIGURACION
//*****************************************************************************

Setup:
LDI R16, 0x00
STS UCSR0B, R16

LDI R16, 0b0000_0000
OUT DDRC, R16
LDI R16, 0b1111_1111
OUT PORTC, R16
OUT DDRB, R16
OUT DDRD, R16
OUT PORTD, R16 
ClR R16

LDI R16, (1<<PCIE1)
STS PCICR, R16

LDI	R16, (1<<PCINT8) | (1<<PCINT9)
STS PCMSK1, R16
LDI R16, 0b0000_0010
STS PCIFR, R16

LDI R16, 0b0000_0001
STS TIMSK0, R16

LDI R19, 0b0000_0000
LDI R26, 0X00

LDI R17, 0b0000_0000
LDI R24, 0x00
SEI

LDI R21, 0XFF
LDI R22, 0XFF
LDI R23, 0b0000_0111
CALL Timer0

LDI ZH, HIGH(TABLA7SEG<<1)
LDI ZL, LOW(TABLA7SEG<<1)
LPM R20, Z // TABLA
LPM R25, Z

Loop:

SBI PORTB, PB5
OUT PORTD, R20
CALL DELAY2
CBI PORTB, PB5

SBI PORTB, PB4
OUT PORTD, R22
OUT PORTD, R25
CALL DELAY2
CBI PORTB, PB4


RJMP LOOP

//*****************************************************************************
// Subrutina
//*****************************************************************************
Interrupcion:
CALL DELAY
IN R18, PINC
SBRC R18, 0
DEC R17
SBRC R18, 1
INC R17
OUT PORTB, R17
RETI



Delay:
DEC R21 
CPI R21, 0b0000_0000 
BRNE Delay 
LDI R21, 0b1111_1111
DEC R22
CPI R22, 0b0000_0000
BRNE DELAY
LDI R22, 0b1111_1111
DEC R23 
CPI R23, 0b0000_0000
BRNE DELAY
LDI R23, 0b0000_0111 // Delay
RET


Timer0:
LDI R16, 0b0000_0011
OUT TCCR0A, R16

LDI R16, 0b0000_0101
OUT TCCR0B, R16

LDI R16, 100
OUT TCNT0, R16

RET

Int_T0:
LDI R16, 100
OUT TCNT0, R16
INC R19
CPI R19, 100
BREQ Muestra
RETI 

Muestra:
INC R24
CPI R24, 10
BREQ REINICIO
CLR R19
INC ZL
LPM R20, Z

RETI

REINICIO:
INC R26
CPI R26, 6
BREQ REINICIO2
CLR R24
LDI ZH, HIGH(TABLA7SEG<<1)
LDI ZL, LOW(TABLA7SEG<<1)
LPM R20, Z // TABLA
ADD ZL, R26
LPM R25, Z
LDI ZL, LOW(TABLA7SEG<<1)

RETI


DELAY2:
DEC R21 
CPI R21, 0b0000_0000 
BRNE Delay2 
LDI R21, 0b1111_1111
RET

REINICIO2:
CLR R24
CLR R26
LDI ZH, HIGH(TABLA7SEG<<1)
LDI ZL, LOW(TABLA7SEG<<1)
LPM R20, Z
LPM R25, Z
RETI 


//*****************************************************************************
// Tabla de Valores 
//*****************************************************************************
TABLA7SEG: .DB 0b1100_0000, 0b1111_1001, 0b1010_0100, 0b0011_0000, 0b1001_1001, 0b1001_0010, 0b1000_0010, 0b1111_1000, 0b1000_0000, 0b1001_0000, 0b1000_1000, 0b1000_0011, 0b1100_0110, 0b1010_0001, 0b1000_0110, 0b1000_1110


