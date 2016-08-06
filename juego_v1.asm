;--------------------------MACROS--------------------------------------


%macro print 2		;Macro para imprimir datos a pantalla
	mov rax,1
        mov rdi,1
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro


%macro in_teclado 2     ;Macro para tomar datos del teclado
        mov rax,0
	mov rdi,0
	mov rsi,%1	;Argumento 1-variable para guardar datos
	mov rdx,%2	;Argumento 2-numero de bytes a guardar
	syscall
%endmacro
;----------------------PROCEDIMIENTOS------------------------------------

Imp_limites:
	print techo,tamano_techo        ;imprimir techo
        print p_izq,tamano_p_izq        ;imprimir pared izquierda
        print p_der,tamano_p_der        ;imprimir pared derecha
        print piso,tamano_piso          ;imprimir piso
	ret


Imp_bloques:
	print b1,tamano_b1
	print b2,tamano_b2
	print b3,tamano_b3
	ret

;-----------------------Variables y mensajes del Juego--------------------

segment .data
	;Techo
	techo: db 0x1b,"[47;30m" ,0x1b,"[1;1f",0x1b, "[J","--------------------------------------------------"
	tamano_techo: equ $-techo

	;Piso
        piso: db 0x1b,"[30;1f",0x1b, "[J","--------------------------------------------------"     
        tamano_piso: equ $-piso


	;Pared izquierda
	p_izq: db  0x1b,"[2;1f","|",0x1b,"[3;1f","|",0x1b,"[4;1f","|",0x1b,"[5;1f","|",0x1b,"[6;1f","|",0x1b,"[7;1f","|",0x1b,"[8;1f","|",0x1b,"[9;1f","|",0x1b,"[9;1f","|",0x1b,"[10;1f","|",0x1b,"[11;1f","|",0x1b,"[12;1f","|",0x1b,"[13;1f","|",0x1b,"[14;1f","|",0x1b,"[15;1f","|",0x1b,"[16;1f","|",0x1b,"[17;1f","|",0x1b,"[18;1f","|",0x1b,"[19;1f","|",0x1b,"[20;1f","|",0x1b,"[21;1f","|",0x1b,"[22;1f","|",0x1b,"[23;1f","|",0x1b,"[24;1f","|",0x1b,"[25;1f","|",0x1b,"[26;1f","|",0x1b,"[27;1f","|",0x1b,"[28;1f","|",0x1b,"[29;1f","|"
        tamano_p_izq: equ $-p_izq

	 ;Pared derecha
        p_der: db  0x1b,"[2;50f","|",0x1b,"[3;50f","|",0x1b,"[4;50f","|",0x1b,"[5;50f","|",0x1b,"[6;50f","|",0x1b,"[7;50f","|",0x1b,"[8;50f","|",0x1b,"[9;50f","|",0x1b,"[9;50f","|",0x1b,"[10;50f","|",0x1b,"[11;50f","|",0x1b,"[12;50f","|",0x1b,"[13;50f","|",0x1b,"[14;50f","|",0x1b,"[15;50f","|",0x1b,"[16;50f","|",0x1b,"[17;50f","|",0x1b,"[18;50f","|",0x1b,"[19;50f","|",0x1b,"[20;50f","|",0x1b,"[21;50f","|",0x1b,"[22;50f","|",0x1b,"[23;50f","|",0x1b,"[24;50f","|",0x1b,"[25;50f","|",0x1b,"[26;50f","|",0x1b,"[27;50f","|",0x1b,"[28;50f","|",0x1b,"[29;50f","|"
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


	;Mensaje de Bienvenida y solicitud de nombre a jugador
	msm_bienvenida: db 0x1b,"[46;30m" ,0x1b,"[1;1f",0x1b, "[J" ,0x1b,"[9;15f","Bienvenido a Micronoid",0x1b,"[11;4f","EL-4313-Lab. Estructura de Microprocesadores",0x1b,"[13;21f","2S-2016",0x1b,"[15;11f","Ingrese el nombre del jugador:"
	tamano_msm_bienvenida: equ $-msm_bienvenida

	;Reestable colores de letra y fondo y reinicio de consola
	color_set_normal: db 0x1b,"[1;1f",0x1b,"[40;37m",0x1b, "[J"
	tamano_color_set_normal: equ $-color_set_normal:

	;Posicion para recibir nombre del jugador
	centro: db 0x1b,"[16;19f"
	tamano_centro: equ $-centro


segment .bss
	nombre: resb 10 	;varaible de almacenamiento de nombre
	let: resb 2		;variable de almacenamiento de letras del teclado

;--------------------------CODIGO PRINCIPAL------------------------------------

segment .text
	global _start
	global _primero
	global _segundo

_start:
	;---------Creacion de limites del juego--------------------------



	print msm_bienvenida,tamano_msm_bienvenida	;imprimir mensaje de bienvenida y solicita nombre a usuario
	print centro,tamano_centro			;mueve cursor a siguiente posicion
	in_teclado nombre,10				; espera datos del usuario

	call Imp_limites				;imprime limites del juego
	call Imp_bloques				;imprime bloques del juego
	mov r10,3					;registro de control de bloques destruidos

	mov r15,1					;registros de control del ciclo de destruccion de bloques 
	mov r14,1					;""
	mov r13,1					;""

.juego:
	print centro,tamano_centro                      ;mueve cursor a siguiente posicion
        in_teclado let,2				;entrada de datos del teclado

	mov rax,[let]					;Traslado de datos de entrada a registro
	cmp rax,2657					;compara valor decimal del dato de entrada con uno preestablecido ("a")
	je .ruta1					;salto  a etiqueta ruta1

	cmp rax,2682					;compara valor decimal del dato de entrada con uno preestablecido ("z")
	je .ruta2					;salto a etiqueta ruta2

	cmp rax,2659					compara valor decimal del dato de entrada con uno preestablecido ("c")
	je .ruta3					;salto a etiqueta ruta3

	jmp .juego					;si ninguna comparacion se cumple, se realiza salto para cerrar ciclo

.ruta1:
	cmp r15,0					;compara el registro de control para determinar si antes se habia pasado por ruta1
	je .juego					;si se cumple que ya paso por esta seccion una vez, regresa a juego
	dec r15						;se decrementa r15 para tener control de que ya se paso por esta parte del codigo


	print nb1,tamano_nb1				;"elimina" Bloque1
	dec r10						;decrementa registro de control(los tres bloques destruidos)
	cmp r10,0					;si r10 es igual a 0, todos los bloques estan destruidos por ende  juego terminado
	je .fin
	jmp .juego
.ruta2:
	cmp r14,0
        je .juego
        dec r14

        print nb2,tamano_nb2
	dec r10
	cmp r10,0
        je .fin
        jmp .juego

.ruta3:
	cmp r13,0
        je .juego
        dec r13

        print nb3,tamano_nb3
	dec r10
	cmp r10,0
        je .fin
        jmp .juego


.fin:
	print color_set_normal,tamano_color_set_normal		;reinicio de consola
	mov rax,60
	mov rdi,0
	syscall



