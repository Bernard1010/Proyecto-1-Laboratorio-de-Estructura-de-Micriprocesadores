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
        je .bajarderechabola
        jmp .bajarizquierdabola
.bajarizquierdabola:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .decCsizquierdabola1
        dec %2
        jmp .movlateralfull1
.decCsizquierdabola1:
        mov %2,2617
        cmp %1,2608
        je .movlateralfull1
        dec %1
        jmp .movlateralfull1

.bajarderechabola:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .decCsderechabola1
        inc %2
        jmp .movlateralfull1
.decCsderechabola1:
        mov %2,2608
        inc %1
%endmacro

%macro movlateralSUB 3			;macro de calculo lateral para movimiento de bajada 
	mov r13,%3
	cmp r13,1                        ;comparacion de estado de r13 para saber a donde moverse
        je .subirderecha
        jmp .subirizquierda
.subirizquierda:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .decCsizquierda2
        dec %2
        jmp .movlateralfull2
.decCsizquierda2:
        mov %2,2617
        cmp %1,2608
        je .movlateralfull2
        dec %1
        jmp .movlateralfull2
.subirderecha:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .decCsderecha2
        inc %2
        jmp .movlateralfull2
.decCsderecha2:
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



%macro movbarraBAJ 3

	;macro de calculo lateral para movimiento de bajada
        cmp %3,99                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
        je .compder
	jmp .compararz
.compararz:
	cmp %3,122
        je .compiz
	jmp .movbarrafull1
.compiz:
	cmp %1,2608
	je .compiz1
	jmp .movizq
.compiz1:
	cmp %2,2611
	je .movbarrafull1
	jmp .movizq
 .compder:
	cmp %1,2612
	je .compder1
	jmp .movder

.compder1:
	cmp %2,2610
	je .movbarrafull1
	jmp .movder

.movizq:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .restarizq
        dec %2
	cmp %2,2608
        je .restarizq
        dec %2
	jmp .updatebarraA
.restarizq:
        mov %2,2617
        cmp %1,2608
        je .updatebarraA
        dec %1
        jmp .updatebarraA
.movder:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .restarder
        inc %2
	cmp %2,2617
        je .restarder
        inc %2
        jmp .updatebarraA
.restarder:
        mov %2,2608
        inc %1
%endmacro




%macro movbarraSUB 3

	;macro de calculo lateral para movimiento de bajada
        cmp %3,99                        ;comparacion de estado de r13 para saber si continuar moviendose en alguna direccion lateral
        je .compderb
	jmp .compararzb
.compararzb:
	cmp %3,122
        je .compizb
	jmp .movbarrafull2
.compizb:
	cmp %1,2608
	je .compiz1b
	jmp .movizqb
.compiz1b:
	cmp %2,2611
	je .movbarrafull2
	jmp .movizqb
.compderb:
	cmp %1,2612
	je .compder1b
	jmp .movderb

.compder1b:
	cmp %2,2610
	je .movbarrafull2
	jmp .movderb

.movizqb:                      	;movimiento horizontal izquierdo
        cmp %2,2608
        je .restarizqb
        dec %2
	cmp %2,2608
        je .restarizqb
        dec %2
	jmp .updatebarraB
.restarizqb:
        mov %2,2617
        cmp %1,48
        je .updatebarraB
        dec %1
        jmp .updatebarraB

.movderb:                      	;movimiento horizontal derecho
        cmp %2,2617
        je .restarderb
        inc %2
	cmp %2,2617
        je .restarderb
        inc %2

        jmp .updatebarraB
.restarderb:
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
        mov [db741+8],word 2610

	mov [db852],word 2609
        mov [db852+8],word 2616

	mov [db963],word 2611
        mov [db963+8],word 2612
	ret

Setbloques:
	mov word [bdestruidos],0
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
	;mov byte[termios+CC+VTIME], 0     ;Ponemos el tiempo de espera a 0
    	;mov byte[termios+CC+VMIN], 1      ;Ponemos la cantidad mínima de bits a 1

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

	push rax
	push rbx
	push rcx
	push rdx

        mov eax, 36h		;interrupcion para modificar el termios
        mov ebx, stdin		;ubicacion del stdin
        mov ecx, 5402h		;ubicacion del termios dentro del stdin
        mov edx, termios	;valor actualizado que queremos usar en el termios
        int 80h			;interrupcion de 32 bits

	pop rax
        pop rbx
        pop rcx
        pop rdx
        ret

