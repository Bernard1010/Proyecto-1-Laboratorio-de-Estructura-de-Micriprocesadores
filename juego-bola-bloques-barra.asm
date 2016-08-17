;Proyecto-1-Laboratorio-de-Estructura-de-Micriprocesadores/juego-bola-bloques-barra.asm
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

;macro para mover la bola lateralmente mientras baja en la pantalla
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

;macro para movimiento lateral de bola minetras se mueve hacia arriba
%macro movlateralSUB 3				;macro de calculo lateral para movimiento de bajada 
	mov r13,%3
	cmp r13,1                        	;comparacion de estado de r13 para saber a donde moverse
        je .subirderecha
        jmp .subirizquierda
.subirizquierda:                      		;movimiento horizontal izquierdo
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
.subirderecha:                      		;movimiento horizontal derecho
        cmp %2,2617
        je .decCsderecha2
        inc %2
        jmp .movlateralfull2			;moviimineto de desplazamiento lateral completado
.decCsderecha2:
        mov %2,2608
        inc %1
%endmacro

%macro mover 2					;Macro de posicionamiento del cursor especial para el movimiento de la barra
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
						;macro de calculo lateralde la barra  para movimiento de bajada de la bola
        cmp %3,99
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

.movizq:                      			;movimiento horizontal izquierdo
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
.movder:                      			;movimiento horizontal derecho
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
						;macro de calculo lateralde la barra  para movimiento de subida de la bola
        cmp %3,99
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

.movizqb:                      			;movimiento horizontal izquierdo
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

.movderb:                      			;movimiento horizontal derecho
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

%macro bolarandom 1
	cmp word [%1],0
	je .random0
	cmp word [%1],1
        je .random1
	cmp word [%1],2
        je .random2
	cmp word [%1],3
        je .random3
	cmp word [%1],4
        je .random4
	cmp word [%1],5
        je .random5
	cmp word [%1],6
        je .random6
	cmp word [%1],7
        je .random7
	cmp word [%1],8
        je .random8
	cmp word [%1],9
        je .random9

.random0:
	mov [buffer],word 0
	mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2612
	jmp .imparea

.random1:
        mov [buffer],word 0
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2615
        jmp .imparea
.random2:
        mov [buffer],word 1
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2609
        mov [buffer4],word 2616
        jmp .imparea
.random3:
        mov [buffer],word 1
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2610
        mov [buffer4],word 2608
        jmp .imparea
.random4:
        mov [buffer],word 1
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2610
        jmp .imparea
.random5:
        mov [buffer],word 1
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2613
        jmp .imparea
.random6:
        mov [buffer],word 0
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2612
        jmp .imparea
.random7:
        mov [buffer],word 0
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2611
        mov [buffer4],word 2614
        jmp .imparea
.random8:
        mov [buffer],word 1
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2609
        mov [buffer4],word 2615
        jmp .imparea
.random9:
        mov [buffer],word 0
        mov [buffer1],word 2610                         ;Inicializacion de posicion de la bola
        mov [buffer2],word 2612
        mov [buffer3],word 2609
        mov [buffer4],word 2612
        jmp .imparea

%endmacro



;----------------------PROCEDIMIENTOS------------------------------------
;Procedimiento para imprimimir los bordes del area de juego
Imp_limites:
        print screenset,screenset_len	;
	print techo,tamano_techo        ;imprimir techo
        print p_izq,tamano_p_izq        ;imprimir pared izquierda
        print p_der,tamano_p_der        ;imprimir pared derecha
        print piso,tamano_piso          ;imprimir piso
	ret
;Procedimiento para imprimir los bloques del juego
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
;Procedimiento para inicializar los datos de posicion de los bloques
Ini_datosbloques:
	mov [db741],word 2608
        mov [db741+8],word 2610

	mov [db852],word 2609
        mov [db852+8],word 2616

	mov [db963],word 2611
        mov [db963+8],word 2612
	ret
