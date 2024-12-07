PlotLine macro xA,yA,xB,yB,colorofline
    LOCAL dxGTdy,dxNGTdy,xaGTxb
    LOCAL xaNGTxb,yaGTyb,yaNGTyb,xaDONExb,yaDONEyb,dxDONEdy
    ;temporary storing
    mov al,colorofline
    mov linecolor,al

    mov ax,xa
    mov xatmp,ax
    
    mov ax,xb
    mov xbtmp,ax
    
    mov ax,ya
    mov yatmp,ax
    
    mov ax,yb
    mov ybtmp,ax
    
    ;computing delX and delY
    mov ax,yB
    sub ax,yA
    mov bx,xB
    sub bx,xA
    ;taking absolute values and storing
    call absval
    mov tmpdelY,ax  
    
    
    
    mov ax,bx
    call absval
    mov tmpdelX,ax
    mov ax,tmpdelx
    mov bx,tmpdely
   
    
    
    
    cmp ax,bx
    jg dxGTdy
    jmp dxNGTdy
    ;abs[dy]<abs[dx].......
    dxGTdy:
    mov ax,xA
    mov bx,xB
    cmp ax,bx
    jg xaGTxb
    jmp xaNGTxb
    
    
    ;XA>XB.................
    xaGTxb:
        ;mov ax,xb
        ;mov bx,yb
        ;mov cx,xa
        ;mov dx,ya
        ;PlotLineLow x1,y1,x02,y02
        PlotLineLow xbtmp,ybtmp,xatmp,yatmp
    ;exit to inner endif
    jmp xaDONExb
    
    ;XA NOT > XB
    xaNGTxb:
    ;PlotLineLow x02,y02,x1,y1
    PlotLineLow xatmp,yatmp,xbtmp,ybtmp
    
    xaDONExb: ;endif
    
    jmp dxDONEdy ;exit to end
    ;.........................
    
    ;abs[dy] NOT <abs[dx]..........
    dxNGTdy:
    
    mov cx,yB;
    mov dx,yA;
    
    
    cmp dx,cx
    jg yaGTyb                            
    jmp yaNGTyb
    
    yaGTyb:
    ;PlotLineHigh x1,y1,x02,y02
    PlotLineHigh xbtmp,ybtmp,xatmp,yatmp
    ;exit of inner endif
    jmp yaDONEyb
    
    yaNGTyb:
    ;PlotLineHigh x02,y02,x1,y1
    PlotLineHigh xatmp,yatmp,xbtmp,ybtmp
    
    yaDONEyb:
    
    dxDONEdy:
    
endm
  
drawcircle macro xc,yc,r,color
  local circleloop,cond,exitloop

  mov ax,xc
  mov x0,ax
  
  mov ax,yc
  mov y0,ax
  
  mov ax,r
  mov circleradius,ax

    ;         xcircle = 0;
    ;         ycircle = circleradius;
    ;         circleerror = -circleradius; 
    mov ax,circleradius
    mov ycircle,ax
    neg ax
    mov circleerror,ax
    
    mov al,color
    mov circolor,al
circleloop:
call circlepoints
;inc circolor
call inccirclepoints
;while (xcircle <= ycircle)
    mov ax,xcircle
    mov bx,ycircle
    cmp ax,bx
    jg exitloop
    jmp circleloop   ;jump to circleloop

    exitloop:
endm


PlotLineLow macro xintL,yintL,xfinL,yfinL 
    LOCAL condL,overcondL,errGzeroL,elseL,outL,yloopL
;PlotLineHigh proc
;requires values in y1 y02 x1 x02
                                                                                                                                
;mov ax,y1  ;moving y1  to ax
;sub ax,y02  ;subtracting y02 from y1
;mov bx,x1  ;moving x1 to ax
;sub bx,x02  ;subtracting x02 from x1      
;........................................
mov ax,yfinL  ;moving y1  to ax
sub ax,yintL  ;subtracting y02 from y1
mov bx,xfinL  ;moving x1 to ax
sub bx,xintL  ;subtracting x02 from x1
;........................................
mov delx,bx ; moving dx to delx
mov dely,ax ; moving dy to dely

mov dx,1
mov yi,dx

;..................
;if (dy)<0

cmp ax,0
jl condL
jmp overcondL
condL:
mov dx,-1
mov yi,dx
neg ax
mov dely,ax  
overcondL:           

;end if
;..................
;D=2dy-dx
mov ax,dely
add ax,dely
sub ax,delx       
mov error,ax
;..................

;mov si,x02
mov si,yintL ;.............................

mov y02temp,si ;duplication y02
;mov dx,y02
mov dx,xintL ;..............................
mov x02temp,dx ;duplication x02
mov dx,0
mov cx,delx
;for x from x02 to x1

yloopL:
mov drawloop,cx
mov dx,y02temp
mov cx,x02temp
;call pixel ;plot pixel
mov al,linecolor
plotpixel cx,dx,al
inc cx
mov x02temp,cx

;.............
;if D>0
cmp error,0
jg errGzeroL
jmp elseL
;if error>0
;-----------------
errGzeroL:
;y=y+yi
add dx,yi
mov y02temp,dx
;.............
;D=D+2(dy-dx)
mov bx,dely
sub bx,delx
mov dymindx,bx
add bx,dymindx
add bx,error
mov error,bx
jmp outL
;-----------------
elseL:
mov bx,dely
add bx,dely
add bx,error
mov error,bx
jmp outL

outL:        

mov cx,drawloop
loop yloopL

;plotlinehigh endp
endm
 
