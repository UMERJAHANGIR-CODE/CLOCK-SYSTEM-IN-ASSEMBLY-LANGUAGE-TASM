.model small
.stack
.8086
include cdata.asm
include ana_m.asm
.stack 64
.code
;procedure to clear the screen
clear proc
    mov ah, 0   ; sets Set Video Mode function  
    mov al, 2   ; sets to 80x25 color text mode
    int 10h     ; the BIOS will clear the screen and set the video mode to color text mode.
RET
clear ENDP

;procedure to print the numbers    
print proc 
    aam            ; -> AH is quotient (1) = AL / 10 , AL is remainder (2) = AL % 10
    add ax, '00'   ; Convert AH and AL to ASCII
    push ax
    
    mov dl, ah     ; printing the tens
    mov ah, 02h
    int 21h
    
    pop dx
    
    mov ah, 02h    ; printing the units
    int 21h
RET
print ENDP

;procedure to move to new line
newline proc
  mov dx, 13    ; move to the beginning of the current line
  mov ah, 02
  int 21h  
  mov dx, 10    ; move down to the next line
  mov ah, 02
  int 21h
RET
newline ENDP

;procedure for inserting a delay of 1 second
delay proc
    mov cx, 0FH   ; specify the number of microseconds to delay
    mov dx, 4240H ; specify the address of a table that contains the BIOS delay function.
    mov ah, 86H   ; specify the function number of the BIOS delay function
    int 15H
RET
delay ENDP

;procedure for separating 
separator proc
    mov ah, 02
    mov dl, colon
    int 21h
RET
separator ENDP

;procedure for inserting the space in output screen
space proc
spc_loop:
    mov ah, 02
    mov dl, ' '  
    int 21h
    dec msg
    jnz spc_loop
RET
space ENDP

;procedure for inputting 2-digit decimal values
read proc 
    mov ah, 01     ; inputting 1st digit
    int 21h
    sub al, '0'
    mov dl, 10
    mul dl
    
    mov temp, al  ; if any other register is used here like bl, dl, cl then it will stop execution of delay
    
    mov ah, 01     ; inputting second digit
    int 21h
    sub al, '0'
    
    add temp, al
    mov al, temp
RET
read ENDP

disp macro xx
    mov ah, 09
    lea dx, xx
    int 21h
endm

; procedure to get current time from BIOS
get_time proc
      mov     ah,     2ch     ;get time
            int 21h                 ;ch = hr, cl = min, dh = sec
    ; Time will be returned in CH (hours), CL (minutes), DH (seconds)
    ; Load the time values into the respective variables
    mov hours, ch
    mov minutes, cl
    mov seconds, dh
RET
get_time ENDP

display_time proc
    call get_time
    
    ; Display hours
    mov al, hours
    call print
    
    call separator
    
    ; Display minutes
    mov al, minutes
    call print
    
    call separator
    
    ; Display seconds
    mov al, seconds
    call print
RET
display_time ENDP

check_pause proc
    mov ah, 01h        ; Check for keypress
    int 16h
    jz no_key          ; No key pressed, skip pause handling

    mov ah, 00h        ; Get the key
    int 16h
    cmp al, 'p'        ; Check if 'p' was pressed
    jne no_key
    xor paused, 1      ; Toggle paused state
no_key:
RET
check_pause ENDP

;procedure to display digital clock
digital_clock proc
    call clear
    
    display_digital:
        call clear     ; clearing the previous output 
        
        call newline   ; positioning the output
        call newline
        call newline
        
        mov msg, 35    ; if we declared msg earlier it won't be reinitialized
        call space
        
        call display_time
         ; Check for Enter key press
        mov ah, 01h    ; Function 01h of interrupt 16h - Check for keypress
        int 16h        ; BIOS interrupt call
        jz n1_key      ; If no key is pressed, continue

        mov ah, 00h    ; Function 00h of interrupt 16h - Keyboard Input
        int 16h        ; BIOS interrupt call to read the key
        cmp al, 0Dh    ; Check if Enter key is pressed (ASCII code 0Dh)
        je exit_clock  ; If Enter is pressed, exit to main menu

    n1_key:
        ; Add a small delay here if necessary to control the update frequency
        ; For example, using a simple loop or a timer interrupt
         call delay
        jmp display_digital ; Continue updating and displaying the clock

    exit_clock:
        jmp main_menu  ; Assuming 'main_menu' is the label for your main menu
        
       
        
        
