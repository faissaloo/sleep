BITS 32
global _start
section .data
	;Syscalls
	sys_nanosleep equ 162
	sys_exit equ 1
	timeval:
		tv_sec dd 0
		tv_usec dd 0
section .text
_start:
	dec dword [esp]
	jz _exit ;No arguments? Exit
	;first argument
	mov edi, [esp+8] ;Time argument
	_strToInt:
		mov dl, [edi]
		;non numeric characters are terminators
		sub dl, 48
		jle _strToIntEnd
		cmp dl, 10
		jge _strToIntEnd
		
		;Faster multiplication by 10 and add edx
		lea ebx, [eax*2+edx]
		lea eax, [eax*8+ebx]
		
		inc edi
		jmp _strToInt
	_strToIntEnd:
	;Result is in eax
	mov ebx, tv_sec ;We're moving it into ebx anyway
	mov [ebx],eax   ;why not use that to our advantage?
	mov eax, sys_nanosleep
	push _exit ;Jumps to _exit after the delay
	lea ebp, [esp-12]
	sysenter        ; Kernel interrupt
_exit:
	mov eax, sys_exit
	xor ebx, ebx
	mov ebp, esp
	sysenter
