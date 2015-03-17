; RETO (+15 PUNTOS EXTRA)
;ELABORE UN PROGRAMA QUE SAQUE LA FECHA DEL SISTEMA Y LA HORA DEL 
; SISTEMA PERO INVERTIDO
; EJEMPLO:    07:42:30 HRS  12/03/2015
;        SACA 03:24:70 SRH  5102/30/21  

        ORG 100H                        ; START AT SEGMENT 0100H

        ;; ***************** DATA ******************************
        .DATA
        currentYear   dw 0
        currentMonth  db 0
        currentDay    db 0
        currentHour   db 0
        currentMinute db 0
        currentSecond db 0

        yearString   db '0000', 0
        monthString  db '00',   0
        dayString    db '00',   0
        hourString   db '00',   0
        minuteString db '00',   0
        secondString db '00',   0

        ;; ***************** CODE *******************************
        .CODE



        
        ;; MAIN PROCEDURE. **************************************
        main PROC
        mov ax, @data           ;Initialize data segment. 
        mov ds, ax 

        
        ;; Start Video mode.
        mov ax, 00003H
        int 10h

        ;; Store DateTime variables
        call getDateTime

        ;; Store variables in strings, ready to be printed. 
        call storeStrings

        ;; Print values in appropiate order
        mov al, secondString[0]
        mov ah, 0EH
        int 10H                 ;Print second reversed 
        mov al, secondString[1]
        mov ah, 0EH
        int 10H                 

        mov al, ':'             ;Print colon
        mov ah, 0EH
        int 10H
        
        
        mov al, minuteString[0]
        mov ah, 0EH
        int 10H 
        mov al, minuteString[1]
        mov ah, 0EH
        int 10H 

        mov al, ':'             ;Print colon
        mov ah, 0EH
        int 10H
        
        mov al, hourString[0]
        mov ah, 0EH
        int 10H             
        mov al, hourString[1]
        mov ah, 0EH
        int 10H 

        mov al, ' '             ;Print space.
        mov ah, 0EH
        int 10H
        mov al, 'S'             ;Print S.
        mov ah, 0EH
        int 10H
        mov al, 'R'             ;Print R.
        mov ah, 0EH
        int 10H
        mov al, 'H'             ;Print H.
        mov ah, 0EH
        int 10H
        mov al, ' '             ;Print space.
        mov ah, 0EH
        int 10H


        mov al, yearString[0]
        mov ah, 0EH
        int 10H                  ;Print year reversed  
        mov al, yearString[1]
        mov ah, 0EH
        int 10H
        mov al, yearString[2]
        mov ah, 0EH
        int 10H
        mov al, yearString[3]
        mov ah, 0EH
        int 10H

        mov al, '/'             ;Print backlash
        mov ah, 0EH
        int 10H

        mov al, monthString[0]
        mov ah, 0EH
        int 10H                  ;Print month reversed
        mov al, monthString[1]
        mov ah, 0EH
        int 10H  
          
        mov al, '/'             ;Print backlash
        mov ah, 0EH
        int 10H

        mov al, dayString[0]       ;Print day reversed. 
        mov ah, 0EH
        int 10H
        mov al, dayString[1]        
        mov ah, 0EH
        int 10H   

        main ENDP



        
        ;;GETDATE PROCEDURE ************************************
        ;; Store date into the date variables defined in .data
        getDateTime PROC
        
        ;; Get date. 
        mov ah, 2AH
        int 21H

        ;; Store date variables
        mov currentYear,  cx
        mov currentMonth, dh
        mov currentDay,   dl

        ;; Get time.
        mov ah, 2CH
        int 21H

        ;; Store time variables
        mov currentHour,   ch
        mov currentMinute, cl
        mov currentSecond, dh
                     
                     
        RET

        getDateTime ENDP

        ;; Store values into strings **************************
        ;; Store the ascii representations of the dateTime
        ;; variables into the strings in reverse order.
        storeStrings PROC

        ;; Store year.
        mov dx, 0
        mov si, 0
        mov ax, currentYear
        mov bx, 10    
        mov cx, 4

YEARLOOP:       
        div bx                  ;Get the last digit of the year
        add dx, 48              ;Add 48 to remainder to get
                                ; ascii representation
        
        mov yearString[si], dl  ;Insert character to string.
        inc si                  ;Else: - increment si
        mov dx, 0               ;      - reset dx
        LOOP YEARLOOP           ;Loop. 
                
                
                
        mov dx, 0000
        mov si, 0 
        mov ah, 00
        mov al, currentMonth  
        mov cx, 2
        
MONTHLOOP:
        div bx
        add dx, 48
        mov monthString[si], dl
        inc si
        mov dx, 0000
        LOOP MONTHLOOP


        
        mov dx, 0000
        mov si, 0
        mov ah, 00
        mov al, currentDay       
        mov cx, 2
DAYLOOP:
        div bx
        add dx, 48
        mov dayString[si], dl
        inc si
        mov dx, 0000
        LOOP DAYLOOP


        
        mov dx, 0000
        mov si, 0
        mov ah, 00
        mov al, currentHour 
        mov cx, 2
HOURLOOP:
        div bx
        add dx, 48
        mov hourString[si], dl
        inc si
        mov dx, 0000
        LOOP HOURLOOP
        

        
        mov dx, 0000
        mov si, 0
        mov ah, 00
        mov al, currentMinute
        mov cx, 2
MINUTELOOP:
        div bx
        add dx, 48
        mov minuteString[si], dl
        inc si
        mov dx, 0000
        LOOP MINUTELOOP


        
        mov dx, 0000
        mov si, 0
        mov ah, 00
        mov al, currentSecond
        mov cx, 2
SECONDLOOP:
        div bx
        add dx, 48
        mov secondString[si], dl
        inc si
        mov dx, 0000
        LOOP SECONDLOOP  
        
        RET

        storeStrings ENDP

        END main