;Procedimiento para inicializar el arreglo con el estado de los bloques y variable contadora de contador de bloques destruidos
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
;Prpcedimiento para destruir los bloques
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
        cmp word [aleatorio],9
	je .re
	inc word [aleatorio]
	jmp .continua
.re:
	mov word [aleatorio],word 0

.continua:
	cmp word [let],120
	jne .pausa                                      ;De no ser "x" el juego sigue en pausa
	ret

;-----------------------Variables  y mensajes del Juego--------------------

segment .data
	;Bara del juego
	barra: db "▲▼▲▼▲▼▲▼▲"
	tamano_barra: equ $-barra

	;Varaible con caracteres de espacio para limpiar movimientos de barras
	nobarra:db 0x1b,"[26;2f", "                                                 "
	tam1: equ $-nobarra
	;Variable con caracteres de espacio para limpiar fondo del area de juego/al perder una vida la bola cae en este lugar
	nobarra0:db 0x1b,"[29;2f", "                                                 "
        lennobarra0: equ $-nobarra0

	vp: db "        "			;variable para almacenar codigos de ejecucion
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

        ;Mensaje de Salida con informacion del grupo y sistema
	msm_creditos: db 0x1b,"[46;30m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[9;15f","Estudiantes",0x1b,"[11;21f","Felipe Herrero",0x1b,"[12;21f","Bernardo Rodriguez",0x1b,"[13;21f","Sergio Gonzales",0x1b,"[14;21f","Alejandro Murillo"
	tamano_msm_creditos: equ $-msm_creditos

	;Instrucciones del juego
	msm_instrucciones: db 0x1b,"[5;55f","Moverse a la izquierda con Z",0x1b,"[7;55f","Moverse a la derecha con C",0x1b,"[9;55f","Pausar juego con X"
        tamano_msm_instrucciones: equ $-msm_instrucciones

        ;Mensaje de reiniciar el juego, se utiliza para devolver el color correcto a la pantalla
        msm_reset: db 0x1b, "[47;30m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[1;3f"," REINICIANDO PARTIDA"
        tamano_msm_reset: equ $-msm_reset

        ;Mensaje de Gane y seleccion de seguir o salir
        msm_gane1: db 0x1b, "[42;39m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[1;3f","                      █████████",0x1b,"[2;3f","   ██████          ███▒▒▒▒▒▒▒▒███",0x1b,"[3;3f","  █▒▒▒▒▒▒█       ███▒▒▒▒▒▒▒▒▒▒▒▒▒███",0x1b,"[4;3f","   █▒▒▒▒▒▒█    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[5;3f","    █▒▒▒▒▒█   ██▒▒▒▒▒██▒▒▒▒▒▒██▒▒▒▒▒███",0x1b,"[6;3f","     █▒▒▒█   █▒▒▒▒▒▒████▒▒▒▒████▒▒▒▒▒▒██",0x1b,"[7;3f","   █████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[8;3f","   █▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[9;3f"," ██▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██",0x1b,"[10;3f","██▒▒▒███████████▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒▒██",0x1b,"[11;3f","█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒████████▒▒▒▒▒▒▒██",0x1b,"[12;3f","██▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[13;3f"," █▒▒▒███████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[14;3f"," ██▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█",0x1b,"[15;3f","  ████████████   █████████████████",0x1b,"[17;3f","          FELICIDADES,JUEGO TERMINADO!!!",0x1b,"[19;3f","   Para salir del juego presiona la tecla N",0x1b,"[20;3f","  Para una nueva partida presiona la tecla S",0xa
        tamano_msm_gane1: equ $-msm_gane1

        ;Mensaje de pierde y seleccion de seguir o salir
        msm_pierde1: db 0x1b, "[41;39m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[1;1f","                  █████████",0x1b,"[2;1f","               ███▒▒▒▒▒▒▒▒▒███",0x1b,"[3;1f","             ███▒▒▒▒▒▒▒▒▒▒▒▒▒███",0x1b,"[4;1f","           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[5;1f","          ██▒▒▒▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒██",0x1b,"[6;1f","         ██▒▒▒▒▒████▒▒▒▒████▒▒▒▒▒▒██",0x1b,"[7;1f","         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[8;1f","         ██▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[9;1f","         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[10;1f","         ██▒▒▒▒▒▒▒▒███████▒▒▒▒▒▒▒▒██",0x1b,"[11;1f","         ██▒▒▒▒▒▒██▒▒▒▒▒▒▒██▒▒▒▒▒▒██",0x1b,"[12;1f","          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[13;1f","           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",0x1b,"[14;1f","             ███▒▒▒▒▒▒▒▒▒▒▒▒▒███",0x1b,"[15;1f","               ███████████████",0x1b,"[18;3f","Juego Finalizado. Mejor Suerte la Proxima Vez",0x1b,"[20;3f","  Para salir del juego presiona la tecla N",0x1b,"[21;3f"," Para una nueva partida presiona la tecla S",0xa
        tamano_msm_pierde1: equ $-msm_pierde1

	;Mensaje para iniciar juego
	msm_seguirjuego: db 0x1b,"[20;14f","Presione X para continuar"
	tamano_msm_seguirjuego: equ $-msm_seguirjuego

	;Mensaje para perdida de vidas
	msm_pierdevida: db 0x1b,"[15;13f","Intento Fallido → Pierde → ♥"
	tamano_msm_pierdevida: equ $-msm_pierdevida

	;Mensaje para perdida de vidas vacio
        msm_npierdevida: db 0x1b,"[15;12f","                             "
        tamano_msm_npierdevida: equ $-msm_npierdevida

	;Mensaje para iniciar juego vacio
        msm_noseguirjuego: db 0x1b,"[20;14f","                         "
        tamano_msm_noseguirjuego: equ $-msm_noseguirjuego

	;Reestable colores de letra y fondo y reinicio de consola
	color_set_normal: db 0x1b,"[1;1f",0x1b,"[40;37m",0x1b, "[J"
	tamano_color_set_normal: equ $-color_set_normal:

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
	;Bola del juego
	bola: db "○" 					;bola
	tamano_bola: equ $-bola
	;Bola del juego vacio
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

	mns: db 'No se puede imprir los datos del cpu_id ',0xa
        tamano_mns: equ $-mns
        mns2: db '',0xa
        tamano_mns2: equ $-mns2

	termios:        times 36 db 0                   ;Estructura de 36bytes que contiene el modo de opera$
        stdin:          equ 0                           ;Nombre de referencia a la hora de llamar el stdin
        ICANON:         equ 1<<1                        ;Valor de control para la posicion del bit del modo canonico
        ECHO:           equ 1<<3			;Valor de control para la posicion del bit del echo
	VTIME:          equ 5				;Posicion de la bandera VTIME dentro de cc_c
        VMIN:           equ 6				;Posicion de la bandera VMIN dentro de cc_c
        CC:             equ 18                          ;Posicion del arreglo cc_c del termios



