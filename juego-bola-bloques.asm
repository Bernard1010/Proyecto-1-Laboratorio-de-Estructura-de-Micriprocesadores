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


%macro ir 4			;Macro de posicionamiento del cursor
 	mov [vp+0],word 0x1b
        mov [vp+1],word 0xa5b
        mov [vp+2],%1
        mov [vp+3],%2
        mov [vp+4],word 0xa3b
        mov [vp+5],%3
        mov [vp+6],%4
        mov [vp+7],word 0xa48
        print vp,vplen
%endmacro

%macro irs 4                     ;Macro de posicionamiento del cursor
        mov [vp+0],word 0x1b
        mov [vp+1],word 0xa5b
        mov [vp+2],word %1
        mov [vp+3],word %2
        mov [vp+4],word 0xa3b
        mov [vp+5],word %3
        mov [vp+6],word %4
        mov [vp+7],word 0xa48
        print vp,vplen
%endmacro

%macro movlateralBAJ 3
	mov r13,%3
	cmp r13,1                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
        je .bajarder
        jmp .bajarizq
.bajarizq:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .decCsizq1
        dec %2
        jmp .movlateralfull1
.decCsizq1:
        mov %2,2617
        cmp %1,2608
        je .movlateralfull1
        dec %1
        jmp .movlateralfull1

.bajarder:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .decCsder1
        inc %2
        jmp .movlateralfull1
.decCsder1:
        mov %2,2608
        inc %1
%endmacro

%macro movlateralSUB 3			;macro de calculo lateral para movimiento de bajada 
	mov r13,%3
	cmp r13,1                        ;comparacion de estado de r13 para saber a donde moverse
        je .subirder
        jmp .subirizq
.subirizq:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .decCsizq2
        dec %2
        jmp .movlateralfull2
.decCsizq2:
        mov %2,2617
        cmp %1,2608
        je .movlateralfull2
        dec %1
        jmp .movlateralfull2
.subirder:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .decCsder2
        inc %2
        jmp .movlateralfull2
.decCsder2:
        mov %2,2608
        inc %1
%endmacro


%macro compchoque7 6
        cmp word %5,0			;comprobacion del estado del bloque -destruido o no destruido
        je .nochoque			; si es 0 el estado no debe ocurrir colision con bola

        mov r13,15
        mov r14,%3
        mov r15,%4
.c7:
        cmp %2,r15
        je .verifdecenas7
        jmp .aumdatos7
.verifdecenas7:
        cmp %1,r14
        je .destruir7

.aumdatos7:
        cmp r15,2617
        je .aumdec7
        inc r15
        jmp .verc7

.aumdec7:
        mov r15,2608
        inc r14
.verc7:
        dec r13
        cmp r13,0
        jne .c7
	jmp .%6
.destruir7:
	mov %5,word 0

%endmacro


%macro compchoque8 6
        cmp word %5,0			;comprobacion del estado del bloque -destruido o no destruido
        je .nochoque			; si es 0 el estado no debe ocurrir colision con bola

        mov r13,15
        mov r14,%3
        mov r15,%4
.c8:
        cmp %2,r15
        je .verifdecenas8
        jmp .aumdatos8
.verifdecenas8:
        cmp %1,r14
        je .destruir8

.aumdatos8:
        cmp r15,2617
        je .aumdec8
        inc r15
        jmp .verc8

.aumdec8:
        mov r15,2608
        inc r14
.verc8:
        dec r13
        cmp r13,0
        jne .c8
	jmp .%6
.destruir8:
	mov %5,word 0

%endmacro


%macro compchoque9 6
        cmp word %5,0                   ;comprobacion del estado del bloque -destruido o no destruido
        je .nochoque                    ; si es 0 el estado no debe ocurrir colision con bola

        mov r13,15
        mov r14,%3
        mov r15,%4
.c9:
        cmp %2,r15
        je .verifdecenas9
        jmp .aumdatos9
.verifdecenas9:
        cmp %1,r14
        je .destruir9

.aumdatos9:
        cmp r15,2617
        je .aumdec9
        inc r15
        jmp .verc9

.aumdec9:
        mov r15,2608
        inc r14
.verc9:
        dec r13
        cmp r13,0
        jne .c9
        jmp .%6
.destruir9:
        mov %5,word 0
