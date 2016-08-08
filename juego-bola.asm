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

%macro movlateralBAJ 3			;macro de calculo lateral para movimiento de bajada
        cmp %3,1                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
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
        cmp %3,1                        ;comparacion de estado de r13 para saber a donde moverse
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

;Funcion para mover el cursor con valores numericos estaticos
%macro gofxc 4
        print setcursor,setcursor_len
        mov [vfila+0],dword 0x1b
        mov [vfila+1],dword 0xa5b
        mov [vfila+2],dword %1            ;Decenas de la columna
        mov [vfila+3],dword %2            ;Unidades de la columna
        mov [vfila+4],dword 0xa42

        print vfila,vfila_len

        mov [vcolumna+0],dword 0x1b
        mov [vcolumna+1],dword 0xa5b
        mov [vcolumna+2],dword %3            ;Decenas columna
        mov [vcolumna+3],dword %4            ;Unidades de columna
        mov [vcolumna+4],dword 0xa43

        print vcolumna,vcolumna_len
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

	nbola: db "   "					;no bola
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

	x: equ 1


segment .bss
	nombre: resb 10
	let: resb 2

	p1 resb 1
	p2 resb 1
	p3 resb 1
	p4 resb 1
;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:
	;---------Creacion de limites del juego
	call Imp_limites				;imprime limites del juego
	print col,tamcol				;esconde cursor
	;print cal,tam

	;inicializando registros
	mov r8,2610
	mov r9,2614
	mov r10,2610
	mov r12,2611

	mov r13,1		;direccion lateral de la bola
	jmp .sube		;salto para que empiece a subir la bola
.baja:
	mov r14,150000000
.unidadesFb1:
        dec r14
        cmp r14,0
        jne .unidadesFb1

	ir r8,r9,r10,r12
	print nbola,tamano_nbola

	movlateralBAJ r10,r12,r13	;macro de calculo de movimiento lateral(Bajada)
.movlateralfull1:
	cmp r9,2617			;
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
        mov r13,0                       ;r13 se usa como variable de estado para determinar si moverse hacia izquierda o derecha
        jmp .sal2
.sal1:
        mov r13,1

.sal2:


	cmp r8,2610			;comparacion de limite inferior
	je .g
	jmp .s
.g:
	cmp r9,2617			;salto a funcion de subir bola por estar en los limites
	je .sube
.s:
	jmp .baja


.sube:

        mov r14,150000000
.unidadesFs2:
        dec r14
        cmp r14,0
        jne .unidadesFs2
	;call Imp_limites
	ir r8,r9,r10,r12
        print nbola,tamano_nbola
	movlateralSUB r10,r12,r13	;macro de calculo de movimiento lateral(Subida)

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
	mov r13,0			;r13 se usa como variable de estado para determinar si moverse hacia izquierda o derecha
	jmp .sal4
.sal3:
	mov r13,1
.sal4:

        cmp r8,2608			;comparacion de limite superior unidades y decenas
        je .e
        jmp .w
.e:
        cmp r9,2610
        je .baja
.w:
        jmp .sube



.fin:
	gofxc 2611,2608,2608,2608
	mov rax,60
	mov rdi,0
	syscall