segment .bss
	var: resb 50

	;Variable para guardar nombre del jugador
	nombre: resb 10
	let: resb 2

	;variable de estado de movimiento lateral de la bola
	buffer: resb 8
	;variables de almacenamiento de datos de movimiento de la bola
	buffer1: resb 8
	buffer2: resb 8
 	buffer3: resb 8
 	buffer4: resb 8

	;Arrelgo de estados de bloques
	cb: resb 72
	;datos de bloques
	db741: resb 16
	db852: resb 16
	db963: resb 16
	;variable para almacenar cantidad de blqoues destruidos
	bdestruidos: resb 8
	;Variables para almacenamineto de datos de movimiento de la barra
	contador: resb 8
	unidades: resb 8
	decenas: resb 8
	;Variable para la cantidad de vidas del jugador
	vidas: resb 8
	;Varaible que almacena numero para bola aleatoria
	brandom: resb 8

	aleatorio: resb 8
;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:

	print msm_bienvenida,tamano_msm_bienvenida	;imprimir mensaje de bienvenida y solicita nombre a usuario
	print centro,tamano_centro			;mueve cursor a siguiente posicion
	in_teclado nombre,10				; espera datos del usuario
.restart:
        print msm_reset,tamano_msm_reset
	;INICIALIZACION DE VARIABLES Y REGISTROS
	mov qword [decenas],2610			;Inicializacion de posision de la barra
	mov qword [unidades],2610

	;mov [buffer1],word 2610				;Inicializacion de posicion de la bola
        ;mov [buffer2],word 2612
        ;mov [buffer3],word 2611
        ;mov [buffer4],word 2610
	;mov [brandom],word 9
	;bolarandom brandom

	call Imp_limites				;imprime limites del juego
	call Imp_bloques				;imprime bloques del juego
	call Ini_datosbloques				;inicializa datos de bloques
	call Setbloques					;inicializa el estado de los bloques
	print msm_instrucciones,tamano_msm_instrucciones
	mov word [vidas],0

	mov r14,qword [decenas]				;posicion inicial de la barra
	mov r15,qword [unidades]
	mover r14,r15
	print barra,tamano_barra			;primera impresion de la barra

	call canonical_off				;Apaga el modo canonico
	call echo_off					;Apaga el echo

	irs 2611,2610,2612,2608				;imprimer nombre del jugador abajo del marco de juego
        print nombre,10

	print vida,tamano_vida				;imprime la cantidad de vida inicial
	print vida3,tamano_vida3

