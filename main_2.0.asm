.include "m328pdef.inc"

;
; displayCalculator.asm
;
; Created: 12/21/2018 3:22:07 PM
; Author : David Jerman
;

.equ part_1 = 3
.equ part_2 = 2
.equ part_3 = 1
.equ part_4 = 0
.equ seg_A = 4
.equ seg_B = 5
;port b - digital
.equ seg_C = 2
.equ seg_D = 3
.equ seg_E = 4
.equ seg_F = 5
.equ seg_G = 6
.equ seg_dot = 7
;port d - digital
.equ buzzer = 0
.equ but_1 = 1
.equ but_2 = 2
.equ but_3 = 3
.equ but_4 = 4
;port c - analog
	
; za uporabo najprej klièite proceduro setupUART
.equ baudrate = 9600

.macro print
.cseg
	push r16	; pazimo, da ne bi sluèajno spremenili r16, ZH, ZL
	push ZHd
	push ZL

	ldi ZH, high(@0 << 1)
	ldi ZL, low(@0 << 1)
	call printstring

	pop ZL
	pop ZH
	pop r16				; vrnemo v r16 prvotno vrednost
.endmacro

.macro turnON
	cbi portb, (@0)
.endmacro

.macro turnOFF
	sbi portb, part_4
	sbi portb, part_3
	sbi portb, part_2
	sbi portb, part_1
.endmacro

.macro clear
    cbi portb, seg_A
    cbi portd, seg_B
    cbi portd, seg_C
    cbi portd, seg_D
    cbi portd, seg_E
    cbi portb, seg_F
    cbi portd, seg_G
	cbi portd, seg_dot
.endmacro

;subroutine call

	call setup
	call setupUART
	turnOFF
	rjmp loop

;end

loop:
;	call get_char
;	call send_char
	call input
	rjmp loop

input:
	call get_char
	cpi r16, 0x31
	breq val_1
	rjmp next_1
val_1:
	call save
	ret
next_1:
	cpi r16, 0x32
	breq val_2
	rjmp next_2
val_2:
	call save
	ret
next_2:
	cpi r16, 0x33
	breq val_3
	rjmp next_3
val_3:
	call save
	ret
next_3:
	cpi r16, 0x34
	breq val_4
	rjmp next_4
val_4:
	call save
	ret
next_4:
	cpi r16, 0x35
	breq val_5
	rjmp next_5
val_5:
	call save
	ret
next_5:
	cpi r16, 0x36
	breq val_6
	rjmp next_6
val_6:
	call save
	ret
next_6:
	cpi r16, 0x37
	breq val_7
	rjmp next_7
val_7:
	call save
	ret
next_7:
	cpi r16, 0x38
	breq val_8
	rjmp next_8
val_8:
	call save
	ret
next_8:
	cpi r16, 0x39
	breq val_9
	rjmp next_9
val_9:
	call save
	ret
next_9:
	cpi r16, 0x30
	breq val_0
	rjmp next_0
val_0:
	call save
	ret
next_0:
	cpi r16, 0x2d
	breq val_minus
	rjmp next_minus
val_minus:
	call minus
	ret
next_minus:
	cpi r16, 0x2a
	breq val_multi
	rjmp next_multi
val_multi:
	call multi
	ret
next_multi:
	cpi r16, 0x43
	breq val_reset
	cpi r16, 0x63
	breq val_reset
	rjmp next_reset
val_reset:
	call reset
	ret
next_reset:
	cpi r16, 0x2b
	breq val_plus
	rjmp next_1
val_plus:
	call plus
	ret
next_plus:
	ret

reset:
	clr r16
	clr r17
	clr r18
	clr r19
	clr r20
	clr r21
	clr r0
	clr r1
	ret
save:
	push r16
	call sift
	pop r16
	subi r16, 0x30
	mov r20, r16
	ret
plus:
	clr r16
	call get_char
	call sift
	subi r16, 0x30
	add r20, r16
	mov r16, r20
	ldi r21, 0x30
	add r16, r21
	sbi portc, buzzer
	push r16
	call delay_500ms
	cbi portc, buzzer
	pop r16
	call send_char
	call sift
	ret

