.model small
.stack
.386

;variables
;main procedure -> calls draw calendar -> sets default month to april (calls setApril)
;draw calendar -> sets up calendar skeleton -> calls title stuff
;title stuff -> sets legend and title
;setApril -> sets up April days
;setMay
;setJune
;setJuly
;N -> Next month. Check current month
;P -> Previous month. Check previous month
;if at max or min month, `End of Calendar` msg
;can navigate using respective month number

.data

nam db 'A M R   H A M M A M'
namEND label byte
titl db 'C A L E N D A R  2 0 1 7'
titlEND label byte

inst db 'INSTRUCTIONS: follow legend or press month number'
instEND label byte

nex db 'N = NEXT'
nexEND label byte
prv db 'P = PREVIOUS'
prvEND label byte
xit db 'ESC = END'
xitEND label byte

sun db 'SUN'
sunEND label byte

mon db 'MON'
monEND label byte

tue db 'TUE'
tueEND label byte

wed db 'WED'
wedEND label byte

thu db 'THU'
thuEND label byte

fri db 'FRI'
friEND label byte

sat db 'SAT'
satEND label byte

apr db 'APRIL 2017'
aprEND label byte

may db 'MAY 2017'
mayEND label byte

jun db 'JUNE 2017'
junEND label byte

jul db 'JULY 2017'
julEND label byte

err1 db '! BEGINNING OF CALENDAR - NO PREVIOUS MONTH !'
err1END label byte

err2 db '! END OF CALENDAR - NO NEXT MONTH !'
err2END label  byte


.code

main proc
    mov ax,@data
    mov ds,ax
    mov ax,0300h
    int 10h
    sub ax,ax
    mov ah,3h
    mov bh,0
    int 10h
    mov ax,0b800h
    mov es,ax


    
April:
    mov ax,0b800h
    mov ah,160
    call clearscr
    call titlestuff
    call drawcal
    call setapril
    call nocursor

input:
    mov ah,10h
    int 16h
    cmp al, 6eh
    je May1
    cmp al, 1bh
    je quit
    cmp al,70h
    je error1
    cmp al,35h
    je May1
    cmp al,36h
    je June
    cmp al,37h
    je July
    jmp input
    
    
May1:
    mov ax,0b800h
    mov ah,160
    call clearscr
    call titlestuff
    call drawcal
    call setmay

input2:
    mov ah,10h
    int 16h
    cmp al,6eh
    je June
    cmp al,70h
    je April
    cmp al,1bh
    je quit
    cmp al,34h
    je April
    cmp al,36h
    je June
    cmp al,37h
    je July
    jmp input2
    
June:
    mov ax,0b00h
    mov ah,160
    call clearscr
    call titlestuff
    call drawcal
    call setjune
    
input3:
    mov ah,10h
    int 16h
    cmp al,6eh
    je July
    cmp al,70h
    je May1
    cmp al,1bh
    je quit
    cmp al,35h
    je May1
    cmp al,34h
    je April
    cmp al,37h
    je July
    jmp input3
    
July:
    mov ax,0b00h
    mov ah,160
    call clearscr
    call titlestuff 
    call drawcal
    call setjuly
    
input4:
    mov ah,10h
    int 16h
    cmp al,70h
    je June
    cmp al,1bh
    je quit
    cmp al,6eh
    je error2
    cmp al,35h
    je May1
    cmp al,36h
    je June
    cmp al,34h
    je April
    jmp input4
    
    
quit:
    call clearscr
    .exit
    
error1:
    call noprev
    jmp input

error2:
    call nonext
    jmp input4


main endp

drawcal proc

    pusha 
    int 10h
   
    ;cx for size
    ;bx for loc
    mov cx, 50
    add bx, 350
    upper:
        mov word ptr es:[bx],02deh
        add bx,2
        loop upper
        
    mov cx, 18
    mov bx, 350
    left:
        mov word ptr es:[bx],02dch
        add bx,160
        loop left

 
    mov cx, 18
    mov bx, 450
    right:
        mov word ptr es:[bx],02dch
        add bx,160
        loop right
        
    mov cx, 50
    mov bx,3230
    lower:
        mov word ptr es:[bx],02deh
        add bx,2
        loop lower
        
        
        sub ax,ax
        sub bx,bx
        sub cx,cx
        sub dx,dx
    popa
    ret