;------------------------------------------------------------------------------------------------------
	print msm_seguirjuego,tamano_msm_seguirjuego	;imprime mensaje de tecla requerida para iniciar
	mov [aleatorio],word 0
	call Pausa					;pausa de juego
	bolarandom aleatorio
	;mov [buffer],word 1				;establecimiento de direccion lateral inicial
	.imparea:
	print msm_noseguirjuego,tamano_msm_noseguirjuego;borra mensaje de tecla requerida para iniciar
	jmp .sube					;salto para que empiece a subir la bola INICIO DE JUEGO

	;Al perder una de las vidas regresa a este punto para reinicar valores de datos de juego y reimprimir bloques del juego
.ciclovidas:
	;RECARGA DE DATOS DEL JUEGO PARA EL REINICIO DE VIDA
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

	;irs 2610,2612,2609,2614
        ;print bola,tamano_bola
	jmp .sube
	;CICLO DE MOVIMIENTO DE BAJADA DE LA BOLA
.baja:							;ciclo de retraso para imprimir y controlar flujo del juego
	cmp word [bdestruidos],9			;Si la cantidad de bloques destruidos es 9, salta a la seccion de ganadores
	je .gano                                  ; Avisa al jugador que gano y espera la tecla X para salir
	mov r14,110000000
.unidadesFb1:
        dec r14
	cmp r14,0
        jne .unidadesFb1
	;SECCION DE VERIFICACION DE LETRAS EN EL TECLADO
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

.movbarrafull1:						;Movimiento de la barra efectuado

	mov qword [decenas],r14                         ;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15
							;Restablecimiento de varaibles de almacenamiento de posicion de la bola cargados
	mov r8,[buffer1]
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	ir r8,r9,r10,r12				;Se coloca cursor en posicion almacenada en los registros
	print nbola,tamano_nbola			;Se imprime la NoBola para borrar la bola anterior

	movlateralBAJ r10,r12,[buffer]			;"macro de calculo de movimiento lateralde la bola(Bajada)"
.movlateralfull1:					;Movimiento lateral de la bola efectuado
	;MOVIMIENTO DE BAJADA DE LA BOLA
	cmp r9,2617					;Para mover bola se incrementan los valores de los registros de la fila
	je .decenasFb1
	inc r9
	jmp .sal0