minus:
	clr r16
	call get_char
	call sift
	subi r16, 0x30
	sub r20, r16
	mov r16, r20
	ldi r21, 0x30
	add r16, r21
	sbi portc, buzzer
	push r16
	call delay_500ms
	cbi portc, buzzer
	pop r16
	call send_char
	call sift
	ret

multi:
	clr r16
	call get_char
	push r16
	call sift
	pop r16
	subi r16, 0x30
	mul r16, r20
	mov r20, r0
	mov r16, r20
	ldi r21, 0x30
	add r16, r21
	sbi portc, buzzer
	push r16
	call delay_500ms
	cbi portc, buzzer
	pop r16
	call send_char
	call sift
	ret

setup:
	call clearReg
	ldi r16, 0b11111100
	out ddrd, r16
	ldi r16, 0b00111111
	out ddrb, r16
	ldi r16, 0b10000001
	out ddrc, r16
	clr r16
	out portb, r16
	out portc, r16
	out portd, r16
	clear
	ret

clearReg:
	clr r0
	clr r1
	clr r2
	clr r3
	clr r4
	clr r5
	clr r6
	clr r7
	clr r8
	clr r9
	clr r10
	clr r11
	clr r12
	clr r13
	clr r14
	clr r15
	clr r16
	clr r17
	clr r18
	clr r19
	clr r20
	clr r21
	clr r22
	clr r23
	clr r24
	clr r25
	clr r26
	clr r27
	clr r28
	clr r29
	clr r30
	clr r31
	ret

sift:
	cpi r16, 0x31
	breq val_11
	rjmp next_11
val_11:
	call print_1
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_11:
	cpi r16, 0x32
	breq val_12
	rjmp next_12
val_12:
	call print_2
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_12:
	cpi r16, 0x33
	breq val_13
	rjmp next_13
val_13:
	call print_3
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_13:
	cpi r16, 0x34
	breq val_14
	rjmp next_14
val_14:
	call print_4
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_14:
	cpi r16, 0x35
	breq val_15
	rjmp next_15
val_15:
	call print_5
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_15:
	cpi r16, 0x36
	breq val_16
	rjmp next_16
val_16:
	call print_6
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_16:
	cpi r16, 0x37
	breq val_17
	rjmp next_17
val_17:
	call print_7
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_17:
	cpi r16, 0x38
	breq val_18
	rjmp next_18
val_18:
	call print_8
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_18:
	cpi r16, 0x39
	breq val_19
	rjmp next_19
val_19:
	call print_9
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_19:
	cpi r16, 0x30
	breq val_10
	rjmp next_10
val_10:
	call print_0
	turnON part_1
	call delay_500ms
	turnOFF
	ret
next_10:
	call convert
	ret

convert:
	mov r16, r20
	push r20
	call div10_8bit
	ldi r21, 0x30
	add r16, r21
	mov r20, r16
	add r17, r21
	mov r16, r20
	call sift
	mov r16, r17
	call sift
	pop r20
	ret

print_1:
	cbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	cbi portd, seg_D
	cbi portd, seg_E
	cbi portd, seg_F
	cbi portd, seg_G
	cbi portd, seg_dot
	ret

print_2:
	sbi portb, seg_A
	sbi portb, seg_B
	cbi portd, seg_C
	sbi portd, seg_D
	sbi portd, seg_E
	cbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_3:
	sbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	cbi portd, seg_E
	cbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_4:
	cbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	cbi portd, seg_D
	cbi portd, seg_E
	sbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_5:
	sbi portb, seg_A
	cbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	cbi portd, seg_E
	sbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_6:
	sbi portb, seg_A
	cbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	sbi portd, seg_E
	sbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_7:
	sbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	cbi portd, seg_D
	cbi portd, seg_E
	cbi portd, seg_F
	cbi portd, seg_G
	cbi portd, seg_dot
	ret

print_8:
	sbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	sbi portd, seg_E
	sbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_9:
	sbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	cbi portd, seg_E
	sbi portd, seg_F
	sbi portd, seg_G
	cbi portd, seg_dot
	ret

