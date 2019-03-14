BITS 16 
org 0x500 
jmp 0x0000:start 

data:

start:

xor ax, ax 
mov ds, ax

mov ah, 0
mov al, 12h 
int 10h

mov ah, 0xb
mov bh, 0   
mov bl, 0x3
int 10h


mov ah, 2
mov bh, 0
mov dh, 13  
mov dl, 33
int 10h

mov si, msg 

print:
    lodsb           
    cmp al, 0       
    je loading      
    mov ah, 0Eh     
    mov bh, 0       
    mov bl, 0x21    
    int 10h
    call delay4
    jmp print  

loading:
    mov ch, 6      
    lop:           
        mov ah, 2    
        mov bh, 0
        mov dh, 14 
        mov dl, 40
        int 10h
        mov ah, 0x0E 
        mov al, '\'  
        int 0x10  
        call delay2
        mov ah, 2
        mov bh, 0
        mov dh, 14 
        mov dl, 40
        int 10h
        mov ah, 0x0E  
        mov al, '|'   
        int 0x10   
        call delay2
        mov ah, 2
        mov bh, 0
        mov dh, 14
        mov dl, 40
        int 10h
        mov ah, 0x0E  
        mov al, '/'   
        int 0x10  
        call delay2
        dec ch      
        cmp ch, 0  
        jne lop     
        jmp reset  


delay4:
    pusha
    push ds
    mov  ax, 0
    mov  ds, ax
    mov  cx, 3      
    mov  bx, [46Ch] 

dif:
nodif:
    mov  ax, [46Ch] 
    cmp  ax, bx     
    je   nodif      
    mov  bx, ax
    loop dif        
    pop  ds
    popa
    ret


delay2:
    pusha
    push ds
    mov  ax, 0
    mov  ds, ax
    mov  cx, 2
    mov  bx, [46Ch]

dif1:
nodif1:
    mov  ax, [46Ch]
    cmp  ax, bx
    je   nodif1
    mov  bx, ax
    loop dif1
    pop  ds
    popa
    ret


reset:
mov ah, 0 
mov dl, 0 
int 13h
jc reset 

mov ax, 0x7E0 
mov es, ax 
xor bx, bx

ler:
mov ah, 0x02 
mov al, 0x06 
mov ch, 0x00 
mov cl, 0x04 
mov dh, 0 
mov dl, 0 
int 13h
jc ler 


jmp 0x7E0:0x0 

msg db "ADVENTURE TIME", 0