.decenasFb1:
	mov r9,2608
	inc r8
.sal0:
        ir r8,r9,r10,r12                		;posicion del cursor final para imprimir la nueva bola
        print bola,tamano_bola
	;COMPARACION DEL LIMITE IZQUIERDO
        cmp r10,2608                     		;comparacion de limite izquierdo decenas
        je .compuniizq1
	;COMPARACION DEL LIMITE DERECHO
        cmp r10,2613
	je .compunider1					;comparacion de limite derecho decenas
	jmp .sal2
.compuniizq1:
        cmp r12,2610
        je .sal1
	jmp .sal2
.compunider1:
        cmp r12,2608
        mov [buffer],word 0				;Si se esta al limite derecho pone un 0 en buffer para empezar a mover a la izquierda la bola
        jmp .sal2
.sal1:
        mov [buffer],word 1				;Si se esta al limite izquierdo pone un 1 en buffer para empezar a mover a la derecha la bola

.sal2:
	;Carga los nuevos valores a los buffers de posicion de la bola
	mov [buffer1],r8
        mov [buffer2],r9
        mov [buffer3],r10
        mov [buffer4],r12
	;COMPROBACION DE CHOQUES DE BOLA CON BARRA
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
	cmp r8,2610				;Coparacion de limite inferior del area de juego
	je .limitebajo
	jmp .seguir
.limitebajo:
	cmp r9,2617
	je .menosvida
	jmp .seguir
	;PERDIDA DE VIDAS AL LLEGAR AL FONDO
.menosvida:					;Se pierde una vida
	inc word [vidas]
	cmp word [vidas],3
	je .perdio                                ;Sin vidas extra sale y avisa al jugador que perdio
	cmp word [vidas],1
	je .2vidasrestantes
	cmp word [vidas],2
        je .1vidasrestantes

.2vidasrestantes:
	;REINICIO DE BLOQUES Y SUS CONDICIONES/SE INDUCE UNA PAUSA AL JUEGO Y REGRES AL CICLO
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
;REINICIO DE BLOQUES Y SUS CONDICIONES/SE INDUCE UNA PAUSA AL JUEGO Y REGRES AL CICLO
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
	jmp .baja					;Si no se ha llegado al limite ni tocado la barra se repite el proceso de bajada

;--------------------------------------------++++++++++++++++++--------------------------------------------------

;CICLO DE MOVIMIENTO DE SUBIDA DE LA BOLA
.sube:
        mov r14,90000000
.unidadesFs2:
        dec r14
        cmp r14,0
        jne .unidadesFs2

	mov word [let],1                                ;Limpia el contenido de [let]
        in_teclado let,1                                ;Copia, de ser posible, la tecla que se este presionando en [let]
        cmp word [let], 120                             ;Compara si la letra presionada es "x"
        jne .continuar2                                 ;De ser verdadero salta al punto de pausa
	print msm_seguirjuego,tamano_msm_seguirjuego
        call Pausa
        print msm_noseguirjuego,tamano_msm_noseguirjuego
.continuar2:
        mov r14,qword [decenas]                         ;Se actualiza el valor del buffer decenas
        mov r15,qword [unidades]                        ;Se actualiza el valor del buffer unidades
        movbarraSUB r14,r15, word [let]                 ;"macro de calculo de movimiento lateralde la barra"
.updatebarraB:
        mov qword [decenas],r14                         ;Se guarda el nuevo valor del buffer decenas
        mov qword [unidades],r15                        ;Se guarda el nuevo valor del buffer unidades
        print nobarra,tam1                              ;Borra el espacio donde ya no se encuentra la barra
        mover r14,r15                                   ;Se mueve el cursor a la nueva posicion de la barra
        print barra,tamano_barra                        ;Se imprime la nueva barra
