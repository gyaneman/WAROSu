;boot.s

	org 0x7c00

	jmp entry
	db 0x90

	db "TESTOS  "	;name
	dw 512			;sector size:
	db 1			;cluster size
	dw 1			;fat pos
	db 2			;fat cnt
	dw 224			;root size
	dw 2880			;sector cnt
	db 0xf0			;media type
	dw 9			;fat size
	dw 18			;sector cnt pt
	dw 2			;head cnt
	dd 0			;bpb pos
	dd 2880			;sector cnt
	db 0,0,0x29		;drive no, reserved, ext boot code
	dd 0xffffffff	;volume serial
	db "TESTOS_BOOT"	;disk name
	db "FAT12   "		;fat name
	resb 18

entry:
	mov ax, 0
	mov ss, ax
	mov sp, 0x7c00
	mov ds, ax
	mov es, ax

	mov si, msg

putloop:
	mov al, [si]
	add si, 1
	cmp al, 0
	je fin
	mov ah, 0x0e
	mov bx, 15
	int 0x10
	jmp putloop

fin:
	hlt
	jmp fin

msg:
	db 0x0a, 0x0a
	db "hello, world"
	db 0x0a
	db 0


bootsign:
	times 510-($-$$) db 0
	db 0x55, 0xaa
