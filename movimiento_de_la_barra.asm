;-----------MACROS----------------

%macro print 2			;Macro para imprimir datos a pantalla
	mov rax,1
        mov rdi,1
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro


%macro in_teclado 2     	;Macro para tomar datos del teclado
        mov rax,0
	mov rdi,0
	mov rsi,%1		;Argumento 1-variable para guardar datos
	mov rdx,%2		;Argumento 2-numero de bytes a guardar
	syscall
%endmacro


%macro mover 2			;Macro de posicionamiento del cursor
 	mov [vp+0],word 0x1b
        mov [vp+1],word 0xa5b
        mov [vp+2],word 2610
        mov [vp+3],word 2614
        mov [vp+4],word 0xa3b
        mov [vp+5],%1
        mov [vp+6],%2
        mov [vp+7],word 0xa48
        print vp,vplen
%endmacro

%macro movlateral 3

	;macro de calculo lateral para movimiento de bajada
        cmp %3,2659                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
        je .compder
	jmp .compararz
.compararz:
	cmp %3,2682
        je .compiz
	jmp _start.juego
.compiz:
	cmp %1,2608
	je .compiz1
	jmp .bajarizq
.compiz1:
	cmp %2,2610
	je _start.juego
	jmp .bajarizq 
.compder:
	cmp %1, 2612
	je .compder1
	jmp .bajarder

.compder1:
	cmp %2,2611
	je _start.juego
	jmp .bajarder

.bajarizq:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .decCsizq1
        dec %2
        jmp _primero.sal0
.decCsizq1:
        mov %2,2617
        cmp %1,2608
        je _primero.sal0
        dec %1
        jmp _primero.sal0

.bajarder:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .decCsder1
        inc %2
        jmp _primero.sal0
.decCsder1:
        mov %2,2608
        inc %1
%endmacro



;----------------------PROCEDIMIENTOS------------------------------------

Imp_limites:
	print screenset,screenset_len	;
	print techo,tamano_techo        ;imprimir techo
        print p_izq,tamano_p_izq        ;imprimir pared izquierda
        print p_der,tamano_p_der        ;imprimir pared derecha
        print piso,tamano_piso          ;imprimir piso
	ret


;-----------------------Variables  y mensajes del Juego--------------------

segment .data
	barra: db "---------"
	tamano_barra: equ $-barra
	nobarra:db 0x1b,"[26;f", "                                               "
	tam1: equ $-nobarra
	vfila: db "     "		;variable para almacenar codigos de ejecucion
        vfila_len: equ $-vfila

	vcolumna: db "     "		;variable para almacenar codigos de ejecucion

        vcolumna_len: equ $-vcolumna

	vp: db "        "			;variable de pruebas para almacenar codigos de ejecucion
	vplen: equ $-vp

	;Techo
	techo: db "-----------------------------------------------------"
	tamano_techo: equ $-techo

	;Piso
        piso: db 0x1b,"[30;1f","-----------------------------------------------------"
        tamano_piso: equ $-piso

	;Pared izquierda
	p_izq: db  0x1b,"[2;1f","|",0x1b,"[3;1f","|",0x1b,"[4;1f","|",0x1b,"[5;1f","|",0x1b,"[6;1f","|",0x1b,"[7;1f","|",0x1b,"[8;1f","|",0x1b,"[9;1f","|",0x1b,"[9;1f","|",0x1b,"[10;1f","|",0x1b,"[11;1f","|",0x1b,"[12;1f","|",0x1b,"[13;1f","|",0x1b,"[14;1f","|",0x1b,"[15;1f","|",0x1b,"[16;1f","|",0x1b,"[17;1f","|",0x1b,"[18;1f","|",0x1b,"[19;1f","|",0x1b,"[20;1f","|",0x1b,"[21;1f","|",0x1b,"[22;1f","|",0x1b,"[23;1f","|",0x1b,"[24;1f","|",0x1b,"[25;1f","|",0x1b,"[26;1f","|",0x1b,"[27;1f","|",0x1b,"[28;1f","|",0x1b,"[29;1f","|"
        tamano_p_izq: equ $-p_izq

	 ;Pared derecha
        p_der: db  0x1b,"[2;53f","|",0x1b,"[3;53f","|",0x1b,"[4;53f","|",0x1b,"[5;53f","|",0x1b,"[6;53f","|",0x1b,"[7;53f","|",0x1b,"[8;53f","|",0x1b,"[9;53f","|",0x1b,"[9;53f","|",0x1b,"[10;53f","|",0x1b,"[11;53f","|",0x1b,"[12;53f","|",0x1b,"[13;53f","|",0x1b,"[14;53f","|",0x1b,"[15;53f","|",0x1b,"[16;53f","|",0x1b,"[17;53f","|",0x1b,"[18;53f","|",0x1b,"[19;53f","|",0x1b,"[20;53f","|",0x1b,"[21;53f","|",0x1b,"[22;53f","|",0x1b,"[23;53f","|",0x1b,"[24;53f","|",0x1b,"[25;53f","|",0x1b,"[26;53f","|",0x1b,"[27;53f","|",0x1b,"[28;53f","|",0x1b,"[29;53f","|"
        tamano_p_der: equ $-p_der

	bola: db "+-+" 					;bola
	tamano_bola: equ $-bola

	centro: db 0x1b,"[16;19f"			;codigo de movimeinto de cursor para entrada de datos incial
	tamano_centro: equ $-centro

	setcursor: db 0x1b,"[1;1f"			;codigo de movimiento del cursor a esquina superior izquierda
	setcursor_len: equ $-setcursor

	screenset: db 0x1b,"[1;1f",0x1b,"[J"		;codigo de movimiento del cursor
        screenset_len: equ $-setcursor

	col: db 0x1b,"[?25l"				;codigo para esconder el cursor
	tamcol: equ $-col

	cal: db 0x1b,"[?25h"				;codigo paara mostrar el cursor
        tam: equ $-cal

	x: equ 1


segment .bss
	nombre: resb 10
	let: resb 2

;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:
	  ;inicializando registros
        mov r14,2610
        mov r15,2611


	;---------Creacion de limites del juego

	call Imp_limites				;imprime limites del juego
	mover r14,r15
	print barra,tamano_barra
.juego:
	in_teclado let,2
	mov r13,[let]
_primero:
	cmp r13, 2657
        je .fin
	movlateral r14,r15,r13	;"macro de calculo de movimiento lateral"

	jmp _start.juego
.sal0:
                      ;posicion del cursor final para imprimir"r8 y r9 fijos"
	print nobarra,tam1
	call Imp_limites
	mover r14,r15
        print barra,tamano_barra
	jmp _start.juego
.fin:
_segunda:
	mov rax,60
	mov rdi,0
	syscall


