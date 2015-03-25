                                ; EJERCICIO06
                                ; TAREA 02




        ;; 6. Elabore un programa que le indique la fecha de sistema cada vez
        ;; que el usuario oprima la letra 'a'. cada vez que se imprima
        ;; , debe cambiar el color en pantalla.

printStrings MACRO MSG, ROW, COL, colour
        LOCAL printLoop
        LOCAL printExit
        MOV SI, 00              ;INDICE DE CADENA EN 0

        MOV BH, 00
        MOV BL, 0F0H            ;FONDO BLANCO, LETRA NEGRA.
        ADD BL, colour

        MOV DH, ROW             ;MOVER CURSOR. 
        MOV DL, COL
        MOV AH, 02H
        INT 10H 
        

printLoop:
        MOV AL, MSG[SI]

        CMP AL, 'a'
        JZ printExit
        
        MOV AH, 0EH
        INT 10H                 ;IMPRIMIR CARACTER.

        INC SI
        JMP printLoop

printExit:  

printStrings ENDM  
        

        ORG 100H

        .DATA
        colourCounter DB 0
        welcomeString DB 'Bienvenido, teclea "a" para imprimir la fecha actual'
                      DB ' oprima enter para salir del programa', 0


        currentYear  DW 0
        currentMonth DB 0
        currentDay   DB 0


        
        dateString DB '00/00/0000', 'a'

        
        .CODE
        ;; MAIN FUNCTION. 
main PROC
        MOV AX, @DATA           ;INITIALIZE DATA SEGMENT
        MOV DS, AX

        MOV AH, 00H             ;INITIALIZE VIDEO MODE
        MOV AL, 03H
        INT 10H

        printStrings welcomeString, 2, 2, 0
        call manageKeyboard

        RET
main ENDP 


        
manageKeyboard PROC

valida: 
        MOV AH, 01
        INT 16H
        JZ valida

        MOV AH, 00
        INT 16H

        CMP AL, 'a'
        JNZ esEnter
        call changeColourCounter
        call imprimirFecha
        JMP valida

esEnter:
        CMP AL, 13
        JNZ valida
        RET

manageKeyboard ENDP


imprimirFecha PROC

        call getFecha
        call setUpFechaString
        printStrings dateString, 4, 2, colourCounter
        
imprimirFecha ENDP


getFecha PROC

        MOV AH, 2AH
        INT 21H 

        MOV CX, currentYear
        MOV DH, currentMonth
        MOV DL, currentDay

getFecha ENDP 


setUpFechaString PROC
        call setUpDay
        call setUpMonth
        call setUpYear

setUpFechaString ENDP


setUpDay PROC
        MOV SI, 1
        MOV BX, 10
        MOV AH, 00
        MOV AL, currentDay
        
        DIV BL
        
        ADD AH, 30H
        MOV dateString[SI], AH

        DEC SI
        
        ADD AL, 30H
        MOV dateString[SI], AL

        RET
setUpDay ENDP


setUpMonth PROC
        MOV SI, 4
        MOV BL, 10
        MOV AH, 00
        MOV AL, currentMonth
        
        DIV BL
        
        ADD AH, 30H
        MOV dateString[SI], AH
        
        DEC SI
        
        ADD AL, 30H
        MOV dateString[SI], AL

        RET

setUpMonth ENDP


setUpyear PROC
        MOV SI, 9
        MOV BX, 10
        MOV AH, 00
        MOV AX, currentYear
        
SUY:
        DIV BX
        ADD DL, 30H
        MOV dateString[SI], DL
        DEC SI
        CMP AX, 0
        JNZ SUY

        RET

setUpYear ENDP

changeColourCounter PROC     
        ADD colourCounter, 1
        CMP colourCounter, FH
        JZ resetCounter
        RET
        
resetCounter:
        MOV resetCounter, 0
        RET

changeColourCounter ENDP        
        
END MAIN

        