RET
digital_clock ENDP
graphic proc
clockgraphics:
;#region
drawincrementedmarkings 1d,15d,74d,74d
drawincrementedmarkings 5d,4d,66d,74d
call drawclockbody ; in macro file calling

mainsecloop:

call gettime

;movzx ax,secs
mov ax,0
mov al,secs
call rescale60
mov bx,60 ;;;;making it rotate clockwise
sub bx,ax
mov currentsecond,bx


;movzx ax,mins
mov ax,0
mov al,mins
call rescale60
;mov  currentminute,ax
mov bx,60
sub bx,ax
mov currentminute,bx


;movzx ax,hrs
mov ax,0
mov al,hrs
call rescale24_12
mov cx,5
mul cx
call rescale60
mov bx,60
sub bx,ax
mov currenthours,bx


quadrantloop currentminute,minutehandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,14

quadrantloop currenthours,hourhandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,4

quadrantloop currentsecond,secondhandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,10

call customdelay

quadrantloop currentminute,minutehandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,0
      
quadrantloop currenthours,hourhandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,0

quadrantloop currentsecond,secondhandradius,clockxcenter,clockycenter
PlotLine clockxcenter,clockycenter,x,y,0

jmp mainsecloop

ret
;#endregion

drawclockbody:
;#region
call nulreg
drawcircle clockxcenter,clockycenter,95d,0Ch
plotpixel clockxcenter,clockycenter,2
;;159,103



printchar 19,2,'1',0Ch
printchar 20,2,'2',0Ch

printchar 20,23,'6',0Ch

printchar 30,12,'3',0Ch
printchar 9,12,'9',0Ch

printchar 25,3,'1',0Ch
printchar 29,7,'2',0Ch

printchar 29,17,'4',0Ch
printchar 26,21,'5',0Ch

printchar 13,21,'7',0Ch
printchar 10,17,'8',0Ch


printchar 14,3,'1',0Ch
printchar 15,3,'1',0Ch

printchar 10,7,'1',0Ch
printchar 11,7,'0',0Ch





call nulreg
mov dx, clockradius
sub dx,20
drawcircle clockxcenter,clockycenter,dx,1

ret
;#endregion


absval:
;#region
;.................................
;takes absolute values of ax    
;returns absval in ax
;.................................
cmp ax,0
jge staysame
neg ax   
staysame:
ret
;#endregion                                                                                                                                                                                                                

gettime:
;#region
    ; Hours is in CH
    ; Minutes is in CL
    ; Seconds is in DH
    mov ah,2ch
    int 21h
    mov hrs,ch
    mov mins,cl
    mov secs,dh
    ;AAM to adjust two digit hours
    mov ah,0
    mov al,ch
    aam
    lea di,hrsdig
    mov [di],ah
    mov [di+1],al
    
    ;AAM to adjust two digit mins
    mov ah,0
    mov al,cl
    aam
    lea di,minsdig
    mov [di],ah
    mov [di+1],al
    
    ;AAM to adjust two digit secs
    mov ah,0
    mov al,dh
    aam
    lea di,secsdig
    mov [di],ah
    mov [di+1],al   
ret    
;#endregion    


disptime:  
;#region
    call gettime
    
    mov ah,2
    lea si,hrs
    
    mov dl,[si]
    add dl,30h
    int 21h
    mov dl,[si+1]
    add dl,30h
    int 21h
    
    mov dl,':'
    int 21h
           
    lea si,mins
    
    mov dl,[si]
    add dl,30h
    int 21h
    mov dl,[si+1]
    add dl,30h
    int 21h
    
    mov dl,':'
    int 21h 
    
    lea si,secs
    
    mov dl,[si]
    add dl,30h
    int 21h
    mov dl,[si+1]
    add dl,30h
    int 21h
    
    ret
  ;#endregion         

circlepoints:
;#region
mov ax,x0
add ax,xcircle
mov temp1,ax
mov ax,y0
add ax,ycircle
mov temp2,ax
        plotpixel temp1, temp2, circolor
        
                
