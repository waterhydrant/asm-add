section .data
	msg1: db "Enter the first number: "
	msg2: db "Enter the second number: "
	msg3: db "The sum is "
	newline: db 10

section .bss
	buf1: resb 100 ; buffer for input 1
	buf2: resb 100 ; buffer for input 2 
	output: resb 100 ; buffer for output

section .text
	global _start
	extern atoi_signed
	extern stoi_signed

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, 24
	syscall ; first prompt

	xor rax, rax
	xor rdi, rdi
	mov rsi, buf1
	mov rdx, 100
	syscall ; second prompt

	mov rdi, buf1
	mov rsi, rdi
	add rsi, rax
	dec rsi ; exclude \n character
	call atoi_signed ; convert first input to number

	mov rbx, rax ; rbx stores the first number

	mov rax, 1
	mov rdi, 1
	mov rsi, msg2
	mov rdx, 25
	syscall ; second prompt

	xor rax, rax
	xor rdi, rdi
	mov rsi, buf2
	mov rdx, 100
	syscall ; second input

	mov rdi, buf2
	mov rsi, rdi
	add rsi, rax
	dec rsi
	call atoi_signed ; convert second input to number

	add rbx, rax ; adds the two numbers
	
	mov rdi, output
	mov rsi, rdi
	add rsi, 100
	mov rdx, rbx
	call stoi_signed ; convert output to string

	mov rbx, rax ; rbx stores the number of bytes used
	mov rax, 1
	mov rdi, 1
	mov rsi, msg3
	mov rdx, 1
	syscall ; prints output message

	mov rsi, output
	mov rdx, rbx
	mov rax, 1
	mov rdi, 1
	syscall

	mov rsi, newline
	mov rdx, 1
	mov rax, 1
	mov rdi, 1
	syscall ; prints newline

	mov rax, 60
	mov rdi, 0
	syscall