print_0:
	sbi portb, seg_A
	sbi portb, seg_B
	sbi portd, seg_C
	sbi portd, seg_D
	sbi portd, seg_E
	sbi portd, seg_F
	cbi portd, seg_G
	cbi portd, seg_dot
	ret

print_dot:
	sbi portd, seg_dot
	ret

flash_500ms:
	turnON part_1
	call delay_500ms
	turnOFF
	ret

delay_500ms:
	ldi  r18, 41
    ldi  r19, 150
    ldi  r22, 128
L1: dec  r22
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret

delay_2ms:
	ldi  r18, 42
    ldi  r19, 142
L2: dec  r19
    brne L2
    dec  r18
    brne L2
    nop

;****************************************************************************************************
;  printstring
;  Z kaže na zaèetek niza v PROGRAMskem pomnilniku (CSEG)
;****************************************************************************************************

				.cseg
printstring:	lpm r16, Z+			; naloži znak in premakni kazalec Z naprej
				cpi r16, 0			; ali je konec niza (niz se konèa z NULL)
				breq stopprinting	; da, skoèi na konec
				call send_char		; ne, pošlji znak
				rjmp printstring	; na vrsti je naslednji znak, skoèi tja
stopprinting:	ret				                

;****************************************************************************************************
;  poslji_hex
;  r16 - stevilka, ki jo zelimo izpisati na UART 
;****************************************************************************************************
				; v r16 damo vrednost, na UART dobimo dve ASCII šestnajstiški števki  (0xFF --> 'FF')
send_hex:		push r16			; kako pretvorimo vrednosti od 0 do 9 v '0' do '9'?
									; kaj pa od 10 do 15 v 'A' do 'F'?
				swap r16			; zamenjamo visoki in nizki del byta
				andi r16, 0x0F		; zanimajo nas samo štirje biti

				cpi r16, 0x0A		; primerjaj z deset
				brcs manjsa_od_10_1
				subi r16, -7		; èe ni manjša od deset, je osnova 'A', r16 je vsaj 10, prištejemo še '0', je potem 58, manjka še 7
manjsa_od_10_1:						; sicer je osnova '0', prištejemo 48 ('0')
				subi r16, -48
				call send_char

				pop r16
				andi r16, 0x0F		; zanimajo nas samo štirje biti, tokrat so to spodnji štirje

				cpi r16, 0x0A		; primerjaj z deset
				brcs manjsa_od_10_2
				subi r16, -7		; èe ni manjša od deset, je osnova 'A', r16 je vsaj 10, prištejemo še '0', je potem 58, manjka še 7
manjsa_od_10_2:						; sicer je osnova '0', prištejemo 48 ('0')
				subi r16, -48
				call send_char

				ret
				
;****************************************************************************************************
;  setupUART
;  pripravi serijska vrata na prenos podatkov, 9600 baud
;
;****************************************************************************************************
setupUART:		; pripravi serijska vrata
				; ne sekirajte se, èe še ne veste, èesa vsega ne poznate

				; 
				; vrednosti not npr. TXEN0 in UBRR0H dobimo v datoteki m328pdef.inc 
				; in so lahko druga?ne glede na model mikrokontrolerja

				; 9600 baudov @ 16Mhz
				; v IO register UBBR0 naložimo baudrate / 8

				ldi r16, 0x67
				ldi r17, 0x00
				sts UBRR0L, r16
				sts UBRR0H, r17

				; RXEN0 = 4, TXEN0 = 3, znak << pomeni pomik v levo, >> desno
				; 1<<TXEN0 = 0x40 (0b00000001 --> 0b00001000)
				ldi r16, (1<<RXEN0)|(1<<TXEN0) ; vkljuèimo bita za sprejem in za oddajo - pina dobita RX in TX funkcijo
				sts UCSR0B,r16

				ldi r16, (3<<UCSZ00) ; 8 bitov, 1 stop bit
				sts UCSR0C,r16
				clr r16
				sts UCSR0A, r16

				ret

;****************************************************************************************************
; procedura pošlje znak v r16 po UART
;
;****************************************************************************************************
				; poèakajmo, da bo oddajni vmesni pomnilnik na voljo
send_char:		; takrat bo bit UDRE0 enak 1
				push r16				; spravi r16 na sklad, ker bomo po njem pacali 
