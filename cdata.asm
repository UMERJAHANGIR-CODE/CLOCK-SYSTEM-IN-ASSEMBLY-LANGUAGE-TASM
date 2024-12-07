.data
    hours db 0    ; Declare hours variable
    minutes db 0  ; Declare minutes variable
    seconds db 0  ; Declare seconds variable
    paused db 0   ; Declare paused flag variable
    colon db ":"
    msg db ?
    temp db ?
    req   db 10,13, "Please Enter the number in 2 digits$"
    hr db 10,13, "Enter the number of hours: $"
    min db 10,13, "Enter the number of minutes: $"
    sec db 10,13, "Enter the number of seconds: $"
    over db 10,13, "Time is UP !!! $"
    clockMsg db 10,13, "Current Time: $"
    pressP db 10,13, "Press 'P' to pause/resume$"
    menu db 10,13,"MENU OPTIONS",10,13,"-------------", 10,13, "1) Digital Clock", 10,13, "2) Analog Clock", 10,13, "3) Stopwatch", 10,13, "4) Exit", 10,13, "Choose option: $"
    
 
    choice db ?
;#region analog data
;;line var
xAtmp dw ?
xBtmp dw ?
yAtmp dw ?
yBtmp dw ?
hrs db ?
mins db ?
secs db ?
hrsdig db 2 dup(?)
minsdig db 2 dup(?)
secsdig db 2 dup(?)           
linecolor db 0
x02 dw 10
x02temp dw ?
x1 dw 20
y02 dw 40
y02temp dw ?
y1 dw 20
xi dw ?
yi dw ?
delx dw ?
dely dw ?
dxmindy dw ?  
dymindx dw ?
error dw ?                                                                                                         
drawLoop dw ?

tmpdelX dw ?
tmpdelY dw ?
;;;;;;;;;;;circle var
count dw 0d
circleradius dw 0d
xcircle dw 0d
ycircle dw 0d 
x0 dw 0d
y0 dw 0d 
varradius dw 0
temp1 dw 0d
temp2 dw 0d
circleerror dw 0
bgcolor dw 0h
circolor db 0h
;;;;;math
xsin dw 0 
xsin2 dw 0
signvar db 0


 clockxcenter dw 159
 clockycenter dw 103
 clockradius  dw 95

 secondhandradius  dw 65
 minutehandradius  dw 65
 hourhandradius  dw 40

 currentsecond dw 0
 currentminute dw 0
 currenthours dw 0

 x dw 0   ;;;variable x used to traverse circle
 y dw 0   ;;;variable y used to traverse circle


;#endregion