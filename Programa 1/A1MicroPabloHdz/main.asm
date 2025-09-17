;
; A1MicroPabloHdz.asm
; Facultad de Estudios Superiores Cuatitlán
; Ingerniería en Telecomunicaciones Sistemas y Electrónica
; Created: 9/15/2025 
; Author : Pablo Hernandez
; Microcontroladores Actvidad 1

.cseg 
.org 0x00
.def temp = r16
.def  d_inner = r17
.def d_outer = r18

	ldi temp,high(RAMEND) //Obtiene byte alto
	out SPH,temp
	ldi temp,low(RAMEND) //Obtiene byte bajo
	out SPL,temp 

	//Definicion de los puertos PB
	cbi DDRB, PORTB0	//PB0 como entrada
	sbi	PORTB,PORTB0	//Activa resistencia pull up
	cbi DDRB,PORTB1	//PB1 como entrada
	sbi PORTB,PORTB1	//Activa resistencia pull up
	sbi	DDRB,PORTB5	//PB5 como salida

;Programa principal
start:
	in temp,PINB	//lee el estado del puerto
	andi temp,0b00000011	//mask para aislar las entradas
	
	cpi temp,0x00	//si temp=0x00, salta a fr_5k
	breq fr_5k			

	cpi temp,0x01	//si temp=0x01, salta a fr_5k
	breq fr_25k

	cpi temp,0x02	//si temp=0x02, salta a fr_5k
	breq fr_60k

	cpi temp,0x03	//si temp=0x03, salta a fr_5k
	breq fr_80k

	rjmp fr_5k	//si no coincide con ninguno, por defecto es 00

/******************************
frecuencias de encendido del led
*******************************/
fr_5k:
	sbi	PORTB,PORTB5	//Enciende bit, 2 ciclos de reloj
	rcall delay5k	//espera, 3 ciclos de reloj
	cbi	PORTB,PORTB5	//apaga bit
	rcall delay5k	//espera
	rjmp start		

fr_25k:
	sbi	PORTB,PORTB5	//Enciende bit	
	rcall delay25k	//espera
	cbi	PORTB,PORTB5	//apaga bit
	rcall delay25k	//espera
	rjmp start

fr_60k:
	sbi	PORTB,PORTB5	//Enciende bit	
	rcall delay60k	//espera
	cbi	PORTB,PORTB5	//apaga bit
	rcall delay60k	//espera
	rjmp start

fr_80k:
	sbi	PORTB,PORTB5	//Enciende bit	
	rcall delay80k	//espera
	cbi	PORTB,PORTB5	//apaga bit
	rcall delay80k
	rjmp start
	
/********************
subrutinas de delay
Fcpu=12 MHz
Para un ciclo de trabajo del 50% T=1/(2*F)
*********************/
delay5k: ; Necesita ~1195 ciclos
    ldi     d_outer, 18
outer_5k:
    ldi     d_inner, 22
inner_5k:
    dec     d_inner
    brne    inner_5k
    dec     d_outer
    brne    outer_5k
    ret

delay25k: ; Necesita ~235 ciclos
    ldi     d_inner, 77
loop_25k:
    dec     d_inner
    brne    loop_25k
    ret

delay60k: ; Necesita ~95 ciclos
    ldi     d_inner, 30
loop_60k:
    dec     d_inner
    brne    loop_60k
    ret

delay80k: ; Necesita ~70 ciclos
    ldi     d_inner, 22
loop_80k:
    dec     d_inner
    brne    loop_80k
    ret


