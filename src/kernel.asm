org 0x7E00
jmp 0x0000:start

PlayerInfoY dw 172              
BlockInfoX dw 320               
BlockInfoY dw 172               
JumpH dw 0                      
JumpInfo dw 0  
GameOver dw 0
Score dw 0

JakeH dw 28
JakeW dw 20

; 20x28
jake db 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,0,0,43,43,43,43,43,43,43,0,0,3,3,3,3,3,3,3,3,0,43,43,43,43,43,43,43,43,43,43,43,0,3,3,3,3,3,3,0,43,43,43,43,43,43,43,43,43,43,43,43,43,0,3,3,3,3,3,0,43,43,15,15,15,43,43,43,43,43,43,15,15,0,3,3,3,3,0,43,0,15,15,15,15,15,43,43,43,43,15,15,15,15,0,3,3,3,0,43,0,15,15,15,15,15,0,0,0,0,0,15,15,0,0,3,3,0,43,43,0,0,15,15,0,0,43,0,0,0,43,0,0,0,0,3,3,0,43,43,0,0,0,0,43,43,43,43,43,43,43,43,0,0,0,3,3,0,43,43,43,0,0,0,43,43,43,43,0,43,43,43,0,43,0,3,3,0,43,43,0,43,0,0,43,43,43,0,43,0,43,43,0,0,3,3,3,3,0,0,43,43,43,0,43,43,0,43,43,43,0,43,0,3,3,3,3,0,43,43,43,43,43,0,43,43,0,43,43,43,0,43,0,0,3,3,0,43,43,0,43,43,43,43,0,0,43,43,43,43,0,0,43,0,0,3,0,43,0,43,43,43,43,43,43,43,43,43,43,43,43,43,43,0,43,0,0,43,0,43,43,43,43,43,43,43,43,43,43,43,43,43,43,0,43,0,0,43,0,43,43,43,43,43,43,43,43,43,43,43,43,43,43,0,43,0,0,43,43,0,43,43,43,43,43,43,43,43,43,43,43,43,43,0,0,3,3,0,43,43,0,43,43,43,43,43,43,43,43,43,43,43,43,0,3,3,0,43,0,43,0,43,43,43,43,43,43,43,43,43,43,43,0,0,3,3,0,43,0,0,0,43,43,43,43,43,43,43,43,43,43,0,3,3,3,3,3,0,43,43,0,43,43,0,0,0,0,0,0,43,43,0,3,3,3,3,3,3,0,0,0,43,0,3,3,3,3,3,3,0,43,0,3,3,3,3,3,3,3,3,0,43,0,3,3,3,3,3,3,0,43,0,3,3,3,3,3,3,3,0,43,43,0,3,3,3,3,3,3,0,43,43,0,3,3,3,3,3,3,0,43,43,0,3,3,3,3,3,3,0,43,43,0,3,3,3,3,3,3,3,0,0,0,3,3,3,3,3,3,0,0,0,3,3,3,3
 
StartVideo:
    mov ah, 0                   
    mov al, 0x13           
    int 10h
    ret

Delay:
    push cx                    
    push dx
    mov cx, 0                  
    mov dx, 800               
    mov ah, 86h                 
    int 15h 
    pop dx                     
    pop cx
    ret                          

DrawSky:
    mov cx, 0
    mov dx, 23

    MainSky:
        call SubSky
        mov cx, 0
        inc dx
        cmp dx, 173
        jne MainSky
        ret

    SubSky
        mov ah, 0xC
        mov bh, 0
        mov al, 3
        int 10h
        inc cx
        cmp cx, 320
        jne SubSky
        ret

DrawFloor:
    mov cx, 0                   
    mov dx, 173

    MainFloor:                  
        call SubFloor           
        mov cx, 0               
        inc dx                  
        cmp dx, 200             
        jne MainFloor           
        ret                     

    SubFloor:                   
        mov ah, 0xC             
        mov bh, 0
        mov al, 0xE             
        int 10h
        inc cx                  
        cmp cx, 320             
        jne SubFloor            
        ret                     

DrawPlayer:
    mov cx, 30                  
    mov dx, word[PlayerInfoY]   
    mov si, dx                  
    sub si, word[JakeH]
    mov bp, 560
    MainPlayer:                 
        mov di, bp
        sub di, 20
        sub bp, 20
        call SubPlayer      
        ;call Delay    
        mov cx, 30             
        dec dx                 
        cmp dx, si             
        jne MainPlayer          
        ret                     
    SubPlayer:                  
        mov ah, 0xC             
        mov bh, 0
        mov al, [jake + di]
        inc di             
        int 10h 
        inc cx                 
        cmp cx, 50             
        jne SubPlayer           
        ret                     

DrawCleanPlayer:
    mov cx, 30
    LoopCleanX:
        mov ah, 0xC
        mov bh, 0
        mov al, 3
        int 10h
        inc cx
        cmp cx, 50
        jne LoopCleanX
    ret

CheckInput:                     
    mov ah, 01h                 
    int 16h
    jz CheckInputEnd

    ProcessInput:              
        mov ah, 00h
        int 16h
        cmp al, 'r'
        je EndGame
        cmp al, ' '
        je DoJump

    CheckInputEnd:
    ret

DoJump:
    cmp word[PlayerInfoY], 172
    je Go
    ret 
    Go:
    mov word[JumpInfo], 1
    ret