%endmacro



;----------------------PROCEDIMIENTOS------------------------------------

Imp_limites:
	print screenset,screenset_len	;
	print techo,tamano_techo        ;imprimir techo
        print p_izq,tamano_p_izq        ;imprimir pared izquierda
        print p_der,tamano_p_der        ;imprimir pared derecha
        print piso,tamano_piso          ;imprimir piso
	ret


Imp_bloques:
	print b1,tamano_b1
	print b2,tamano_b2
	print b3,tamano_b3
	print b4,tamano_b4
	print b5,tamano_b5
	print b6,tamano_b6
	print b7,tamano_b7
	print b8,tamano_b8
	print b9,tamano_b9
	ret
Ini_datosbloques:
	mov [db741],word 2608
        mov [db741+8],word 2611

	mov [db852],word 2609
        mov [db852+8],word 2617

	mov [db963],word 2611
        mov [db963+8],word 2612
	ret

Setbloques:
	mov r13,9
	mov r15,0
.c2:
	mov [cb+r15],word 1
	add r15,8
	dec r13
	cmp r13,0
	jne .c2
	ret

Destruirbloques:
	mov r13,9
	mov r15,0
	jmp .p1
.c3:
	add r15,8
        dec r13
.p1:
	cmp r13,0
	je .sal5
	cmp r15,0
	je .borrab1
	cmp r15,8
        je .borrab2
	cmp r15,16
        je .borrab3
	cmp r15,24
        je .borrab4
	cmp r15,32
        je .borrab5
	cmp r15,40
        je .borrab6
	cmp r15,48
        je .borrab7
	cmp r15,56
        je .borrab8
	cmp r15,64
        je .borrab9


.borrab1:
	cmp word [cb+r15],0
	je .bo1
	jmp .c3
.bo1:
	print nb1,tamano_nb1
	jmp .c3

.borrab2:
	cmp word [cb+r15],0
        je .bo2
	jmp .c3
.bo2:
        print nb2,tamano_nb2
	jmp .c3

.borrab3:
	cmp word [cb+r15],0
        je .bo3
	jmp .c3
.bo3:
        print nb3,tamano_nb3
	jmp .c3

.borrab4:
	cmp word [cb+r15],0
        je .bo4
	jmp .c3
.bo4:
        print nb4,tamano_nb4
	jmp .c3
.borrab5:
	cmp word [cb+r15],0
        je .bo5
        jmp .c3
.bo5:
        print nb5,tamano_nb5
	jmp .c3

.borrab6:
	cmp word [cb+r15],0
        je .bo6
        jmp .c3
.bo6:
        print nb6,tamano_nb6
	jmp .c3

.borrab7:
	cmp word [cb+r15],0
        je .bo7
        jmp .c3
.bo7:
        print nb7,tamano_nb7
	jmp .c3

.borrab8:
	cmp word [cb+r15],0
        je .bo8
        jmp .c3
.bo8:
        print nb8,tamano_nb8
	jmp .c3

.borrab9:
	cmp word [cb+r15],0
        je .bo9
        jmp .c3
.bo9:
        print nb9,tamano_nb9
	jmp .c3
.sal5:
	jmp _start.baja
	ret

;-----------------------Variables  y mensajes del Juego--------------------