drawcal endp

titlestuff proc
    
    pusha
    int 10h
    
    mov ax,@data
    mov ds,ax
    mov ah,0eh
    
    mov cx,(offset namEND -offset nam)
    mov si,offset nam
    mov di,120
    nameL:
        mov al, byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop nameL
    
    mov ah,2fh
    mov cx,(offset titlEND -offset titl)
    mov si,offset titl
    mov di,216
    titleL:
        mov al, byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop titleL
    mov ah,0   
    mov ah,34h
    mov cx,(offset nexEND -offset nex)
    mov si,offset nex
    mov di,640
    nextL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop nextL
    mov ah,0  
    mov ah,34h
    mov cx,(offset prvEND -offset prv)
    mov si,offset prv
    mov di,800
    prevL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop prevL
    
    mov ah,0
    mov ah,0fh
    mov cx,(offset instEND -offset inst)
    mov si,offset inst
    mov di,3390
    instL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop instL
    mov ah,0    
    mov ah,4eh
    mov cx,(offset xitEND -offset xit)
    mov si,offset xit
    mov di,1280
    xitL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop xitL
        
    mov ah,0
    mov ah,09h
    mov cx,(offset sunEND -offset sun)
    mov si, offset sun
    mov di, 680
    sunL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop sunL
        
   mov ah,0
   mov ah,09h
   mov cx,(offset monEND -offset mon)
   mov si, offset mon
   mov di, 692
   monL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop monL
        
   mov ah,0
   mov ah,09h
   mov cx,(offset tueEND -offset tue)
   mov si, offset tue
   mov di, 706
   tueL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop tueL
        
    mov ah,0
    mov ah,09h
    mov cx,(offset wedEND -offset wed)
    mov si, offset wed
    mov di, 718
    wedL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop wedL
    
    mov ah,0
    mov ah,09h
    mov cx,(offset thuEND -offset thu)
    mov si, offset thu
    mov di, 730
    thuL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop thuL
        
    mov ah,0
    mov ah,09h
    mov cx,(offset friEND -offset fri)
    mov si,offset fri
    mov di,742
    friL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop friL
    
    mov ah,0
    mov ah,09h
    mov cx,(offset satEND -offset sat)
    mov si,offset sat
    mov di,754
    satL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop satL
    
    mov ah,0
    popa
    ret
    
titlestuff endp

setapril proc
    
    pusha
    mov ax,@data
    mov ds,ax
    
    ;1002 start of first line
    mov bx, 1076
    mov byte ptr es:[bx], '1'
    mov bx, 1322
    mov byte ptr es:[bx], '2'
    mov byte ptr es:[bx+12], '3'
    mov byte ptr es:[bx+26], '4'
    mov byte ptr es:[bx+38], '5'
    mov byte ptr es:[bx+50], '6'
    mov byte ptr es:[bx+62], '7'
    mov byte ptr es:[bx+74], '8'
    mov bx, 1642
    mov byte ptr es:[bx], '9'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '0'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '1'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '2'
    mov byte ptr es:[bx+50], '1'
    mov byte ptr es:[bx+52], '3'
    mov byte ptr es:[bx+62], '1'
    mov byte ptr es:[bx+64], '4'
    mov byte ptr es:[bx+74], '1'
    mov byte ptr es:[bx+76], '5'
    mov bx, 1962
    mov byte ptr es:[bx],'1'
    mov byte ptr es:[bx+2],'6'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '7'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '8'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '9'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '0'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '1'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '2'
    mov bx,2282
    mov byte ptr es:[bx],'2'
    mov byte ptr es:[bx+2],'3'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+14], '4'
    mov byte ptr es:[bx+26], '2'
    mov byte ptr es:[bx+28], '5'
    mov byte ptr es:[bx+38], '2'
    mov byte ptr es:[bx+40], '6'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '7'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '8'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '9'
    mov bx,2602
    mov byte ptr es:[bx],'3'
    mov byte ptr es:[bx+2],'0'
    
    mov ah,0
    mov ah,20h
    mov cx,(offset aprEND -offset apr)
    mov si,offset apr
    mov di,3110
    aprL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop aprL
        
    mov ah,0

    popa
    ret
    