Pausa:
.pausa:
	mov word [let],1                                ;Limpia variable let
        in_teclado let,1                                ;Copia, de ser posible, la tecla que se este presionando en [let]
        cmp word [let],120                              ;Compara si la letra presionada es "x"
        jne .pausa                                      ;De no ser "x" el juego sigue en pausa
	ret

;-----------------------Variables  y mensajes del Juego--------------------

segment .data

	barra: db "▲▼▲▼▲▼▲▼▲"
	tamano_barra: equ $-barra
	nobarra:db 0x1b,"[26;2f", "                                                 "
	tam1: equ $-nobarra

	nobarra0:db 0x1b,"[29;2f", "                                                 "
        lennobarra0: equ $-nobarra0


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
	techo: db 0x1b,"[47;30m" ,0x1b,"[1;1f",0x1b, "[J" , "╔═════════════════════════════════════════════════╗"
	tamano_techo: equ $-techo

	;Piso
        piso: db 0x1b,"[30;1f","╚═════════════════════════════════════════════════╝"
        tamano_piso: equ $-piso

	;Pared izquierda
	p_izq: db  0x1b,"[2;1f","║",0x1b,"[3;1f","║",0x1b,"[4;1f","║",0x1b,"[5;1f","║",0x1b,"[6;1f","║",0x1b,"[7;1f","║",0x1b,"[8;1f","║",0x1b,"[9;1f","║",0x1b,"[9;1f","║",0x1b,"[10;1f","║",0x1b,"[11;1f","║",0x1b,"[12;1f","║",0x1b,"[13;1f","║",0x1b,"[14;1f","║",0x1b,"[15;1f","║",0x1b,"[16;1f","║",0x1b,"[17;1f","║",0x1b,"[18;1f","║",0x1b,"[19;1f","║",0x1b,"[20;1f","║",0x1b,"[21;1f","║",0x1b,"[22;1f","║",0x1b,"[23;1f","║",0x1b,"[24;1f","║",0x1b,"[25;1f","║",0x1b,"[26;1f","║",0x1b,"[27;1f","║",0x1b,"[28;1f","║",0x1b,"[29;1f","║"
        tamano_p_izq: equ $-p_izq

	 ;Pared derecha
        p_der: db  0x1b,"[2;51f","║",0x1b,"[3;51f","║",0x1b,"[4;51f","║",0x1b,"[5;51f","║",0x1b,"[6;51f","║",0x1b,"[7;51f","║",0x1b,"[8;51f","║",0x1b,"[9;51f","║",0x1b,"[9;51f","║",0x1b,"[10;51f","║",0x1b,"[11;51f","║",0x1b,"[12;51f","║",0x1b,"[13;51f","║",0x1b,"[14;51f","║",0x1b,"[15;51f","║",0x1b,"[16;51f","║",0x1b,"[17;51f","║",0x1b,"[18;51f","║",0x1b,"[19;51f","║",0x1b,"[20;51f","║",0x1b,"[21;51f","║",0x1b,"[22;51f","║",0x1b,"[23;51f","║",0x1b,"[24;51f","║",0x1b,"[25;51f","║",0x1b,"[26;51f","║",0x1b,"[27;51f","║",0x1b,"[28;51f","║",0x1b,"[29;51f","║"
        tamano_p_der: equ $-p_der

	;Bloque 1
	b1: db 0x1b,"[2;2f","╔",0x1b,"[2;3f","══════════════",0x1b,"[2;17f","╗",0x1b,"[3;2f","║",0x1b,"[3;17f","║",0x1b,"[4;2f","╚",0x1b,"[4;3f","══════════════",0x1b,"[4;17f","╝"
	tamano_b1: equ $-b1

	;Bloque 1 borrado
	nb1:db 0x1b,"[2;2f"," ",0x1b,"[2;3f","              ",0x1b,"[2;17f"," ",0x1b,"[3;2f"," ",0x1b,"[3;17f"," ",0x1b,"[4;2f"," ",0x1b,"[4;3f","              ",0x1b,"[4;17f"," "
        tamano_nb1: equ $-nb1

	;Bloque 2
	b2: db 0x1b,"[2;18f","╔",0x1b,"[2;19f","══════════════",0x1b,"[2;33f","╗",0x1b,"[3;18f","║",0x1b,"[3;33f","║",0x1b,"[4;18f","╚",0x1b,"[4;19f","══════════════",0x1b,"[4;33f","╝"
        tamano_b2: equ $-b2

	;Bloque  2 borrado
	nb2:db 0x1b,"[2;18f"," ",0x1b,"[2;19f","              ",0x1b,"[2;33f"," ",0x1b,"[3;18f"," ",0x1b,"[3;33f"," ",0x1b,"[4;18f"," ",0x1b,"[4;19f","              ",0x1b,"[4;33f"," "
        tamano_nb2: equ $-nb2

	;Bloque 3
	b3: db 0x1b,"[2;34f","╔",0x1b,"[2;35f","═══════════════",0x1b,"[2;50f","╗",0x1b,"[3;34f","║",0x1b,"[3;50f","║",0x1b,"[4;34f","╚",0x1b,"[4;35f","═══════════════",0x1b,"[4;50f","╝"
        tamano_b3: equ $-b3

	;Bloque 3 borrado
	nb3:db 0x1b,"[2;34f"," ",0x1b,"[2;35f","               ",0x1b,"[2;50f"," ",0x1b,"[3;34f"," ",0x1b,"[3;50f"," ",0x1b,"[4;34f"," ",0x1b,"[4;35f","               ",0x1b,"[4;50f"," "
        tamano_nb3: equ $-nb3

	;Bloque 4
        b4: db 0x1b,"[5;2f","╔",0x1b,"[5;3f","══════════════",0x1b,"[5;17f","╗",0x1b,"[6;2f","║",0x1b,"[6;17f","║",0x1b,"[7;2f","╚",0x1b,"[7;3f","══════════════",0x1b,"[7;17f","╝"
        tamano_b4: equ $-b4

        ;Bloque 4 borrado
        nb4:db 0x1b,"[5;2f"," ",0x1b,"[5;3f","               ",0x1b,"[5;17f"," ",0x1b,"[6;2f"," ",0x1b,"[6;17f"," ",0x1b,"[7;2f"," ",0x1b,"[7;3f","              ",0x1b,"[7;17f"," "
        tamano_nb4: equ $-nb4

	;Bloque 5
        b5: db 0x1b,"[5;18f","╔",0x1b,"[5;19f","══════════════",0x1b,"[5;33f","╗",0x1b,"[6;18f","║",0x1b,"[6;33f","║",0x1b,"[7;18f","╚",0x1b,"[7;19f","══════════════",0x1b,"[7;33f","╝"
        tamano_b5: equ $-b5

        ;Bloque 5 borrado
        nb5:db 0x1b,"[5;18f"," ",0x1b,"[5;19f","              ",0x1b,"[5;33f"," ",0x1b,"[6;18f"," ",0x1b,"[6;33f"," ",0x1b,"[7;18f"," ",0x1b,"[7;19f","              ",0x1b,"[7;33f"," "
        tamano_nb5: equ $-nb5

	;Bloque 6
        b6: db 0x1b,"[5;34f","╔",0x1b,"[5;35f","═══════════════",0x1b,"[5;50f","╗",0x1b,"[6;34f","║",0x1b,"[6;50f","║",0x1b,"[7;34f","╚",0x1b,"[7;35f","═══════════════",0x1b,"[7;50f","╝"
        tamano_b6: equ $-b6

        ;Bloque 6 borrado
        nb6:db 0x1b,"[5;34f"," ",0x1b,"[5;35f","                ",0x1b,"[5;50f"," ",0x1b,"[6;34f"," ",0x1b,"[6;50f"," ",0x1b,"[7;34f"," ",0x1b,"[7;35f","               ",0x1b,"[7;50f"," "
        tamano_nb6: equ $-nb6

	;Bloque 7
        b7: db 0x1b,"[8;2f","╔",0x1b,"[8;3f","══════════════",0x1b,"[8;17f","╗",0x1b,"[9;2f","║",0x1b,"[9;17f","║",0x1b,"[10;2f","╚",0x1b,"[10;3f","══════════════",0x1b,"[10;17f","╝"
        tamano_b7: equ $-b7

        ;Bloque 7 borrado
        nb7: db 0x1b,"[8;2f"," ",0x1b,"[8;3f","              ",0x1b,"[8;17f"," ",0x1b,"[9;2f"," ",0x1b,"[9;17f"," ",0x1b,"[10;2f"," ",0x1b,"[10;3f","               ",0x1b,"[10;17f"," "
        tamano_nb7: equ $-nb7

	;Bloque 8
        b8: db 0x1b,"[8;18f","╔",0x1b,"[8;19f","══════════════",0x1b,"[8;33f","╗",0x1b,"[9;18f","║",0x1b,"[9;33f","║",0x1b,"[10;18f","╚",0x1b,"[10;19f","══════════════",0x1b,"[10;33f","╝"
        tamano_b8: equ $-b8

        ;Bloque 8 borrado
        nb8: db 0x1b,"[8;18f"," ",0x1b,"[8;19f","              ",0x1b,"[8;33f"," ",0x1b,"[9;18f"," ",0x1b,"[9;33f"," ",0x1b,"[10;18f"," ",0x1b,"[10;19f","              ",0x1b,"[10;33f"," "
        tamano_nb8: equ $-nb8

	;Bloque 9
        b9: db 0x1b,"[8;34f","╔",0x1b,"[8;35f","═══════════════",0x1b,"[8;50f","╗",0x1b,"[9;34f","║",0x1b,"[9;50f","║",0x1b,"[10;34f","╚",0x1b,"[10;35f","═══════════════",0x1b,"[10;50f","╝"
        tamano_b9: equ $-b9

        ;Bloque 9 borrado
        nb9: db 0x1b,"[8;34f"," ",0x1b,"[8;35f","               ",0x1b,"[8;50f"," ",0x1b,"[9;34f"," ",0x1b,"[9;50f"," ",0x1b,"[10;34f"," ",0x1b,"[10;35f","               ",0x1b,"[10;50f"," "
        tamano_nb9: equ $-nb9


	;Mensaje de Bienvenida y solicitud de nombre a jugador
	msm_bienvenida: db 0x1b,"[46;30m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[9;15f","Bienvenido a Micronoid",0x1b,"[11;4f","EL-4313-Lab. Estructura de Microprocesadores",0x1b,"[13;21f","2S-2016",0x1b,"[15;11f","Ingrese el nombre del jugador:"
	tamano_msm_bienvenida: equ $-msm_bienvenida

	;Mensaje para iniciar juego
	msm_seguirjuego: db 0x1b,"[20;14f","Presione X para continuar"
	tamano_msm_seguirjuego: equ $-msm_seguirjuego

	;Mensaje para perdida de vidas
	msm_pierdevida: db 0x1b,"[15;13f","Intento Fallido → Pierde → ♥"
	tamano_msm_pierdevida: equ $-msm_pierdevida

	;Mensaje para perdida de vidas vacio
        msm_npierdevida: db 0x1b,"[15;12f","                            "
        tamano_msm_npierdevida: equ $-msm_npierdevida

	;Mensaje para iniciar juego
        msm_noseguirjuego: db 0x1b,"[20;14f","                         "
        tamano_msm_noseguirjuego: equ $-msm_noseguirjuego

	;Reestable colores de letra y fondo y reinicio de consola
	color_set_normal: db 0x1b,"[1;1f",0x1b,"[40;37m",0x1b, "[J"
	tamano_color_set_normal: equ $-color_set_normal:

	bola2: db "B"
	bola2len: equ $-bola2

	;mensaje de vida
	vida: db 0x1b,"[32;2f","VIDAS → "
        tamano_vida: equ $-vida


	;Simbolos de la cantidad de vida
	vida3: db 0x1b,"[32;10f","♥ ♥ ♥"
	tamano_vida3: equ $-vida3

	vida2: db 0x1b,"[32;10f","♥ ♥  "
        tamano_vida2: equ $-vida2

	vida1: db 0x1b,"[32;10f","♥   "
        tamano_vida1: equ $-vida1

	bola: db "○" 					;bola
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

	bdestruidos: resb 8

	contador: resb 8
	unidades: resb 8
	decenas: resb 8

	vidas: resb 8

