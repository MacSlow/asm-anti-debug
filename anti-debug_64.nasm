global _start

%define	SYS_exit 60
%define	SYS_write 1
%define SYS_ptrace 101

;%define	SYS_exit 1
;%define	SYS_write 4
;%define SYS_execve 26

section .rodata
	noDebugMsg: db "No one is looking", 10
	noDebugLen: equ $-noDebugMsg
	debugMsg: db "I'm being debugged", 10
	debugLen: equ $-debugMsg

section .text
_start:
	xor		r8, r8
	xor		rdx, rdx
	xor		rsi, rsi
	xor		rdi, rdi
	mov		rax, SYS_ptrace
	dw		0x02EB
	dw		0x32F8
	syscall
	cmp		rax, 0
	je		noDebugging

	mov		rdx, debugLen
	mov		rsi, debugMsg
	mov		rdi, 1
	mov		rax, SYS_write
	syscall

done:
	xor		rdi, rdi
	mov		rax, SYS_exit
	syscall

noDebugging:
	mov		rdx, noDebugLen
	mov		rsi, noDebugMsg
	mov		rdi, 1
	mov		rax, SYS_write
	syscall
	jmp		done