UpPlayer:   
    mov bx, word[GameOver]
    cmp bx, 1
    je EndGame
    mov dx, word[PlayerInfoY]
    mov ax, word[JumpH]
    cmp ax, 100
    jne GoUp
    call DownPlayer
    ret
    GoUp:
        inc ax
        dec dx
        mov word[PlayerInfoY], dx
        mov word[JumpH], ax
        inc dx
        call DrawCleanPlayer
        ret

DownPlayer:
    mov bx, word[GameOver]
    cmp bx, 1
    je EndGame
    mov dx, word[PlayerInfoY]
    mov ax, word[JumpH]
    cmp ax, 0
    jne GoDown
    ret
    GoDown:
        dec ax
        inc dx
        mov word[PlayerInfoY], dx
        mov word[JumpH], ax
        mov bx, 0
        mov word[JumpInfo], bx
        sub dx, 31
        call DrawCleanPlayer
        ret

MainJump:
    mov ax, word[JumpInfo]
    cmp ax, 1
    je IncY
    call DownPlayer
    ret
    IncY:
        call UpPlayer
        ret


BlockAnimation:
    mov cx, word[BlockInfoX]
    cmp cx, -31
    jne CoreAnimation
    mov word[BlockInfoX], 319
    mov ax, word[Score]
    inc ax
    mov word[Score], ax
    ret
    CoreAnimation:
        call DrawBlock
        call Delay
        mov cx, word[BlockInfoX]
        call DrawCleanBlock
        call Delay
        sub cx, 31
        mov word[BlockInfoX], cx
    ret

DrawBlock:
    mov dx, 172
    mov si, cx
    MainBlock:
        call SubBlock
        mov cx, word[BlockInfoX]
        dec dx
        cmp dx, 110
        jne MainBlock
        ret
    SubBlock:
        cmp cx, 320
        jc GoNext
        ret
        GoNext:
        cmp cx, 0
        jnc GoNext2
        ret 
        GoNext2:
        mov ah, 0xC
        mov bh, 0
        mov al, 2
        int 10h
        inc cx
        ret
    ret

DrawCleanBlock:
    add cx, 30
    cmp cx, 320
    jc GoNextBlock 
    ret
    GoNextBlock:
        mov dx, 172
        LoopCleanY:
            mov ah, 0xC
            mov bh, 0
            mov al, 3
            int 10h
            dec dx
            cmp dx, 110
            jne LoopCleanY
        ret
    ret


CheckGameStatus:
    mov ax, 30
    mov bx, word[BlockInfoX]
    add ax, word[JakeW]
    cmp ax, bx
    jae CheckY
    ret
    CheckY:
        mov ax, word[PlayerInfoY]
        cmp ax, 110
        jae Over
        ret
        Over:
            mov word[GameOver], 1
            ret

Restart:
    mov ax, 30
    mov bx, 172
    mov cx, 320
    mov word[PlayerInfoY], bx
    mov word[BlockInfoX], cx
    mov word[BlockInfoY], bx
    xor ax, ax
    mov word[GameOver], ax
    mov word[JumpH], ax
    mov word[JumpInfo], ax
    mov word[Score], ax
    jmp start


msg db "Score : ",0

PrintScore:  
    xor ax, ax
    xor bx, bx
    xor cx, cx

    mov ah, 2
    mov bh, 0
    mov dh, 1  
    mov dl, 28
    int 10h

    xor esi, esi
    mov si, msg
    call PrintSI   
    call PrintScoreNumber
    ret

PrintScoreNumber:
    mov ax, word[Score]
    mov cx, 10
    mov si, 0

    StackInit:
        mov dx, 0
        div cx
        add dl, '0'
        push dx
        inc si
        cmp ax, 0
        jnz StackInit
    
    Print:
        pop dx
        mov al, dl        
        mov ah, 0Eh        ; paǵina
        mov bl, 54     ; cor
        int 10h
        ; if eax is zero, we can quit
        dec si
        cmp si, 0
        jnz Print

    ret

start:
    call StartVideo
    call DrawSky
    call DrawFloor

    MainGame:
        call DrawPlayer
        call BlockAnimation
        call CheckInput
        call MainJump
        call CheckGameStatus
        call PrintScore
        jmp MainGame

EndGame:
    call PrintEnd
    CheckRestart:
        mov ah, 01h                 
        int 16h
        jz CheckRestartEnd

        ProcessEnd:              
            mov ah, 00h
            int 16h
            cmp al, ' '
            je Restart

        CheckRestartEnd:
        jmp CheckRestart


PrintSI:
    SubPrintSI:
        lodsb           
        cmp al, 0       
        je EndPrintSI     
        mov ah, 0Eh     
        mov bh, 0       
        mov bl, 54     
        int 10h
        jmp SubPrintSI
    EndPrintSI:
    ret

msg_end db "Your score is ", 0
msg_of_restart db "Press SPACE to restart...", 0
PrintEnd:
    call StartVideo
    xor ax, ax
    xor bx, bx
    xor cx, cx

    mov ah, 2
    mov bh, 0
    mov dh, 10  
    mov dl, 12
    int 10h

    xor esi, esi
    mov si, msg_end
    call PrintSI
    call PrintScoreNumber
    
    mov ah, 2
    mov bh, 0
    mov dh, 12  
    mov dl, 8
    int 10h

    xor esi, esi
    mov si, msg_of_restart
    call PrintSI

    ret   