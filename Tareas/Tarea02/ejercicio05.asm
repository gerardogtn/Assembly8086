;;; 5. Use las interrupciones para generar un programa que, de acuerdo con la
;;; fecha del sistema y la fecha de ingreso de un usuario, le indique el numero
;;; de dias que lleva vividos.

;;; OUTPUT SHOULD BE 7663
       
       
printStrings MACRO MSG, ROW, COL
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

printStrings ENDM        
       
       
        
        ORG 100H

        .DATA
        currentYear   DW 0
        currentMonth  DW 0
        currentDay    DW 0

        yearOfBirth   DW 1994
        monthOfBirth  DW 03
        dayOfBirth    DW 24

        deltaYear     DW 0
        deltaMonth    DW 0
        deltaDay      DW 0

        isCurrentMonthGreaterThanBirthMonth DB 0
        
        output        DW 0
        outputstring  DB "     ", 0

        daysPerMonth DW  31,  61,  92, 122, 153, 183
                     DW 214, 245, 275, 306, 336, 365

        temporal DW 0
        
        .CODE

        main PROC

        mov ax, @data           ;Initialize data segment. 
        mov ds, ax

        call getDate            ;Store date variables. 
        

        call yearDifference
        call monthDifference
        call dayDifference

        call yearToDay
        call monthToDay
                           
        mov ax, output                   
        add  ax, deltaDay
        mov output, ax
        ;call addLeapYears
                
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
        
        call outputToString
        
        printStrings outputString, 13, 38       
        RET

        main ENDP




        ;;GETDATE PROCEDURE ************************************
        ;; Store date into the date variables defined in .data
getDate PROC
        
        ;; Get date. 
        mov ah, 2AH
        int 21H

        ;; Store date variables
        mov currentYear,  cx
        mov currentMonth, dh
        mov currentDay,   dl

        RET
getDate ENDP

        ;; CALCULATE DELTA YEAR PROCEDURE ********************
        ;; Calculate the year difference
yearDifference PROC

        MOV AX, currentYear
        sub AX, yearOfBirth ;Calculate year delta.
        MOV deltaYear, AX
        
        RET
yearDifference ENDP
        

        ;; CALCULATE DELTA MONTH PROCEDURE ********************
        ;; Calculate the month difference
        
monthDifference PROC
        MOV AX, monthOfBirth
        CMP AX, currentMonth
        JG MONTHOFBIRTHISGREATER
        
        ;; IF CURRENT MONTH IS GREATER OR EQUAL TO MONTH OF BIRTH
        ;; DELTAMONTH = CURRENTMONTH - MONTHOFBIRTH
        mov AX, currentMonth
        sub AX, monthOfBirth 
        MOV deltaMonth, AX
        RET
        

        ;; IF CURRENTMONTH IS LESS THAN MONTH OF BIRTH
        ;; DELTAYEAR--
        ;; DELTAMONTH = MONTHOFBIRTH - CURRENTMONTH
MONTHOFBIRTHISGREATER: 
        MOV isCurrentMonthGreaterThanBirthMonth, 1 
        dec deltaYear   
        mov AX, monthOfBirth
        sub AX, currentMonth
        MOV deltaMonth, AX

        RET
monthDifference ENDP


        ;; CALCULATE DELTA DAY PROCEDURE ********************
        ;; Calculate the day difference
        
dayDifference PROC 
        MOV AX, dayOfBirth 
        CMP AX, currentDay
        JG DATEOFBIRTHISGREATER
        
        ;; IF CURRENT MONTH IS GREATER OR EQUAL TO MONTH OF BIRTH
        ;; DELTAMONTH = CURRENTMONTH - MONTHOFBIRTH
        mov AX, currentDay
        sub AX, dayOfBirth     
        MOV deltaDay, AX
        RET

        ;; IF CURRENTMONTH IS LESS THAN MONTH OF BIRTH
        ;; DELTAYEAR--
        ;; DELTAMONTH = MONTHOFBIRTH - CURRENTMONTH
DATEOFBIRTHISGREATER:  
        dec deltaMonth 
        MOV AX, deltaDay
        mov AX, dayOfBirth
        sub AX, currentDay
        MOV deltaDay, AX

        RET
dayDifference ENDP

        ;; YEAR TO DAY PROCEDURE *************************
        ;; Multiply years * 365 and store in output. 
yearToDay PROC
        
        mov ax, 365
        mul deltaYear
        add output, ax
        
        RET
yearToDay ENDP

monthToDay PROC
        ;; If the currentMonth is gretar than monthOfBirth
        CMP isCurrentMonthGreaterThanBirthMonth, 1
        JZ currentMonthGreaterThanBirthMonth 
        
        MOV AH, 00
        MOV BH, 00
        MOV BX, monthOfBirth
        mov AX, daysPerMonth[BX]   
        MOV BX, currentMonth
        sub AX, daysPerMonth[BX]

        add output, AX
        
        RET
        
        
CurrentMonthGreaterThanBirthMonth:
        
        MOV BX, currentMonth
        mov AX, daysPerMonth[BX]   
        MOV BX, monthOfBirth
        sub AX, daysPerMonth[BX]

        add output, AX
        
        RET
monthToDay ENDP



                                ;ADDS LEAPDAYS
addLeapYears PROC

        MOV AH, 00
        MOV AL, deltaYear   
        MOV BL, 4
        DIV BL
        
        MOV AH, 00 
        ADD output, AX

        RET

addLeapYears ENDP 
                 
                 
                 
OUTPUTTOSTRING         PROC
        MOV DX, 0000H
        MOV SI, 3
        MOV AX, output
        MOV BX, 10
        MOV CX, 4

LOOPS:
        DIV BX
        ADD DX, 30H             ;CONVERT TO ASCII
        MOV outputString[SI], DL
        DEC SI
        MOV DX, 0
        LOOP LOOPS

        RET
OUTPUTTOSTRING         ENDP                 
                 
        END main