setapril endp

setmay proc
    
    pusha
    mov ax,@data
    mov ds,ax
    
    mov bx, 1014
    mov byte ptr es:[bx], '1'
    mov byte ptr es:[bx+14], '2'
    mov byte ptr es:[bx+26], '3'
    mov byte ptr es:[bx+38], '4'
    mov byte ptr es:[bx+50], '5'
    mov byte ptr es:[bx+62], '6'
    mov bx, 1322
    mov byte ptr es:[bx], '7'
    mov byte ptr es:[bx+12], '8'
    mov byte ptr es:[bx+26], '9'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '0'
    mov byte ptr es:[bx+50], '1'
    mov byte ptr es:[bx+52], '1'
    mov byte ptr es:[bx+62], '1'
    mov byte ptr es:[bx+64], '2'
    mov byte ptr es:[bx+74], '1'
    mov byte ptr es:[bx+76], '3'
    mov bx, 1642
    mov byte ptr es:[bx], '1'
    mov byte ptr es:[bx+2], '4'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '5'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '6'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '7'
    mov byte ptr es:[bx+50], '1'
    mov byte ptr es:[bx+52], '8'
    mov byte ptr es:[bx+62], '1'
    mov byte ptr es:[bx+64], '9'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '0'
    mov bx, 1962
    mov byte ptr es:[bx],'2'
    mov byte ptr es:[bx+2],'1'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+14], '2'
    mov byte ptr es:[bx+26], '2'
    mov byte ptr es:[bx+28], '3'
    mov byte ptr es:[bx+38], '2'
    mov byte ptr es:[bx+40], '4'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '5'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '6'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '7'
    mov bx,2282
    mov byte ptr es:[bx],'2'
    mov byte ptr es:[bx+2],'8'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+14], '9'
    mov byte ptr es:[bx+26], '3'
    mov byte ptr es:[bx+28], '0'
    mov byte ptr es:[bx+38], '3'
    mov byte ptr es:[bx+40], '1'
    
    
    mov ah,0
    mov ah,20h
    mov cx,(offset mayEND -offset may)
    mov si,offset may
    mov di,3110
    mayL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop mayL
        
    mov ah,0

    popa
    ret
    
setmay endp

setjune proc
    
    pusha
    mov ax,@data
    mov ds,ax
    
    mov bx, 1052
    mov byte ptr es:[bx], '1'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+24], '3'
    mov bx, 1322
    mov byte ptr es:[bx], '4'
    mov byte ptr es:[bx+12], '5'
    mov byte ptr es:[bx+26], '6'
    mov byte ptr es:[bx+38], '7'
    mov byte ptr es:[bx+50], '8'
    mov byte ptr es:[bx+62], '9'
    mov byte ptr es:[bx+74], '1'
    mov byte ptr es:[bx+76], '0'
    mov bx, 1642
    mov byte ptr es:[bx], '1'
    mov byte ptr es:[bx+2], '1'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '2'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '3'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '4'
    mov byte ptr es:[bx+50], '1'
    mov byte ptr es:[bx+52], '5'
    mov byte ptr es:[bx+62], '1'
    mov byte ptr es:[bx+64], '6'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '7'
    mov bx, 1962
    mov byte ptr es:[bx],'1'
    mov byte ptr es:[bx+2],'8'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '9'
    mov byte ptr es:[bx+26], '2'
    mov byte ptr es:[bx+28], '0'
    mov byte ptr es:[bx+38], '2'
    mov byte ptr es:[bx+40], '1'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '2'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '3'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '4'
    mov bx,2282
    mov byte ptr es:[bx],'2'
    mov byte ptr es:[bx+2],'5'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+14], '6'
    mov byte ptr es:[bx+26], '2'
    mov byte ptr es:[bx+28], '7'
    mov byte ptr es:[bx+38], '2'
    mov byte ptr es:[bx+40], '8'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '9'
    mov byte ptr es:[bx+62], '3'
    mov byte ptr es:[bx+64], '0'
    
    mov ah,0
    mov ah,20h
    mov cx,(offset junEND -offset jun)
    mov si,offset jun
    mov di,3110
    juneL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop juneL
        
    mov ah,0

    popa
    ret
    