segment .data

	vfila: db "     "		;variable para almacenar codigos de ejecucion
        vfila_len: equ $-vfila

	vcolumna: db "     "		;variable para almacenar codigos de ejecucion

        vcolumna_len: equ $-vcolumna

	vp: db "        "			;variable de pruebas para almacenar codigos de ejecucion
	vplen: equ $-vp

	va1: db " "                       ;variable de pruebas para almacenar codigos de ejecucion
        va1len: equ $-va1

	va2: db " "                       ;variable de pruebas para almacenar codigos de ejecucion
        va2len: equ $-va2

	va3: db " "                       ;variable de pruebas para almacenar codigos de ejecucion
	va3len: equ $-va3

 	va4: db " "                       ;variable de pruebas para almacenar codigos de ejecucion
        va4len: equ $-va4

	;Techo
	techo: db 0x1b,"[47;30m" ,0x1b,"[1;1f",0x1b, "[J" , "---------------------------------------------------"
	tamano_techo: equ $-techo

	;Piso
        piso: db 0x1b,"[30;1f","---------------------------------------------------"
        tamano_piso: equ $-piso

	;Pared izquierda
	p_izq: db  0x1b,"[2;1f","║",0x1b,"[3;1f","║",0x1b,"[4;1f","║",0x1b,"[5;1f","║",0x1b,"[6;1f","║",0x1b,"[7;1f","║",0x1b,"[8;1f","║",0x1b,"[9;1f","║",0x1b,"[9;1f","║",0x1b,"[10;1f","║",0x1b,"[11;1f","║",0x1b,"[12;1f","║",0x1b,"[13;1f","║",0x1b,"[14;1f","║",0x1b,"[15;1f","║",0x1b,"[16;1f","║",0x1b,"[17;1f","║",0x1b,"[18;1f","║",0x1b,"[19;1f","║",0x1b,"[20;1f","║",0x1b,"[21;1f","║",0x1b,"[22;1f","║",0x1b,"[23;1f","║",0x1b,"[24;1f","║",0x1b,"[25;1f","║",0x1b,"[26;1f","║",0x1b,"[27;1f","║",0x1b,"[28;1f","║",0x1b,"[29;1f","║"
        tamano_p_izq: equ $-p_izq

	 ;Pared derecha
        p_der: db  0x1b,"[2;51f","|",0x1b,"[3;51f","|",0x1b,"[4;51f","|",0x1b,"[5;51f","|",0x1b,"[6;51f","|",0x1b,"[7;51f","|",0x1b,"[8;51f","|",0x1b,"[9;51f","|",0x1b,"[9;51f","|",0x1b,"[10;51f","|",0x1b,"[11;51f","|",0x1b,"[12;51f","|",0x1b,"[13;51f","|",0x1b,"[14;51f","|",0x1b,"[15;51f","|",0x1b,"[16;51f","|",0x1b,"[17;51f","|",0x1b,"[18;51f","|",0x1b,"[19;51f","|",0x1b,"[20;51f","|",0x1b,"[21;51f","|",0x1b,"[22;51f","|",0x1b,"[23;51f","|",0x1b,"[24;51f","|",0x1b,"[25;51f","|",0x1b,"[26;51f","|",0x1b,"[27;51f","|",0x1b,"[28;51f","|",0x1b,"[29;51f","|"
        tamano_p_der: equ $-p_der

	;Bloque 1
	b1: db 0x1b,"[2;3f","+",0x1b,"[2;4f","-------------",0x1b,"[2;17f","+",0x1b,"[3;3f","|",0x1b,"[3;17f","|",0x1b,"[4;3f","+",0x1b,"[4;4f","-------------",0x1b,"[4;17f","+"
	tamano_b1: equ $-b1

	;Bloque 1 borrado
	nb1: db 0x1b,"[2;3f"," ",0x1b,"[2;4f","             ",0x1b,"[2;17f"," ",0x1b,"[3;3f"," ",0x1b,"[3;17f"," ",0x1b,"[4;3f"," ",0x1b,"[4;4f","             ",0x1b,"[4;17f"," "
        tamano_nb1: equ $-nb1

	;Bloque 2
	b2: db 0x1b,"[2;19f","+",0x1b,"[2;20f","-------------",0x1b,"[2;32f","+",0x1b,"[3;19f","|",0x1b,"[3;32f","|",0x1b,"[4;19f","+",0x1b,"[4;20f","-------------",0x1b,"[4;32f","+"
        tamano_b2: equ $-b2

	;Bloque  2 borrado
	nb2: db 0x1b,"[2;19f"," ",0x1b,"[2;20f","            ",0x1b,"[2;32f"," ",0x1b,"[3;19f"," ",0x1b,"[3;32f"," ",0x1b,"[4;19f"," ",0x1b,"[4;20f","            ",0x1b,"[4;32f"," "
        tamano_nb2: equ $-nb2

	;Bloque 3
	b3: db 0x1b,"[2;34f","+",0x1b,"[2;35f","-------------",0x1b,"[2;47f","+",0x1b,"[3;34f","|",0x1b,"[3;47f","|",0x1b,"[4;34f","+",0x1b,"[4;35f","-------------",0x1b,"[4;47f","+"
        tamano_b3: equ $-b3

	;Bloque 3 borrado
	nb3: db 0x1b,"[2;34f"," ",0x1b,"[2;35f","            ",0x1b,"[2;47f"," ",0x1b,"[3;34f"," ",0x1b,"[3;47f"," ",0x1b,"[4;34f"," ",0x1b,"[4;35f","             ",0x1b,"[4;47f"," "
        tamano_nb3: equ $-nb3

	;Bloque 4
        b4: db 0x1b,"[5;3f","+",0x1b,"[5;4f","-------------",0x1b,"[5;17f","+",0x1b,"[6;3f","|",0x1b,"[6;17f","|",0x1b,"[7;3f","+",0x1b,"[7;4f","-------------",0x1b,"[7;17f","+"
        tamano_b4: equ $-b4

        ;Bloque 4 borrado
        nb4: db 0x1b,"[5;3f"," ",0x1b,"[5;4f","             ",0x1b,"[5;17f"," ",0x1b,"[6;3f"," ",0x1b,"[6;17f"," ",0x1b,"[7;3f"," ",0x1b,"[7;4f","             ",0x1b,"[7;17f"," "
        tamano_nb4: equ $-nb4

	;Bloque 5
        b5: db 0x1b,"[5;19f","+",0x1b,"[5;20f","-------------",0x1b,"[5;32f","+",0x1b,"[6;19f","|",0x1b,"[6;32f","|",0x1b,"[7;19f","+",0x1b,"[7;20f","-------------",0x1b,"[7;32f","+"
        tamano_b5: equ $-b5

        ;Bloque 5 borrado
        nb5: db 0x1b,"[5;19f"," ",0x1b,"[5;20f","            ",0x1b,"[5;32f"," ",0x1b,"[6;19f"," ",0x1b,"[6;32f"," ",0x1b,"[7;19f"," ",0x1b,"[7;20f","            ",0x1b,"[7;32f"," "
        tamano_nb5: equ $-nb5

	;Bloque 6
        b6: db 0x1b,"[5;34f","+",0x1b,"[5;35f","-------------",0x1b,"[5;47f","+",0x1b,"[6;34f","|",0x1b,"[6;47f","|",0x1b,"[7;34f","+",0x1b,"[7;35f","-------------",0x1b,"[7;47f","+"
        tamano_b6: equ $-b6

        ;Bloque 6 borrado
        nb6: db 0x1b,"[5;34f"," ",0x1b,"[5;35f","            ",0x1b,"[5;47f"," ",0x1b,"[6;34f"," ",0x1b,"[6;47f"," ",0x1b,"[7;34f"," ",0x1b,"[7;35f","             ",0x1b,"[7;47f"," "
        tamano_nb6: equ $-nb6

	;Bloque 7
        b7: db 0x1b,"[8;3f","+",0x1b,"[8;4f","-------------",0x1b,"[8;17f","+",0x1b,"[9;3f","|",0x1b,"[9;17f","|",0x1b,"[10;3f","+",0x1b,"[10;4f","-------------",0x1b,"[10;17f","+"
        tamano_b7: equ $-b7

        ;Bloque 7 borrado
        nb7: db 0x1b,"[8;3f"," ",0x1b,"[8;4f","             ",0x1b,"[8;17f"," ",0x1b,"[9;3f"," ",0x1b,"[9;17f"," ",0x1b,"[10;3f"," ",0x1b,"[10;4f","             ",0x1b,"[10;17f"," "
        tamano_nb7: equ $-nb7

	;Bloque 8
        b8: db 0x1b,"[8;19f","+",0x1b,"[8;20f","-------------",0x1b,"[8;32f","+",0x1b,"[9;19f","|",0x1b,"[9;32f","|",0x1b,"[10;19f","+",0x1b,"[10;20f","-------------",0x1b,"[10;32f","+"
        tamano_b8: equ $-b8

        ;Bloque 8 borrado
        nb8: db 0x1b,"[8;19f"," ",0x1b,"[8;20f","            ",0x1b,"[8;32f"," ",0x1b,"[9;19f"," ",0x1b,"[9;32f"," ",0x1b,"[10;19f"," ",0x1b,"[10;20f","            ",0x1b,"[10;32f"," "
        tamano_nb8: equ $-nb8

	;Bloque 9
        b9: db 0x1b,"[8;34f","+",0x1b,"[8;35f","-------------",0x1b,"[8;47f","+",0x1b,"[9;34f","|",0x1b,"[9;47f","|",0x1b,"[10;34f","+",0x1b,"[10;35f","-------------",0x1b,"[10;47f","+"
        tamano_b9: equ $-b9

        ;Bloque 9 borrado
        nb9: db 0x1b,"[8;34f"," ",0x1b,"[8;35f","            ",0x1b,"[8;47f"," ",0x1b,"[9;34f"," ",0x1b,"[9;47f"," ",0x1b,"[10;34f"," ",0x1b,"[10;35f","             ",0x1b,"[10;47f"," "
        tamano_nb9: equ $-nb9


	;Mensaje de Bienvenida y solicitud de nombre a jugador
	msm_bienvenida: db 0x1b,"[46;30m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[9;15f","Bienvenido a Micronoid",0x1b,"[11;4f","EL-4313-Lab. Estructura de Microprocesadores",0x1b,"[13;21f","2S-2016",0x1b,"[15;11f","Ingrese el nombre del jugador:"
	tamano_msm_bienvenida: equ $-msm_bienvenida

	;Reestable colores de letra y fondo y reinicio de consola
	color_set_normal: db 0x1b,"[1;1f",0x1b,"[40;37m",0x1b, "[J"
	tamano_color_set_normal: equ $-color_set_normal:

	bola2: db "B"
	bola2len: equ $-bola2

	bola: db "☼" 					;bola
	tamano_bola: equ $-bola

	nbola: db " "					;no bola
	tamano_nbola: equ $-nbola

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