;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:

	print msm_bienvenida,tamano_msm_bienvenida	;imprimir mensaje de bienvenida y solicita nombre a usuario
	print centro,tamano_centro			;mueve cursor a siguiente posicion
	in_teclado nombre,10				; espera datos del usuario


	;INICIALIZACION DE VARIABLES Y REGISTROS
	mov qword [decenas],2610
	mov qword [unidades],2610

	mov [buffer1],word 2610
        mov [buffer2],word 2610
        mov [buffer3],word 2611
        mov [buffer4],word 2613
	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	call Imp_limites				;imprime limites del juego
	call Imp_bloques				;imprime bloques del juego
	call Ini_datosbloques
	call Setbloques
	mov word [vidas],0

	mov r14,qword [decenas]				;posicion inicial de la barra
	mov r15,qword [unidades]
	mover r14,r15
	print barra,tamano_barra

	call canonical_off				;Apaga el modo canonico
	call echo_off					;Apaga el echo

	irs 2610,2610,2611,2613
	print bola,tamano_bola

	irs 2611,2610,2612,2608
        print nombre,10

	print vida,tamano_vida
	print vida3,tamano_vida3

;------------------------------------------------------------------------------------------------------
	print msm_seguirjuego,tamano_msm_seguirjuego
	call Pausa
	print msm_noseguirjuego,tamano_msm_noseguirjuego
	mov [buffer],word 0				;establecimiento de direccion lateral inicial
	jmp .sube					;salto para que empiece a subir la bola