poskusi_poslati:
				lds r16, UCSR0A
				sbrs r16,UDRE0			; preskoèi naslednjo instrukcijo, èe je ta bit 1
				rjmp poskusi_poslati	; bit še ni 1, skoèi nazaj na preverjanje
									
				pop r16					; daj podatek (r16) v vmesni pomnilnik za UART, 
				sts UDR0,r16	
				ret

;****************************************************************************************************
; procedura sprejme znak  po UART v r16
;
;****************************************************************************************************

get_char:		; poèakajmo, da bo znak prispel, bit RXC0 bo takrat 1
				lds r16, UCSR0A
				sbrs r16, RXC0
				rjmp get_char

				lds r16, UDR0
vrnise:			ret

;****************************************************************************************************
;  8-bitno deljenje z 10
;  deli r16 z 10, r17 je ostanek
;
;****************************************************************************************************

div10_8bit:		push r0
				push r1
				push r16
				inc r16			; some magic
				brne dobro
				dec r16
dobro:			ldi r17, 51		; more magic
				mul r16, r17	; mind blown
				lsr r1			; r1 = r16/10 (celi del, seveda)

				mov r16, r1
				ldi r17, 10
				mul r1, r17
				pop r17
				sub r17, r0		; ostanek
				pop r1
				pop r0				
				ret				; confused?



;****************************************************************************************************
;  izpiši 8-bitno število kot ascii
;  r16 število
;  r17 mest
;
;****************************************************************************************************

print_8bit_base10:
				push r18			; pacamo po r18
				mov r18, r17
				clr r17
				push r17
naslednja_cifra:					; najprej izracunamo stevke in jih damo na stack
				call div10_8bit		; r16 = r16 / 10, r17 je ostanek
				ori r17, 0x30		; naredimo iz njega ASCII cifro (npr. 2 => 0x32 = '2')
				push r17			; ker je ostanke potrebno izpisati v obratnem vrstnem redu
				dec r18				; jih damo na sklad, vendar samo toliko cifer max, kot je bilo podano
				brne naslednja_cifra	; èe imamo dovolj števk, nehamo
							
izpisi_cifre:   pop r16
				or r16, r16			; zadnja cifra je ascii NULL (=0x00)
				breq konec_izpisa
				call send_char
				rjmp izpisi_cifre

konec_izpisa:	pop r18				; popravimo r18 nazaj...
				ret

dump_registers:						; grda procedura... ampak deluje.. :p
				push r31
				push r30
				push r29
				push r28
				push r27
				push r26
				push r25
				push r24
				push r23
				push r22
				push r21
				push r20
				push r19
				push r18
				push r17
				push r16
				push r15
				push r14
				push r13
				push r12
				push r11
				push r10
				push r9
				push r8
				push r7
				push r6
				push r5
				push r4				
				push r3
				push r2
				push r1
				push r0

				in ZH, SPH
				in ZL, SPL
				ldi r18, 32		; 32 registrov na skladu
				clr r19			; števec registrov
				ld r16, Z+		; vrednost na vrhu skladu nima pomena
naslednji_register:
				ldi r16, 'r'
				call send_char

				mov r16, r19
				inc r19
				ldi r17, 2
				call print_8bit_base10

				ldi r16, ':'
				call send_char

				ld r16, Z+
				call send_hex
				ldi r16,0x20
				call send_char
				call send_char

				mov r16, r19
				andi r16, 0x07
				brne no_new_line

				ldi r16, 0x0d
				call send_char
				ldi r16, 0x0a
				call send_char
				call send_char

no_new_line:	dec r18
				brne naslednji_register

				pop r0
				pop r1
				pop r2
				pop r3
				pop r4
				pop r5
				pop r6
				pop r7
				pop r8
				pop r9
				pop r10
				pop r11
				pop r12
				pop r13
				pop r14
				pop r15
				pop r16
				pop r17
				pop r18
				pop r19
				pop r20
				pop r21
				pop r22
				pop r23
				pop r24
				pop r25
				pop r26
				pop r27
				pop r28
				pop r29
				pop r30
				pop r31

				ret				; we are done here

				.dseg
StackHI:		.byte 1
StackLO:		.byte 1