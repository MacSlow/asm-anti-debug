global _start

%define	SYS_exit 1
%define	SYS_write 4
%define SYS_ptrace 26

section .rodata
	noDebugMsg: db "No one is looking", 10
	noDebugLen: equ $-noDebugMsg
	debugMsg: db "I'm being debugged", 10
	debugLen: equ $-debugMsg

section .text
_start:
	xor		esi, esi
	xor		edx, edx
	xor		ecx, ecx
	xor		ebx, ebx
	mov		eax, SYS_ptrace
	dw		0x03EB
	dw		0xC0DE
	db		0xE8
	int		0x80
	cmp		eax, 0
	je		noDebugging

	mov		edx, debugLen
	mov		ecx, debugMsg
	mov		ebx, 1
	mov		eax, SYS_write
	int		0x80

done:
	xor		ebx, ebx
	mov		eax, SYS_exit
	int		0x80

noDebugging:
	mov		edx, noDebugLen
	mov		ecx, noDebugMsg
	mov		ebx, 1
	mov		eax, SYS_write
	int		0x80
	jmp		done
