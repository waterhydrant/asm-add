section .text
	global atoi
	global reverse
	global stoi
        global atoi_signed
        global stoi_signed

; function signature: pointer to the string in rdi, pointer to end of the string (exclusive) in rsi, return value in rax
; rdx contains status code: 0 on success, 1 on overflow error
atoi:
	xor rax, rax
	mov r8, 10 ; we are working with base 10
atoi_loop:
	cmp rdi, rsi
	jae atoi_end

	movzx rcx, byte[rdi]

	cmp rcx, '0'
	jb atoi_end
	cmp rcx, '9'
	ja atoi_end

	mul r8 ; rax = rax * 10
	jc atoi_overflow

	sub rcx, '0'
	add rax, rcx
	jc atoi_overflow

	inc rdi
	jmp atoi_loop

atoi_end:
	ret	

atoi_overflow:
	mov rdx, 1
	ret

; function signature: pointer to the string in rdi, pointer to end of the string (exclusive) in rsi, return value in rax
; rdx contains status code: 0 on success, 1 on overflow error
atoi_signed:
    xor rax, rax
    mov r8, 10 ; base 10
    xor rcx, rcx ; sign flag (0 = positive)
    cmp byte[rdi], '-'
    jne atoi_signed_check_positive
    inc rcx ; set sign flag (1 = negative)
    inc rdi
    jmp atoi_signed_loop

atoi_signed_check_positive:
    cmp byte[rdi], '+'
    jne atoi_signed_loop
    inc rdi

atoi_signed_loop:
    cmp rdi, rsi
    jae atoi_signed_end

    movzx r9, byte[rdi]
    cmp r9, '9'
    ja atoi_signed_end
    cmp r9, '0'
    jb atoi_signed_end

    mul r8
    jo atoi_signed_overflow

    sub r9, '0'
    add rax, r9
    jo atoi_signed_overflow

    inc rdi
    jmp atoi_signed_loop

atoi_signed_end:
    test rcx, rcx
    jz atoi_signed_ret
    neg rax

atoi_signed_ret:
    ret

atoi_signed_overflow:
    mov rdx, 1
    ret

; function signature: pointer to the string in rdi, pointer to end of the string in rsi (exclusive), no return value
reverse:
	dec rsi

reverse_loop:
	cmp rdi, rsi
	jae reverse_end

	mov cl, byte[rdi]
	mov dl, byte[rsi]
	mov byte[rdi], dl
	mov byte[rsi], cl

	inc rdi
	dec rsi
	jmp reverse_loop

reverse_end:
	ret

; function signature: pointer to buffer start in rdi, pointer to end of buffer in rsi (exclusive), number in rdx
; rax contains number of bytes used, rdx contains status code: 0 on success, 1 on buffer overflow
stoi:
	test rdx, rdx
	jz stoi_zero ; special treatment for 0

	mov rax, rdx ; store number in rax
	xor rdx, rdx ; for division purposes
	mov r8, 10 ; base 10
	mov r9, rdi ; copy start of buffer pointer
stoi_loop:
	test rax, rax
	jz stoi_end ; jump if rcx = 0

	cmp rdi, rsi
	jae stoi_error

	div r8 ; quotient in rax, remainder in rdx
	add rdx, '0'
	mov byte[rdi], dl
    xor rdx, rdx

	inc rdi
	jmp stoi_loop

stoi_zero:
	mov byte[rdi], '0'

stoi_end:
	mov rax, rdi ; pointer to last used
	sub rax, r9 ; rax stores the number of bytes used
    push rax
	mov rsi, rdi ; end of buffer
	mov rdi, r9 ; start of buffer
	call reverse

	pop rax
	xor rdx, rdx
	ret

stoi_error:
	mov rdx, 1
	ret

; function signature: pointer to buffer start in rdi, pointer to buffer end in rsi (exclusive), number in rdx
; rax contains number of bytes used, rdx contains status code: 0 on success, 1 on buffer overflow
stoi_signed:
    mov r8, 10 ; base 10
    mov r9, rdi ; copy of buffer start
    mov r10, rdi ; buffer start for reversal
    mov rax, rdx ; number stored in rax
    xor rdx, rdx ; rdx is 0 for division purposes
    test rax, rax
    jz stoi_signed_zero
    jns stoi_signed_loop
    neg rax
    mov byte[rdi], '-'
    inc rdi
    inc r10 ; we don't reverse the negative sign in the end

stoi_signed_loop:
    test rax, rax
    jz stoi_signed_end

    cmp rdi, rsi
    jae stoi_signed_error

    div r8
    add rdx, '0'
    mov byte[rdi], dl ; moving the digit

    xor rdx, rdx ; for next division
    inc rdi
    jmp stoi_signed_loop

stoi_signed_zero:
    mov byte[rdi], '0'

stoi_signed_end:
    mov rax, rdi
    sub rax, r9
    push rax

    mov rsi, rdi
    mov rdi, r10
    call reverse

    pop rax
    xor rdx, rdx
    ret

stoi_signed_error:
    mov rdx, 1
    ret
