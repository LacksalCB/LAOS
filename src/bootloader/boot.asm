[BITS 16]
[ORG 0x7C00]

start:
	cli                 ; disable interrupt
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

	mov [boot_drive], dl

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

	; Set up disk segments/GDT
	mov ax, 0x1000
	mov es, ax
	xor bx, bx
	mov ah, 0x02
	mov al, 20
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, [boot_drive]
	int 0x13

	mov si, msg_load_gdt
	call print_string

	lgdt [gdt_descriptor]

	mov si, msg_entering_pe
	call print_string

	; Enter protected mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp 0x08:protected_entry

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

; GDT
gdt_start:
	dq 0

gdt_code:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10011010b
	db 11001111b
	db 0x00

gdt_data:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00

gdt_end:
	
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd 0x00007C00

boot_drive: 
	db 0

; Prints
msg_loading db "Loading kernel...", 0
msg_check_a20 db "Checking A20...", 0
msg_a20 db "A20 enabled", 0
msg_load_gdt db "Loading GDT...", 0
msg_entering_pe db "Entering protected Mode...", 0


[BITS 32]
protected_entry:
	; Set up data segments
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Set up stack
	mov ax, 0x10
	mov ss, ax
	mov esp, 0x0009FB00

	mov edi, 0x000B8000
	mov byte [edi], 'X'
	mov byte [edi+1], 0x0F

	call print_32

	; Print if this works	
	jmp 0x10000

	cli
	hlt
	jmp $

print_32:
	pushad
	mov edi, 0x000B8000

.next_char_32:
	lodsb
	test al, al
	jz .done_32

	mov [edi], al
	mov byte [edi+1], 0x0F
	add edi, 2
	jmp .next_char_32

.done_32:
	popad
	ret

msg_jmp_kernel db "Jumping to kernel...", 0

times 510-($-$$) db 0
dw 0xAA55