.ciclovidas:
	mov qword [decenas],2610
        mov qword [unidades],2611

        mov [buffer1],word 2610
        mov [buffer2],word 2610
        mov [buffer3],word 2611
        mov [buffer4],word 2613
        mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	mov r14,qword [decenas]                         ;posicion inicial de la barra
        mov r15,qword [unidades]
	mover r14,r15
        print barra,tamano_barra

	irs 2610,2610,2611,2613
        print bola,tamano_bola
	jmp .sube

.baja:
	cmp word [bdestruidos],9
	je .fin
	mov r14,100000000
.unidadesFb1:
        dec r14
	cmp r14,0
        jne .unidadesFb1

	mov word [let],1				;Limpia el contenido de [let]
	in_teclado let,1				;Copia, de ser posible, la tecla que se este presionando en [let]

	cmp word [let], 120				;Compara si la letra presionada es "x"
	jne .continuar1					;De ser verdadero salta al punto de pausa

	print msm_seguirjuego,tamano_msm_seguirjuego
        call Pausa
        print msm_noseguirjuego,tamano_msm_noseguirjuego
.continuar1:

	mov r14,qword [decenas]				;Se actualiza el valor del buffer decenas
	mov r15,qword [unidades]			;Se actualiza el valor del buffer unidades
	movbarraBAJ r14,r15, word [let]			;"macro de calculo de movimiento lateral"

