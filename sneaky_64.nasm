global start

section .data
	msg db "Schelmische Dinge tun ;)", 0Ah
	lenMsg equ $ - msg
	ohNo db "Eh, kein Debugger bitte!", 0Ah
	lenOhNo equ $ - ohNo
	cmd db "/bin/sh"

%define SYS_write 1
%define SYS_ptrace 101
%define SYS_execve 59
%define SYS_exit 60

section .text
start:
	; ptrace (0, 0, 0, 0) // trace yourself
	mov rax, SYS_ptrace
	xor rdi, rdi 
	xor rsi, rsi
	xor rdx, rdx
	xor r8, r8
	syscall
	cmp rax, 0
	jnz debugged

	; write (1, "Schelmische Dinge tun ;)\n", 25)
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, msg
	mov rdx, lenMsg
	syscall

;start:
	; execve ("/bin/sh", NULL, NULL)
	mov rax, SYS_execve
	mov rdi, cmd 
	xor rsi, rsi
	xor rdx, rdx
	syscall

done:
	; exit (0)
	mov rax, SYS_exit
	xor rdi, rdi
	syscall

debugged:
	; write (1, "Eh, kein Debugger bitte!\n", 25)
	mov rax, SYS_write
	mov rdi, 1
	mov rsi, ohNo
	mov rdx, lenOhNo
	syscall
	jmp done

