;;; PRACTICA 09:

        
;;; MENU DE IMPRESION DE FECHA Y HORA.     
;;; ALMACENAMIENTO DE FECHAY HORA ACTUAL EN UN ARCHIVO.

;;; GERARDO GARCIA TERUEL A01018057
;;; JUAN PABLO
;;; GUALBERTO
;;; JOSE
;;; SALVADOR


printForwards MACRO MSG, ROW, COL
        LOCAL printLoop
        LOCAL printExit
        MOV SI, 00              ;INDICE DE CADENA EN 0

        MOV BH, 00
        MOV BL, 0F0H            ;FONDO BLANCO, LETRA NEGRA.

        MOV DH, ROW             ;MOVER CURSOR. 
        MOV DL, COL
        MOV AH, 02H
        INT 10H 
        

printLoop:
        MOV AL, MSG[SI]

        CMP AL, 0
        JZ printExit
        
        MOV AH, 0EH
        INT 10H                 ;IMPRIMIR CARACTER.

        INC SI
        JMP printLoop

printExit:  

printForwards ENDM


printBackwards MACRO MSG, ROW, COL, LENGTH 
        LOCAL printLoop
        LOCAL printExit
        MOV SI, LENGTH              ;INDICE DE CADENA EN 0

        MOV BH, 00
        MOV BL, 0F0H            ;FONDO BLANCO, LETRA NEGRA.

        MOV AX, LENGTH
        ADD AX, COL
        MOV DH, AX
            
        MOV DL, COL
        MOV AL, 00
        MOV AH, 02H
        INT 10H 
        

printLoop:
        MOV AL, MSG[SI]

        CMP SI, 0
        JNGE printExit
        
        MOV AH, 0EH
        INT 10H                 ;IMPRIMIR CARACTER.

        DEC SI
        JMP printLoop

printExit:  

printBackwards ENDM        




        

ORG 100H

;;; ********************* DATA *************************
.DATA

        ;; LENGTH 30. 
        menuString  DB 'Inserte la opcion a ejecutar: ', 0
        
        dateString  DB 'F: Fecha normal', 0
        iDateString DB 'I: Fecha invertida', 0
        hourString  DB 'H: Hora normal', 0
        iHourString DB 'O: Hora invertida', 0
        saveString  DB 'G: Guardar hora y fecha en un archivo', 0
        errorString DB 'No hay funcionalidad para la opcion seleccionada', 0

        input DB ' ', 0

        currentYear   dw 0
        currentMonth  db 0
        currentDay    db 0
        currentHour   db 0
        currentMinute db 0
        currentSecond db 0
     
        yearString   db '0000', 0
        monthString  db '00/',   0
        dayString    db '00/',   0
        hourString   db '00:',   0
        minuteString db '00:',   0
        secondString db '00',   0


;;; ********************* CODE *************************

.CODE


;;; MAIN PROCEDURE. 
main   PROC
        ;; Start video mode.
        MOV AH, 00H
        MOV AL, 03H
        INT 10H

        CALL printMenu
        CALL getInput
        CALL handleInput

        RET

main   ENDP


printMenu PROC
        
        printForwards menuString,  2, 2
        printForwards dateString,  3, 2
        printForwards iDateString, 4, 2
        printForwards hourString,  5, 2
        printForwards iHourString, 6, 2
        printForwards saveString,  7, 2      

printMenu ENDP


getInput PROC
        ;; Adjust cursor
        MOV DH,  2
        MOV DL, 32

        ;; Adjust colors
        MOV BH, 00
        MOV BL, 0F0H

        ;; Get from keyboard
        MOV AH, 01
teclaValida:
        INT 16H
        JZ teclaValida

        MOV AH, 00
        INT 16H

        MOV AH, 0EH
        INT 10H
        
        MOV input, AL 

        RET

getInput ENDP


handleInput PROC
        CMP AL, 'F'
        JZ normalDate

        CMP AL, 'I'
        JZ invertedDate

        CMP AL, 'H'
        JZ normalTime

        CMP AL, 'O'
        JZ invertedTime

        CMP AL, 'G'
        JZ createDocument

        printForwards errorString, 10, 2
        RET
        
normalDATE:
        call getDateTime
        call storeStrings

        printForwards dayString,   10, 2
        printForwards monthString, 13, 2
        printForwards yearString,  16, 2
        
        
        RET
invertedDate:
        call getDateTime
        call storeStrings

        printBackwards dayString,   10, 2, 2
        printBackwards monthString, 13, 2, 2
        printBackwards yearString,  16, 2, 3
        
        RET
normalTime:
        call getDateTime
        call storeStrings

        printForwards hourString,   10, 2
        printForwards minuteString, 13, 2
        printForwards secondString, 16, 2
        
        RET
invertedTime:
        call getDateTime
        call storeStrings

        printBackwards hourString,   10, 2, 2
        printBackwards minuteString, 13, 2, 2
        printBackwards secondString, 16, 2, 1

        RET
createDocument:
        call getDateTime
        call storeStrings

        call documentHandling

        RET

handleInput ENDP
        

documentHandling PROC
        
        
        RET
documentHandling ENDP


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



storeStrings PROC

        ;; Store year.
        mov dx, 0
        mov si, 3
        mov ax, currentYear
        mov bx, 10    
        mov cx, 4

YEARLOOP:       
        div bx                  ;Get the last digit of the year
        add dx, 48              ;Add 48 to remainder to get
                                ; ascii representation

        
        mov yearString[si], dl  ;Insert character to string.
        dec si                  ;Else: - increment si
        mov dx, 0               ;      - reset dx
        LOOP YEARLOOP           ;Loop. 
                
                
                
        mov dx, 0000
        mov si, 1 
        mov ah, 00
        mov al, currentMonth  
        mov cx, 2
        
MONTHLOOP:
        div bx
        add dx, 48
        mov monthString[si], dl
        dec si
        mov dx, 0000
        LOOP MONTHLOOP


        
        mov dx, 0000
        mov si, 1
        mov ah, 00
        mov al, currentDay       
        mov cx, 2
DAYLOOP:
        div bx
        add dx, 48
        mov dayString[si], dl
        dec si
        mov dx, 0000
        LOOP DAYLOOP


        
        mov dx, 0000
        mov si, 1
        mov ah, 00
        mov al, currentHour 
        mov cx, 2
HOURLOOP:
        div bx
        add dx, 48
        mov hourString[si], dl
        dec si
        mov dx, 0000
        LOOP HOURLOOP
        

        
        mov dx, 0000
        mov si, 1
        mov ah, 00
        mov al, currentMinute
        mov cx, 2
MINUTELOOP:
        div bx
        add dx, 48
        mov minuteString[si], dl
        dec si
        mov dx, 0000
        LOOP MINUTELOOP


        
        mov dx, 0000
        mov si, 1
        mov ah, 00
        mov al, currentSecond
        mov cx, 2
SECONDLOOP:
        div bx
        add dx, 48
        mov secondString[si], dl
        dec si
        mov dx, 0000
        LOOP SECONDLOOP  
        
        RET

storeStrings ENDP




        
        
        END main