.movbarrafull2:
        mov qword [decenas],r14                         ;Se guardan los nuevos valores de posicion de la barra en sus buffers
        mov qword [unidades],r15
	mov r8,[buffer1]				;Se recargan los valores de los buffers de posicion de la bola
        mov r9,[buffer2]
        mov r10,[buffer3]
        mov r12,[buffer4]

	ir r8,r9,r10,r12				;Se coloca cursor en posicion anterior a la bola
        print nbola,tamano_nbola			;Se imprime un espacio para borrar la bola anterior
	movlateralSUB r10,r12,[buffer]			;"macro de calculo de movimiento lateralde la bola(Subida)"
.movlateralfull2:					;Movimento lateral de la bola ya efectuado
	;MOVIMIENTO DE SUBIDA DE LA BOLA
	cmp r9,2608
        je .decenasFs2
        dec r9
        jmp .sal
.decenasFs2:
        mov r9,2617
        dec r8
.sal:
	ir r8,r9,r10,r12				;posicion del cursor final para imprimir
        print bola,tamano_bola
	;COMPARACION DEL LIMITE IZQUIERDO
	cmp r10,2608                     		;comparacion de limite izquierdo  unidades y decenas
        je .compuniizq2
	;COMPARACION DEL LIMITE DERECHO
	cmp r10,2613
        je .compunider2                 		;comparacion de limite derecho decenas
	jmp .sal4
.compuniizq2:
        cmp r12,2610
	je .sal3
	jmp .sal4
.compunider2:
        cmp r12,2608
	mov [buffer],word 0				;Si se esta al limite derecho pone un 0 en buffer para empezar a mover a la izquierda la bola
	jmp .sal4
.sal3:
	mov [buffer],word 1				;Si se esta al limite izquierdo pone un 1 en buffer para empezar a mover a la derecha la bola
.sal4:
							;Carga los nuevos valores de la posicion dela bola a sus buffers
	mov [buffer1],r8
        mov [buffer2],r9
        mov [buffer3],r10
        mov [buffer4],r12

	;COMPROBACION DE CHOQUES DE LA BOLA CON LOS BLOQUES

	cmp r8,2609                             	;comparacion de limite respecto a bloques 7,8 y 9/Si la bola esta en la fila donde estan los bloques 7,8 y 9
        je .bordebloque7
        jmp .compb456
.bordebloque7:
        cmp r9,2609
	je .comprobarchoque7
	jmp .compb456

	;Si la bola se encuentra en la fila correspondiente a estos bloques se compara el rango de las columnas y al estar la columna de la bola en la de algun blqoues este se destruye 
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.comprobarchoque7:
	cmp word [cb+48],0				;En al arreglo cb[condicion de bloques], se guarda un 0 en la posicion de memoria correspondiente al bloque
	je .comprobarchoque8				;Salto de comprobacion de choque del siguiente bloque
	mov r13,16
	mov r14,[db741]					;Variable con informacion de posicion de los bloques 7,4 y 1
        mov r15,[db741+8]				;Variable con informacion de posicion de los bloques 7,4 y 1
.c7:							;Ciclo para compribar si la bola esta dentro del rango de columnas del bloque
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
.destruir7:						;Si la columna de la bola esta dentro del rango del bloque este es destruido
	inc word [bdestruidos]				;Se incrementa la cantidad de bloques destruidos
        mov [cb+48],word 0				;Se coloca un 0 en la posicion de memoria del bloque 7/ Destruido
	call Destruirbloques				;"macro para borrar los bloques destruidos"
	;SE SIGUE EL PROCEDIMIENTO DE COMPROBACION DEL BLOQUE 7 PARA EL RESTO DE LOS BLOQUES
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;----------------------------COMPROBACION DE CHOQUE DE BOLA CON BLOQUES 4,5 Y 6--------------------------------------------
.compb456:					;Si la bola se encuentra en la fila de estos tres bloques comprueba la colision
	cmp r8,2608                             ;comparacion de limite respecto a bloques 4,5 y 6
        je .bordebloque4
        jmp .compb123