.updatebarraA:
	mov qword [decenas],r14				;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15			;Se guarda el nuevo valor del buffer unidades
	print nobarra,tam1				;Borra el espacio donde ya no se encuentra la barra
	mover r14,r15					;Se mueve el cursor a la nueva posicion de la barra
        print barra,tamano_barra			;Se imprime la nueva barra


.movbarrafull1:
	mov qword [decenas],r14                         ;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15

	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	ir r8,r9,r10,r12
	print nbola,tamano_nbola

	movlateralBAJ r10,r12,[buffer]	;macro de calculo de movimiento lateral(Bajada)
.movlateralfull1:



	;Movimiento de bajada

	cmp r9,2617
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


;comprobacion de choque con barra

	cmp r8,2610
        je .bordebarra
        jmp .limiteinferior
.bordebarra:
        cmp r9,2613
	je .comprobarra
	jmp .limiteinferior

.comprobarra:
	mov r13,10
	mov r14,[decenas]
        mov r15,[unidades]
.revisarbarra:
        cmp r12,r15
        je .verifbarra
        jmp .aumdatos
.verifbarra:
        cmp r10,r14
        je .sube

.aumdatos:
	cmp r15,2617
        je .aumdec
        inc r15
        jmp .verificardec
.aumdec:
 	mov r15,2608
        inc r14
.verificardec:
        dec r13
        cmp r13,0
	jne .revisarbarra

.limiteinferior:
	cmp r8,2610				;comparacion de limite inferior
	je .limitebajo
	jmp .seguir
.limitebajo:
	cmp r9,2617				;salto a funcion de subir bola por estar en los limites
	je .menosvida
	jmp .seguir

.menosvida:					;Se pierde una vida
	inc word [vidas]
	cmp word [vidas],3
	je .fin
	cmp word [vidas],1
	je .2vidasrestantes
	cmp word [vidas],2
        je .1vidasrestantes

