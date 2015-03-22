;;; 5. Use las interrupciones para generar un programa que, de acuerdo con la
;;; fecha del sistema y la fecha de ingreso de un usuario, le indique el numero
;;; de dias que lleva vividos.

;;; OUTPUT SHOULD BE 7663
        
        ORG 100H

        .DATA
        currentYear   DW 0
        currentMonth  DB 0
        currentDay    DB 0

        yearOfBirth   DW 1994
        monthOfBirth  DB 03
        dayOfBirth    DB 24

        deltaYear     DW 0
        deltaMonth    DB 0
        deltaDay      DB 0

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
        add output, deltaDay
        call addLeapYears
        
        

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

        mov deltaYear, currentYear
        sub deltaYear, yearOfBirth ;Calculate year delta.

        RET
yearDifference ENDP
        

        ;; CALCULATE DELTA MONTH PROCEDURE ********************
        ;; Calculate the month difference
        
monthDifference PROC
        CMP currentMonth, monthOfBirth
        JNG MONTHOFBIRTHISGREATER
        
        ;; IF CURRENT MONTH IS GREATER OR EQUAL TO MONTH OF BIRTH
        ;; DELTAMONTH = CURRENTMONTH - MONTHOFBIRTH
        MOV isCurrentMonthGreaterThanBirthMonth, 1
        mov deltaMonth, currentMonth
        sub deltaMonth, monthOfBirth
        RET

        ;; IF CURRENTMONTH IS LESS THAN MONTH OF BIRTH
        ;; DELTAYEAR--
        ;; DELTAMONTH = MONTHOFBIRTH - CURRENTMONTH
MONTHOFBIRTHISGREATER:  
        dec deltaYear
        mov deltaMonth, monthOfBirth
        sub deltaMonth, currentMonth


        RET
monthDifference ENDP


        ;; CALCULATE DELTA DAY PROCEDURE ********************
        ;; Calculate the day difference
        
dayDifference PROC
        CMP currentDay, dayOfBirth
        JNG DATEOFBIRTHISGREATER
        
        ;; IF CURRENT MONTH IS GREATER OR EQUAL TO MONTH OF BIRTH
        ;; DELTAMONTH = CURRENTMONTH - MONTHOFBIRTH
        mov deltaDay, currentDay
        sub deltaDay, dayOfBirth
        RET

        ;; IF CURRENTMONTH IS LESS THAN MONTH OF BIRTH
        ;; DELTAYEAR--
        ;; DELTAMONTH = MONTHOFBIRTH - CURRENTMONTH
DATEOFBIRTHISGREATER:  
        dec deltaMonth
        mov deltaDay, dayOfBirth
        sub deltaDay, currentDay


        RET
dayDifference ENDP

        ;; YEAR TO DAY PROCEDURE *************************
        ;; Multiply years * 365 and store in output. 
yearToDay PROC
        
        mov ax, 365
        mul ax, deltaYear
        mov output, ax
        
        RET
yearToDay ENDP

monthToDay PROC
        ;; If the currentMonth is gretar than monthOfBirth
        CMP isCurrentMonthGreaterThanBirthMonth, 1
        JZ currentMonthGreaterThanBirthMonth

        mov temporal, daysPerMonth[monthOfBirth]
        sub temporal, daysPerMonth[currentMonth]

        add output, temporal
        mov temporal, 0
        
        RET
        
        
isCurrentMonthGreaterThanBirthMonth:
        
        mov temporal, daysPerMonth[currentMonth]
        sub temporal, daysPerMonth[monthOfBirth]

        add output, temporal
        mov temporal, 0
        
        RET
monthToDay ENDP



                                ;ADDS LEAPDAYS
addLeapYears PROC

        MOV AX, 00
        MOV AL, deltaYear
        DIV AL, 4

        ADD output, AH

        RET

addLeapYears ENDP 
        
        END main