mov ax,x0
add ax,ycircle
mov temp1,ax

mov ax,y0
add ax,xcircle
mov temp2,ax 
        plotpixel temp1, temp2, circolor 
        
        
mov ax,x0
sub ax,ycircle
mov temp1,ax

mov ax,y0
add ax,xcircle
mov temp2,ax 
        plotpixel temp1, temp2, circolor 
        
        

        
mov ax,x0
sub ax,xcircle
mov temp1,ax
mov ax,y0
add ax,ycircle
mov temp2,ax
        plotpixel temp1, temp2, circolor 
     
        
mov ax,x0
sub ax,xcircle
mov temp1,ax
mov ax,y0
add ax,ycircle
mov temp2,ax
        plotpixel temp1, temp2, circolor
        
     
mov ax,x0
sub ax,xcircle
mov temp1,ax
mov ax,y0
sub ax,ycircle
mov temp2,ax
        plotpixel temp1, temp2, circolor
        

        
mov ax,x0
sub ax,ycircle
mov temp1,ax
mov ax,y0
sub ax,xcircle
mov temp2,ax
        plotpixel temp1, temp2, circolor
 



mov ax,x0
add ax,ycircle
mov temp1,ax
mov ax,y0
sub ax,xcircle
mov temp2,ax
        plotpixel temp1, temp2,circolor    
  

        
mov ax,x0
add ax,xcircle
mov temp1,ax
mov ax,y0
sub ax,ycircle
mov temp2,ax
        plotpixel temp1, temp2, circolor

ret
;#endregion

inccirclepoints:
 ;#region
 ; circleerror+= 2*x=x+x
 mov ax,circleerror
 add ax,xcircle
 add ax,xcircle
 mov circleerror,ax

 ;            if (circleerror >= 0)
    ;            {
    ; 
    ;               y --;
    ;               circleerror-=2*y;
    ;               
    ;            }
    ; 
    ;            x++;
    mov ax,circleerror
    cmp ax,0
    jl cond
   
    dec ycircle
    mov ax,circleerror
    sub ax,ycircle
    sub ax,ycircle
    mov circleerror,ax
    cond:
    inc xcircle  
    ret
    ;#endregion

textmode:
;#region
 mov ah,00 ; set display mode function.
  mov al,03 ; normal text mode 3
  int 10h   ; set it!
ret
;#endregion

customdelay:
;#region
            mov     cx, 3
    delRep: push    cx
            mov     cx, 0D090H
    delDec: dec     cx
            jnz     delDec
            pop     cx
            dec     cx
            jnz     delRep
ret
;#endregion
nulreg:
;#region
mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov circleradius,ax 
mov xcircle,ax 
mov ycircle,ax 
mov x0,ax 
mov y0,ax  
mov temp1,ax 
mov temp2,ax 
mov circleerror,ax 
mov bgcolor,ax 
mov circolor,al
ret
;#endregion

;cos in ax out ax range=[0,1]
cos:
;#region
add ax, 90     
call sin
ret
;#endregion
;sin in ax out ax range=[0,1]
sin:
;#region
push      cx
push      dx
push      bx
sin360:       
cmp       ax, 90
ja        dy90
sto0_90:      
mov       si, 0
jmp       pp1
dy90:         
cmp       ax, 180
jbe       z91to180
jmp       dy180
z91to180:     
mov       cx, 180
sub       cx, ax
mov       ax, cx
mov       si, 0
jmp       pp1
z181to270:    
sub       ax, 180
mov       si, 1
jmp       pp1
z271to360:    
cmp       ax, 359
ja        zdy359
mov       cx, 360
sub       cx, ax
mov       ax, cx
mov       si, 1
jmp       pp1
zdy359:       
sub       ax, 360
jmp       sin360

dy180:        
cmp       ax, 270
jbe       z181to270
jmp       z271to360

