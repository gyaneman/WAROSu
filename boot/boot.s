;boot.s

CYLS equ 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	times 18 db 0


entry:
	mov AX, 0
	mov ss, ax
	mov sp, 0x7c00
	mov ds, ax
	mov es, ax
	
	mov si, boot_msg

printmsg_loop:
	mov al, [si]
	inc si
	cmp al, 0
	je read_disk
	mov ah, 0x0e
	mov bx, 15
	int 0x10
	jmp printmsg_loop

read_disk:
	mov ax, 0x0820
	mov es, ax
	xor ch, ch
	mov dh, ch
	mov cl, 2

loop_read:
	mov si, 0

retry:
	mov ah, 0x02
	mov al, 1
	mov bx, 0
	mov dl, 0x00
	int 0x13
	jnc next
	inc si
	cmp si, 5
	jae exit
	xor ah, ah
	mov dl, ah
	int 0x13
	jmp retry

next:
	mov ax, es
	add ax, 0x0020
	mov es, ax
	inc cl
	cmp cl, 18
	jb loop_read
	mov cl, 1
	inc dh
	cmp dh, 2
	jb loop_read
	mov dh, 0
	add ch, 1
	cmp ch, CYLS
	jb loop_read

	;jmp exit
;nomally_exit
	mov si, exit_msg
loop_nomally:
	mov al, [si]
	inc si
	cmp al, 0
	je exit
	mov ah, 0x0e
	mov bx, 15
	int 0x10
	jmp loop_nomally

exit:
	hlt
	jmp exit


boot_msg:
	db "hello,world..."
	db 0x0a, 0

exit_msg:
	db "nomally exit!!"
	db 0x0a, 0


bootsign:
	times 510-($-$$) db 0
	db 0x55, 0xaa