segment .bss
	nombre: resb 10
	let: resb 2

	;variable de estado de movimiento lateral de la bola 
	buffer: resb 8
	;variables de almacenamiento de datos de movimiento de la bola
	buffer1: resb 8
	buffer2: resb 8
 	buffer3: resb 8
 	buffer4: resb 8

	;variable de estados de bloques
	cb: resb 72
	;datos de bloques
	db741: resb 16
	db852: resb 16
	db963: resb 16

	x: resb 8
;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:

	print msm_bienvenida,tamano_msm_bienvenida	;imprimir mensaje de bienvenida y solicita nombre a usuario
	print centro,tamano_centro			;mueve cursor a siguiente posicion
	in_teclado nombre,10				; espera datos del usuario

	mov [buffer1],word 2610
        mov [buffer2],word 2614
        mov [buffer3],word 2610
        mov [buffer4],word 2613
	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	call Imp_limites				;imprime limites del juego
	call Imp_bloques				;imprime bloques del juego
	call Ini_datosbloques
	call Setbloques

	ir r8,r9,r10,r12
	print bola,tamano_bola

	mov [buffer],word 0				;establecimiento de direccion lateral inicial
	jmp .sube					;salto para que empiece a subir la bola
.baja:
	mov r14,120000000
.unidadesFb1:
        dec r14
	cmp r14,0
        jne .unidadesFb1

	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	ir r8,r9,r10,r12
	print nbola,tamano_nbola

	movlateralBAJ r10,r12,[buffer]	;macro de calculo de movimiento lateral(Bajada)