.2vidasrestantes:
	call Imp_bloques
	call Setbloques
	print nobarra,tam1
	print nobarra0,lennobarra0
	print msm_pierdevida,tamano_msm_pierdevida
	print msm_seguirjuego,tamano_msm_seguirjuego
	print vida2,tamano_vida2
        call Pausa
	print msm_npierdevida,tamano_msm_npierdevida
        print msm_noseguirjuego,tamano_msm_noseguirjuego
	jmp .ciclovidas

.1vidasrestantes:
        call Imp_bloques
        call Setbloques
	print nobarra,tam1
        print nobarra0,lennobarra0
	print msm_pierdevida,tamano_msm_pierdevida
	print vida1,tamano_vida1
        print msm_seguirjuego,tamano_msm_seguirjuego
        call Pausa
	print msm_npierdevida,tamano_msm_npierdevida
        print msm_noseguirjuego,tamano_msm_noseguirjuego
	jmp .ciclovidas

.seguir:
	jmp .baja






.sube:
        mov r14,100000000
.unidadesFs2:
        dec r14
        cmp r14,0
        jne .unidadesFs2



	mov word [let],1                                ;Limpia el contenido de [let]
        in_teclado let,1                                ;Copia, de ser posible, la tecla que se este presionando en [let]

        ;cmp word [let], 97                             ;Compara si la letra presionada es "a"
        ;je .fin
        cmp word [let], 120                             ;Compara si la letra presionada es "x"
        jne .continuar2                                 ;De ser verdadero salta al punto de pausa
	print msm_seguirjuego,tamano_msm_seguirjuego
        call Pausa
        print msm_noseguirjuego,tamano_msm_noseguirjuego
.continuar2:

        mov r14,qword [decenas]                         ;Se actualiza el valor del buffer decenas
        mov r15,qword [unidades]                        ;Se actualiza el valor del buffer unidades
        movbarraSUB r14,r15, word [let]                 ;"macro de calculo de movimiento lateral"
        ;mov qword [decenas],r14                                ;Se guarda el nuevo valor del buffer decenas
        ;mov qword [unidades],r15                       ;Se guarda el nuevo valor del buffer unidades

.updatebarraB:
        mov qword [decenas],r14                         ;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15                        ;Se guarda el nuevo valor del buffer unidades
        print nobarra,tam1                              ;Borra el espacio donde ya no se encuentra la barra
        mover r14,r15                                   ;Se mueve el cursor a la nueva posicion de la barra
        print barra,tamano_barra                        ;Se imprime la nueva barra


.movbarrafull2:
        mov qword [decenas],r14                         ;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15


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
	mov [buffer],word 0			;la variable buffer se usa como variable de estado para determinar si moverse hacia izquierda o derecha
	jmp .sal4
.sal3:
	mov [buffer],word 1
.sal4:

	mov [buffer1],r8
        mov [buffer2],r9
        mov [buffer3],r10
        mov [buffer4],r12



	cmp r8,2609                             ;comparacion de limite respecto a bloques 7,8 y 9
        je .bordebloque7
        jmp .compb456
.bordebloque7:
        cmp r9,2609
	je .comprobarchoque7
	jmp .compb456

.comprobarchoque7:
	cmp word [cb+48],0
	je .comprobarchoque8
	mov r13,16
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
        jmp .comprobarchoque8
.destruir7:
	inc word [bdestruidos]
        mov [cb+48],word 0
	call Destruirbloques


.comprobarchoque8:
	cmp word [cb+56],0
        je .comprobarchoque9
	mov r13,16
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
        jmp .comprobarchoque9
.destruir8:
	inc word [bdestruidos]
        mov [cb+56],word 0
        call Destruirbloques


.comprobarchoque9:
	cmp word [cb+64],0
        je .compb456
	mov r13,17
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
	jmp .compb456
.destruir9:
	inc word [bdestruidos]
        mov [cb+64],word 0
        call Destruirbloques



;----------------------------
.compb456:
	cmp r8,2608                             ;comparacion de limite respecto a bloques 4,5 y 6
        je .bordebloque4
        jmp .compb123
.bordebloque4:
        cmp r9,2616
	je .comprobarchoque4
	jmp .compb123

.comprobarchoque4:
	cmp word [cb+24],0
	je .comprobarchoque5
	mov r13,16
	mov r14,[db741]
        mov r15,[db741+8]
.c4:
        cmp r12,r15
        je .verifdecenas4
        jmp .aumdatos4
.verifdecenas4:
        cmp r10,r14
        je .destruir4