.bordebloque4:
        cmp r9,2616
	je .comprobarchoque4
	jmp .compb123
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;----------------------------COMPROBACION DE CHOQUE DE LA BOLA CON LOS BLOQUES 1,2 Y 3------------------------------------------------------------------------------
.compb123:					;Si la bola se encuentra en la fila de estos tres bloques comprueba la colision
	cmp r8,2608                             ;Comparacion de limite respecto a bloques 1,2 y 3
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
	;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	;COMPROBACION DE LIMITE SUPERIOR DEL AREA DE JUEGO
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
.gano:
        print msm_gane1,tamano_msm_gane1            	;despliega la pantalla del gane y espera la tecla X para salir
        ;call Pausa
       	mov rax,80000000H
	cpuid
	mov r8,80000004H
	cmp rax,r8
	;jb _default

	; obtienen los datos a imprimir 

	mov rax,80000002H
	cpuid
	mov [var],rax
	mov [var + 0x4],rbx; informacion de procesador
	mov [var + 0x8],rcx; identidicacion de la familia
	mov [var + 0xc],rdx; ; tipo de procesador

	mov rax,80000003H
	cpuid
	mov [var + 0x10],rax
	mov [var + 0x14],rbx; informacion de procesador
	mov [var + 0x18],rcx ;identidicacion de la familia
	mov [var + 0x1c],rdx; tipo de procesador

	mov rax,80000004H
	cpuid
	mov [var + 0x20],rax
	mov [var + 0x24],rbx; informacion de procesador
	mov [var + 0x28],rcx; identidicacion de la familia
	mov [var + 0x2c],rdx; tipo de procesador

	; se imprime los datos del cpu
	irs 2610,2615,2608,2608

	print var,50
	print mns2,tamano_mns2
	 jmp .if
.perdio:
        print msm_pierde1,tamano_msm_pierde1            	;despliega la pantalla de perdida y espera la tecla X para salir
        ;call Pausa
       	mov rax,80000000H
	cpuid
	mov r8,80000004H
	cmp rax,r8
	;jb _default
	; obtienen los datos a imprimir 

	mov rax,80000002H
	cpuid
	mov [var],rax
	mov [var + 0x4],rbx; informacion de procesador
	mov [var + 0x8],rcx; identidicacion de la familia
	mov [var + 0xc],rdx; ; tipo de procesador

	mov rax,80000003H
	cpuid
	mov [var + 0x10],rax
	mov [var + 0x14],rbx; informacion de procesador
	mov [var + 0x18],rcx ;identidicacion de la familia
	mov [var + 0x1c],rdx; tipo de procesador

	mov rax,80000004H
	cpuid
	mov [var + 0x20],rax
	mov [var + 0x24],rbx; informacion de procesador
	mov [var + 0x28],rcx; identidicacion de la familia
	mov [var + 0x2c],rdx; tipo de procesador

	; se imprime los datos del cpu
	irs 2610,2615,2608,2608
	print var,50
	print mns2,tamano_mns2
	jmp .if
.if:
        mov word [let],1                                ;Limpia variable let
        in_teclado let,1                                ;Copia, de ser posible, la tecla que se este presionando en [let]
        cmp word [let],110                              ;Compara si la letra presionada es "N"
        je  .fin                                        ;De no ser "N" el juego sigue en pausa y revisa por la siguiente tecla
	cmp word [let],115                              ;De no ser "S" el juego sigue en pausa
        je  .restart
        jmp .if

;.creditos:
;        print msm_creditos,tamano_msm_creditos
;        call .pausa
;        jmp .fin

.fin:
	call canonical_on				;Se vuelve a encender el modo canonico
	call echo_on					;Se vuelve a encender el echo
	print color_set_normal,tamano_color_set_normal
	mov rax,60
	mov rdi,0
	syscall