.movlateralfull1:

	cmp r9,2617			;movimiento de bajada
	je .decenasFb1
	inc r9
	jmp .sal0
.decenasFb1:
	mov r9,2608
	inc r8
.sal0:
        ir r8,r9,r10,r12                ;posicion del cursor final para imprimir
        print bola,tamano_bola

        cmp r10,2608                     ;comparacion de limite izquierdo decenas
        je .compuniizq1
        cmp r10,2613
	je .compunider1			;comparacion de limite derecho decenas
	jmp .sal2
.compuniizq1:
        cmp r12,2610
        je .sal1
	jmp .sal2
.compunider1:
        cmp r12,2608
        mov [buffer],word 0                       ;r13 se usa como variable de estado para determinar si moverse hacia izquierda o derecha
        jmp .sal2
.sal1:
        mov [buffer],word 1

.sal2:
	mov [buffer1],r8
        mov [buffer2],r9
        mov [buffer3],r10
        mov [buffer4],r12


	cmp r8,2610			;comparacion de limite inferior
	je .g
	jmp .s
.g:
	cmp r9,2617			;salto a funcion de subir bola por estar en los limites
	je .sube
.s:
	jmp .baja


.sube:
        mov r14,100000000
.unidadesFs2:
        dec r14
        cmp r14,0
        jne .unidadesFs2
	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	ir r8,r9,r10,r12
        print nbola,tamano_nbola
	movlateralSUB r10,r12,[buffer]	;macro de calculo de movimiento lateral(Subida)