setjune endp

setjuly proc
    
    pusha
    mov ax,@data
    mov ds,ax
    
    ;1002 start of first line
    mov bx, 1076
    mov byte ptr es:[bx], '1'
    mov bx, 1322
    mov byte ptr es:[bx], '2'
    mov byte ptr es:[bx+12], '3'
    mov byte ptr es:[bx+26], '4'
    mov byte ptr es:[bx+38], '5'
    mov byte ptr es:[bx+50], '6'
    mov byte ptr es:[bx+62], '7'
    mov byte ptr es:[bx+74], '8'
    mov bx, 1642
    mov byte ptr es:[bx], '9'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '0'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '1'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '2'
    mov byte ptr es:[bx+50], '1'
    mov byte ptr es:[bx+52], '3'
    mov byte ptr es:[bx+62], '1'
    mov byte ptr es:[bx+64], '4'
    mov byte ptr es:[bx+74], '1'
    mov byte ptr es:[bx+76], '5'
    mov bx, 1962
    mov byte ptr es:[bx],'1'
    mov byte ptr es:[bx+2],'6'
    mov byte ptr es:[bx+12], '1'
    mov byte ptr es:[bx+14], '7'
    mov byte ptr es:[bx+26], '1'
    mov byte ptr es:[bx+28], '8'
    mov byte ptr es:[bx+38], '1'
    mov byte ptr es:[bx+40], '9'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '0'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '1'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '2'
    mov bx,2282
    mov byte ptr es:[bx],'2'
    mov byte ptr es:[bx+2],'3'
    mov byte ptr es:[bx+12], '2'
    mov byte ptr es:[bx+14], '4'
    mov byte ptr es:[bx+26], '2'
    mov byte ptr es:[bx+28], '5'
    mov byte ptr es:[bx+38], '2'
    mov byte ptr es:[bx+40], '6'
    mov byte ptr es:[bx+50], '2'
    mov byte ptr es:[bx+52], '7'
    mov byte ptr es:[bx+62], '2'
    mov byte ptr es:[bx+64], '8'
    mov byte ptr es:[bx+74], '2'
    mov byte ptr es:[bx+76], '9'
    mov bx,2602
    mov byte ptr es:[bx],'3'
    mov byte ptr es:[bx+2],'0'
    mov byte ptr es:[bx+14],'3'
    mov byte ptr es:[bx+16],'1'
    
    
    mov ah,0
    mov ah,20h
    mov cx,(offset julEND -offset jul)
    mov si,offset jul
    mov di,3110
    julyL:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop julyL
        
    mov ah,0

    popa
    ret
    
setjuly endp



nocursor proc

    pusha
    
    mov ah,3
    int 10h
    or ch,30h
    mov ah,1
    int 10h
    
    popa
    ret

nocursor endp

noprev proc
    
    pusha
    int 10h
    mov ax,@data
    mov ds, ax
    
    mov ah,0
    mov ah,0b4h
    mov cx,(offset err1END -offset err1)
    mov si,offset err1
    mov di,3876
    msg1:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop msg1
    mov ah,0
    
    popa
    ret
noprev endp

nonext proc
    
    pusha
    int 10h
    mov ax,@data
    mov ds, ax
    
    mov ah,0
    mov ah,0b4h
    mov cx,(offset err2END -offset err2)
    mov si,offset err2
    mov di,3884
    msg2:
        mov al,byte ptr [si]
        inc si
        mov es:[di],ax
        add di,2
        loop msg2
    mov ah,0
    
    
    popa
    ret
nonext endp

clearscr proc
    
    pusha
    
    mov ax,0b800h
    mov cx,25*80
    sub bx,bx
    mov ax,0720h
    clearL:
        mov es:[bx],ax
        add bx,2
        loop clearL   
    
    
    popa    
    ret
    
clearscr endp

END main