pp1:
mov       cx, 175
xor       dx, dx
mul       cx
mov      xsin, ax
xor       dx, dx
mov       cx, ax
mul       cx
mov       cx, 10000
div       cx
mov      xsin2, ax
xor       dx, dx
mov       cx, 120
div       cx
mov       bx, 1677;1667
cmp       ax, bx
jae       goab
xor       signvar, 1
xchg      ax, bx
goab:
sub       ax, bx
mov       cx,xsin2
xor       dx, dx
mul       cx
mov       cx, 10000
div       cx               ;xx(xx/120-10000/6)
mov       cx, 10000
mov       dl, 0
cmp       dl, signvar
je        jia
sub       cx, ax
mov       ax, cx
jmp       kk1
jia:
add       ax, cx
kk1:
mov       cx,xsin
xor       dx, dx
mul       cx
mov       cx, 10000
div       cx
pop       bx
pop       dx
pop       cx
mov       signvar, 0
ret
;#endregion

rescale60: ;;;;In ax out ax
;#region
cmp ax, 15  ; Compares whether the counter has reached 10
jle range45_60    ; If it is less than or equal to 10, then jump to LP1

sub ax,15
jmp exitrescale60

range45_60:
add ax,45
exitrescale60:
ret
;#endregion

rescale24_12:;;;;;In ax out ax
;#region
cmp ax, 12  ; Compares whether the counter has reached 10
jle exitrescale24_12    ; If it is less than or equal to 10, then jump to LP1
sub ax,12
exitrescale24_12:
ret
;#endregion

graphic ENDP

; Dummy procedure for analog clock (to be implemented)
analog_clock proc
      
      startvideomode 13h,00h
	  call graphic
            ; Check for Enter key press
        mov ah, 00h    ; Function 00h of interrupt 16h - Keyboard Input
        int 16h        ; BIOS interrupt call
        cmp al, 0Dh    ; Check if Enter key is pressed (ASCII code 0Dh)
        jne analog_clock ; If not Enter, continue displaying the clock
        
        ; Jump to main menu
        jmp main_menu  ; Assuming 'main_menu' is the label for your main menu
RET
analog_clock ENDP

  
;procedure to display stopwatch
stopwatch proc
    call clear
    disp req
	

    call newline

    disp hr
    call read      ; reading hours
    mov hours, al  ; storing the decimal value in variables

    call newline

    disp min
    call read       ; reading minutes
    mov minutes, al ; storing the decimal value in variables

    call newline

    disp sec
    call read        ; reading seconds
    mov seconds, al  ; storing the decimal value in variables
    
pause_loop:
    call check_pause
    cmp paused, 1
    je pause_loop  ; Stay in pause loop until 'p' is pressed again

    jmp watch_loop ; Start countdown

watch_loop:
    call clear     ; clearing the previous output 

    call newline   ; positioning the output
    call newline
    call newline

    mov msg, 35    ; if we declared msg earlier it won't be reinitialized
    call space

    mov al, hours  ; printing the hours
    call print

    call separator

    mov al, minutes ; printing the minutes
    call print

    call separator

    mov al, seconds ; printing the seconds
    call print

    disp pressP    ; Display pause/resume message

    call check_pause
    cmp paused, 1
    je pause_loop  ; If paused, jump to pause loop

    call delay     ; calling the delay
    
    dec seconds
    jge continue_loop  ; Jump if greater than or equal to zero

    mov seconds, 59

    dec minutes
    jge continue_loop

    mov minutes, 59

    dec hours
    jge continue_loop

    disp over
    call delay     ; calling the delay

    jmp main_menu  ; Return to main menu after countdown ends

continue_loop:
    jmp watch_loop

RET
stopwatch ENDP


; Start of the main program
.startup
main_menu:
    call clear
    disp menu
    mov ah, 01h
    int 21h
    sub al, '0'
    mov choice, al

    cmp choice, 1
    je digital_clock_jump

    cmp choice, 2
    je analog_clock_jump

    cmp choice, 3
    je stopwatch_jump

    cmp choice, 4
    je exit_program_jump

    jmp main_menu     ; If none of the above choices matched, loop back to main_menu

digital_clock_jump:
    jmp digital_clock

analog_clock_jump: 
  
  
    jmp analog_clock

stopwatch_jump:
    jmp stopwatch

exit_program_jump:
    jmp exit_program

exit_program:
    mov ah, 4Ch     ; DOS function to exit program
    int 21h         ; Call DOS interrupt

end