PlotLineHigh macro xint,yint,xfin,yfin
    LOCAL condH,overcondH,errGzeroH,elseH,outH,yloopH 
;PlotLineHigh proc
;requires values in y1 y02 x1 x02
                                                                                                                                
;mov ax,y1  ;moving y1  to ax
;sub ax,y02  ;subtracting y02 from y1
;mov bx,x1  ;moving x1 to ax
;sub bx,x02  ;subtracting x02 from x1      
;........................................
mov ax,yfin  ;moving y1  to ax
sub ax,yint  ;subtracting y02 from y1
mov bx,xfin  ;moving x1 to ax
sub bx,xint  ;subtracting x02 from x1
;........................................
mov delx,bx ; moving dx to delx
mov dely,ax ; moving dy to dely

mov dx,1
mov xi,dx

;..................
;if (dx)<0

cmp bx,0
jl condH
jmp overcondH
condH:
mov dx,-1
mov xi,dx
neg bx
mov delx,bx  
overcondH:           

;end if
;..................
;D=2dx-dy
mov ax,delx
add ax,delx
sub ax,dely       
mov error,ax
;..................

;mov si,x02
mov si,xint ;.............................

mov x02temp,si ;duplication x02
;mov dx,y02
mov dx,yint ;..............................
mov y02temp,dx ;duplication y02
mov cx,dely
;for y from y02 to y1

yloopH:
mov drawloop,cx
mov dx,y02temp
mov cx,x02temp
;call pixel ;plot pixel
mov al,linecolor
plotpixel cx,dx,al
inc dx
mov y02temp,dx

;.............
;if D>0
cmp error,0
jg errGzeroH
jmp elseH
;if error>0
;-----------------
errGzeroH:
;x=x+xi
add cx,xi
mov x02temp,cx
;.............
;D=D+2(dx-dy)
mov bx,delx
sub bx,dely
mov dxmindy,bx
add bx,dxmindy
add bx,error
mov error,bx
jmp outH
;-----------------
elseH:
mov bx,delx
add bx,delx
add bx,error
mov error,bx
jmp outH

outH:        

mov cx,drawloop
loop yloopH

;plotlinehigh endp
endm


plotpixel macro xi, yi, color
;AH=0Ch AL = Color, CX = x, DX = y
    mov al,color
    mov cx,xi
    mov dx,yi
    
    mov ah, 0ch 
    int 10h 
    
endm

startvideomode macro mode,color
    mov ax, 0a000h
    mov es, ax    
    
    mov ah, 0
    mov al, mode
    int 10h
    
    
;Set background/border color 
;AH=0Bh, BH = 00h   BL = Background/Border color (border only in text modes)
    mov ah,0Bh   ;set config
    mov bh,00h   
    mov bl,color   ;choose color as background color
    int 10h
endm

printchar macro x,y,char,color

mov  dl, x   ;Column
mov  dh, y  ;Row
;mov  bh, 0    ;Display page
mov  ah, 02h  ;SetCursorPosition
int  10h

mov  al, char
mov  bl, color  ;Color is red
;mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype 
int  10h

endm


sinr macro radius 
 call sin
 mov cx,radius
 mul cx
 mov cx,10004
 div cx
endm
cosr macro radius 
 call cos
 mov cx,radius
 mul cx
 mov cx,10004
 div cx
endm


quadrantloop macro theta,rad,xcen,ycen
local QD2,QD3,QD4,quadext

;QD1:
mov ax,theta
cmp ax,15
JA  QD2
  mov cx,6
  mul cx
  sinr rad
  mov cx,ycen
  sub cx,ax
  mov y,cx
  mov ax,theta
  mov cx,6
  mul cx
  cosr rad
  add ax,xcen
  mov x,ax
jmp quadext
QD2: 
mov ax,theta
cmp ax,30
JA  QD3
   mov cx,6
  mul cx 
  sinr rad
 
 
 mov cx,ycen
  sub cx,ax
  mov y,cx
  
  mov ax,theta

    mov cx,6
  mul cx
  cosr rad

   mov cx,xcen
  sub cx,ax

  mov x,cx
jmp quadext
QD3:
mov ax,theta
cmp ax,45
JA  QD4
  mov cx,6
  mul cx
  sinr rad
  add ax,ycen
  mov y,ax
  mov ax,theta
  mov cx,6
  mul cx
  cosr rad
  mov cx,xcen
  sub cx,ax
  mov x,cx
jmp quadext
QD4:
  mov ax,theta
  mov cx,6
  mul cx
  sinr rad
  add ax,ycen
  mov y,ax
  mov ax,theta
  mov cx,6
  mul cx
  cosr rad
  add ax,xcen
  mov x,ax
quadext:
endm


drawincrementedmarkings macro increment,markingcolor,startradius,endradius
local outerloop,LP,endloop1,cd1,endloop2,cd2
;quadrantloop macrocurrentsecond,rad,xcen,ycen,x,y
mov cx,startradius  ;;71
mov varradius,cx

outerloop:

mov cx,0
mov currentsecond,cx

LP:

quadrantloop currentsecond,varradius,159,103
;macro is like a function that can accept input parameter and process the code in main function

plotpixel x,y,markingcolor
mov cx,currentsecond
add cx,increment
mov currentsecond,cx


CMP cx, 60  
JLE cd1    ; If it is less than or equal to 60, then jump to LP

jmp endloop1
cd1:
jmp LP
endloop1:




inc varradius
mov cx,varradius
CMP cx,endradius  ; 74 
JLE cd2    ; If it is less than or equal to endradius, then jump to outerloop

jmp endloop2
cd2:
jmp outerloop
endloop2:


endm
    