.movlateralfull2:
	cmp r9,2608			;movimineto para subir
        je .decenasFs2
        dec r9
        jmp .sal
.decenasFs2:
        mov r9,2617
        dec r8
.sal:
	ir r8,r9,r10,r12		;posicion del cursor final para imprimir
        print bola,tamano_bola

	cmp r10,2608                     ;comparacion de limite izquierdo  unidades y decenas
        je .compuniizq2
	cmp r10,2613
        je .compunider2                 ;comparacion de limite derecho decenas
	jmp .sal4
.compuniizq2:
        cmp r12,2610
	je .sal3
	jmp .sal4
.compunider2:
        cmp r12,2608
	mov [buffer],word 0			;r13 se usa como variable de estado para determinar si moverse hacia izquierda o derecha
	jmp .sal4
.sal3:
	mov [buffer],word 1
.sal4:

	mov [buffer1],r8
        mov [buffer2],r9
        mov [buffer3],r10
        mov [buffer4],r12

	cmp r8,2609                             ;comparacion de limite respectoa bloques 7,8 y 9
        je .bordebloque789
        jmp .limiteup
.bordebloque789:
        cmp r9,2609
	je .comprobarchoque789
	jmp .nochoque

.comprobarchoque789:
	cmp word [cb+48],1
	je .comprobarchoque7
	cmp word [cb+56],1
	je .comprobarchoque8
	cmp word [cb+64],1
	je .comprobarchoque9
	jmp .nochoque




.comprobarchoque7:
        mov r13,15
	mov r14,[db741]
        mov r15,[db741+8]
.c7:
        cmp r12,r15
        je .verifdecenas7
        jmp .aumdatos7
.verifdecenas7:
        cmp r10,r14
        je .destruir7

.aumdatos7:
	cmp r15,2617
        je .aumdec7
        inc r15
        jmp .verc7

.aumdec7:
 	mov r15,2608
        inc r14
.verc7:
        dec r13
        cmp r13,0
	jne .c7
        jmp .comprobarchoque789
.destruir7:
	print bola2,bola2len
        mov [cb+48],word 0
	call Destruirbloques
	jmp .limiteup


.comprobarchoque8:
	mov r13,15
        mov r14,[db852]
        mov r15,[db852+8]
.c8:
        cmp r12,r15
        je .verifdecenas8
        jmp .aumdatos8
.verifdecenas8:
        cmp r10,r14
        je .destruir8

.aumdatos8:
        cmp r15,2617
        je .aumdec8
        inc r15
        jmp .verc8

.aumdec8:
        mov r15,2608
        inc r14
.verc8:
        dec r13
        cmp r13,0
        jne .c8
        jmp .comprobarchoque789
.destruir8:
	print bola2,bola2len
        mov [cb+56],word 0
        call Destruirbloques
        jmp .limiteup


.comprobarchoque9:
	mov r13,15
        mov r14,[db963]
        mov r15,[db963+8]
.c9:
        cmp r12,r15
        je .verifdecenas9
        jmp .aumdatos9
.verifdecenas9:
        cmp r10,r14
        je .destruir9

.aumdatos9:
        cmp r15,2617
        je .aumdec9
        inc r15
        jmp .verc9

.aumdec9:
        mov r15,2608
        inc r14
.verc9:
        dec r13
        cmp r13,0
        jne .c9
	jmp .comprobarchoque789
.destruir9:
	print bola2,bola2len
        mov [cb+64],word 0
        call Destruirbloques
        jmp .limiteup





.nochoque:

.limiteup:
	cmp r8,2608				;comparacion de limite superior unidades y decenas
        je .limitsuperior
        jmp .holdsubir
.limitsuperior:
        cmp r9,2610
        je .baja
.holdsubir:
        jmp .sube


.fin:
	irs 2611,2613,2608,2608
	mov rax,60
	mov rdi,0
	syscall