.aumdatos4:
	cmp r15,2617
        je .aumdec4
        inc r15
        jmp .verc4

.aumdec4:
 	mov r15,2608
        inc r14
.verc4:
        dec r13
        cmp r13,0
	jne .c4
        jmp .comprobarchoque5
.destruir4:
	inc word [bdestruidos]
        mov [cb+24],word 0
	call Destruirbloques


.comprobarchoque5:
	cmp word [cb+32],0
        je .comprobarchoque6
	mov r13,16
        mov r14,[db852]
        mov r15,[db852+8]
.c5:
        cmp r12,r15
        je .verifdecenas5
        jmp .aumdatos5
.verifdecenas5:
        cmp r10,r14
        je .destruir5

.aumdatos5:
        cmp r15,2617
        je .aumdec5
        inc r15
        jmp .verc5

.aumdec5:
        mov r15,2608
        inc r14
.verc5:
        dec r13
        cmp r13,0
        jne .c5
        jmp .comprobarchoque6
.destruir5:
	inc word [bdestruidos]
        mov [cb+32],word 0
        call Destruirbloques


.comprobarchoque6:
	cmp word [cb+40],0
        je .compb123
	mov r13,17
        mov r14,[db963]
        mov r15,[db963+8]
.c6:
        cmp r12,r15
        je .verifdecenas6
        jmp .aumdatos6
.verifdecenas6:
        cmp r10,r14
        je .destruir6

.aumdatos6:
        cmp r15,2617
        je .aumdec6
        inc r15
        jmp .verc6

.aumdec6:
        mov r15,2608
        inc r14
.verc6:
        dec r13
        cmp r13,0
        jne .c6
	jmp .compb123
.destruir6:
	inc word [bdestruidos]
        mov [cb+40],word 0
        call Destruirbloques



;----------------------------
.compb123:
	cmp r8,2608                             ;comparacion de limite respecto a bloques 1,2 y 3
        je .bordebloque1
        jmp .nochoque
.bordebloque1:
        cmp r9,2613
	je .comprobarchoque1
	jmp .nochoque

.comprobarchoque1:
	cmp word [cb],0
	je .comprobarchoque2
	mov r13,16
	mov r14,[db741]
        mov r15,[db741+8]
.c1:
        cmp r12,r15
        je .verifdecenas1
        jmp .aumdatos1
.verifdecenas1:
        cmp r10,r14
        je .destruir1

.aumdatos1:
	cmp r15,2617
        je .aumdec1
        inc r15
        jmp .verc1

.aumdec1:
 	mov r15,2608
        inc r14
.verc1:
        dec r13
        cmp r13,0
	jne .c1
        jmp .comprobarchoque2
.destruir1:
	inc word [bdestruidos]
        mov [cb],word 0
	call Destruirbloques


.comprobarchoque2:
	cmp word [cb+8],0
        je .comprobarchoque3
	mov r13,16
        mov r14,[db852]
        mov r15,[db852+8]
.c2:
        cmp r12,r15
        je .verifdecenas2
        jmp .aumdatos2
.verifdecenas2:
        cmp r10,r14
        je .destruir2

.aumdatos2:
        cmp r15,2617
        je .aumdec2
        inc r15
        jmp .verc2

.aumdec2:
        mov r15,2608
        inc r14
.verc2:
        dec r13
        cmp r13,0
        jne .c2
        jmp .comprobarchoque3
.destruir2:
	inc word [bdestruidos]
        mov [cb+8],word 0
        call Destruirbloques


.comprobarchoque3:
	cmp word [cb+16],0
        je .nochoque
	mov r13,17
        mov r14,[db963]
        mov r15,[db963+8]
.c3:
        cmp r12,r15
        je .verifdecenas3
        jmp .aumdatos3
.verifdecenas3:
        cmp r10,r14
        je .destruir3

.aumdatos3:
        cmp r15,2617
        je .aumdec3
        inc r15
        jmp .verc3

.aumdec3:
        mov r15,2608
        inc r14
.verc3:
        dec r13
        cmp r13,0
        jne .c3
	jmp .nochoque
.destruir3:
	inc word [bdestruidos]
        mov [cb+16],word 0
        call Destruirbloques


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
	call canonical_on				;Se vuelve a encender el modo canonico
	call echo_on					;Se vuelve a encender el echo
	irs 2611,2613,2608,2608
	mov rax,60
	mov rdi,0
	syscall


