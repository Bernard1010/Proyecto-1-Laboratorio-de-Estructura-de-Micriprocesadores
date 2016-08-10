%macro print 2                  ;Macro para imprimir datos a pantalla
        mov rax,1
        mov rdi,1
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro

section .data

		mns: db 'No se puede imprir los datos del cpu_id ',0xa
		tamano_mns: equ $-mns
		mns2: db '',0xa
		tamano_mns2: equ $-mns2

section .bss
		var: resb 32

section .text
		global _start
		global _default

	_start:

		mov rax,80000000H
		cpuid
		mov r8,80000004H
		cmp rax,r8
		jb _default

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
		print var,40
		print mns2,tamano_mns2

	; se termina el programa
		mov rax,60
		mov rdi,0
		syscall

	_default:				;"se escrime el mensaje en caso de no poder imprimir la informaciòn deseada"
		print mns,tamano_mns
		mov rax,60
		mov rdi,0
		syscall
