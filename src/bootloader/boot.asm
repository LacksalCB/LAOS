[BITS 16]
[ORG 0x7C00]

start:
	cli                 ; disable interrupt
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

	; Sanity Check print
	mov si, msg_loading
	call print_string

	; Check a20
	mov si, msg_check_a20
	call print_string

	call get_a20_state
	cmp ax, 0x01
	; If not set, loop
	jne .no_a20

	; If present, let the user know
	mov si, msg_a20
	call print_string

.no_a20:
	hlt 
	jmp $

print_string:
	mov ah, 0x0E
.print_loop:
	lodsb
	or al, al
	jz .done
	int 0x10
	jmp .print_loop
.done:
	mov al, 0x0D
	int 0x10
	mov al, 0x0A
	int 0x10
	ret

; Checks if a20 is set
; ret: ax (0 - disabled, 1 - enabled)
get_a20_state:
	pushf
	push si
	push di
	push ds
	push es
	cli

	mov ax, 0x0000				
	mov ds, ax
	mov si, 0x0500

	not ax						
	mov es, ax
	mov di, 0x0510

	mov al, [ds:si]					
	mov byte [.BufferBelowMB], al
	mov al, [es:di]
	mov byte [.BufferOverMB], al

	mov ah, 1
	mov byte [ds:si], 0
	mov byte [es:di], 1
	mov al, [ds:si]
	cmp al, [es:di]					
	jne .exit
	dec ah
.exit:
	mov al, [.BufferBelowMB]
	mov [ds:si], al
	mov al, [.BufferOverMB]
	mov [es:di], al
	shr ax, 8					
	pop es
	pop ds
	pop di
	pop si
	popf
	ret
	
	.BufferBelowMB:	db 0
	.BufferOverMB	db 0

msg_check_a20 db "Checking A20...", 0
msg_a20 db "A20 enabled", 0

msg_loading db "Loading kernel...", 0

times 510-($-$$) db 0
dw 0xAA55

