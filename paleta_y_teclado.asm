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
        cmp %3,99                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
        je .compder
	jmp .compararz
.compararz:
	cmp %3,122
        je .compiz
	jmp _start.juego
.compiz:
	cmp %1,48
	je .compiz1
	jmp .bajarizq
.compiz1:
	cmp %2,50
	je _start.juego
	jmp .bajarizq 
.compder:
	cmp %1, 52
	je .compder1
	jmp .bajarder

.compder1:
	cmp %2,52
	je _start.juego
	jmp .bajarder

.bajarizq:                      	;movimiento horizontal izquierdo
        cmp %2,48
        je .decCsizq1
        dec %2
        jmp .sal0
.decCsizq1:
        mov %2,57
        cmp %1,48
        je .sal0
        dec %1
        jmp .sal0

.bajarder:                      	;movimiento horizontal derecho
        cmp %2,57
        je .decCsder1
        inc %2
        jmp .sal0
.decCsder1:
        mov %2,48
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

canonical_off:

        ;Este proceso apaga el modo canonico del sistema, el cual
        ;permite la lectura del teclado sin tener que precionar enter

        mov rax, ICANON		;Se coloca un 1 en la posicion de la bandera del modo canonico
        not rax			;Se invierten todos los bits para que solo la bandera del modo canonico se apague
        and [termios+12], rax 	;Se apaga el bit 12 en caso de estar encendido en la variable del termios
	mov byte[termios+CC+VTIME], 0     ; Ponemos el tiempo de espera a 0
    	mov byte[termios+CC+VMIN], 0      ; Ponemos la cantidad mínima bits a 0

        call write_stdin_termios ;Este proceso actualiza el valor del termios
        ret


canonical_on:

        ;Este proceso reactiva el modo canonico del sistema

        or dword [termios+12], ICANON 	  ;Se restablece el valor del parametro de modo canonico
	mov byte[termios+CC+VTIME], 0     ;Ponemos el tiempo de espera a 0
    	mov byte[termios+CC+VMIN], 1      ;Ponemos la cantidad mínima de bits a 1

        call write_stdin_termios ;Este proceso actualiza el valor del termios
        ret


echo_on:

        ;Reestablece la configuracion del echo

        or dword [termios+12], ECHO	;Se escribe en esta posicion del termios la nueva bandera de control del echo
        call write_stdin_termios	;Se escribe la nueva configuracion del termios
        ret

echo_off:

        ;Este proceso hace que al presionar una tecla no se muestre en pantalla

        mov rax, ECHO			;Se coloca en rax un 1 en la posicion de la bandera echo
        not rax				;El resto de bits quedan encendidos y el echo queda en 0
        and [termios+12], rax		;Se actualiza el valor del termios

        call write_stdin_termios ;Este proceso actualiza el valor del termios
        ret

write_stdin_termios:

        ;Este proceso escribe datos en el termios

        mov eax, 36h		;interrupcion para modificar el termios
        mov ebx, stdin		;ubicacion del stdin
        mov ecx, 5402h		;ubicacion del termios dentro del stdin
        mov edx, termios	;valor actualizado que queremos usar en el termios
        int 80h			;interrupcion de 32 bits

        ret





;-----------------------Variables  y mensajes del Juego--------------------

segment .data
	barra: db "---------"
	tamano_barra: equ $-barra
	nobarra:db 0x1b,"[26;2f", "                                                   "
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

	termios:        times 36 db 0                   ;Estructura de 36bytes que contiene el modo de opera$
        stdin:          equ 0                           ;Nombre de referencia a la hora de llamar el stdin
        ICANON:         equ 1<<1                        ;Valor de control para la posicion del bit del modo canonico
        ECHO:           equ 1<<3			;Valor de control para la posicion del bit del echo
	VTIME:          equ 5				;Posicion de la bandera VTIME dentro de cc_c
        VMIN:           equ 6				;Posicion de la bandera VMIN dentro de cc_c
        CC:             equ 18                          ;Posicion del arreglo cc_c del termios

segment .bss
	nombre: resb 10
	let: resb 2
	contador: resb 8

;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _rev
_start:
	;inicializando registros

	mov r14,50
        mov r15,51


	;---------Creacion de limites del juego

	call Imp_limites				;imprime limites del juego
	mover r14,r15
	print barra,tamano_barra

	call canonical_off				;Apaga el modo canonico
	call echo_off					;Apaga el echo

	mov qword [contador],10000000
.juego:
	sub qword [contador],1
	cmp qword [contador],0
	jne .juego
_rev:

	mov word [let],1
	mov qword [contador],10000000

	mov rax,0
	mov rdi,0
	mov rsi,let
	mov rdx,1
	syscall

	cmp word [let], 97
        je .fin
	movlateral r14,r15, word [let]	;"macro de calculo de movimiento lateral"
	jmp _start.juego

.sal0:
        ;posicion del cursor final para imprimir"r8 y r9 fijos"
	print nobarra,tam1
	mover r14,r15
        print barra,tamano_barra
	jmp _start.juego
.fin:
	call canonical_on
	call echo_on
	mov rax,60
	mov rdi,0
	syscall


