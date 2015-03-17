;;; 5. Use las interrupciones para generar un programa que, de acuerdo con la
;;; fecha del sistema y la fecha de ingreso de un usuario, le indique el numero
;;; de dias que lleva vividos.

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

        output        DW 0     

        
        .CODE

        main PROC

        mov ax, @data           ;Initialize data segment. 
        mov ds, ax

        call getDate            ;Store date variables. 
        
        mov deltaYear, currentYear
        sub deltaYear, yearOfBirth ;Calculate year delta.

        call MonthDifference

        call DayDifference

        mov ax, 365
        mul ax, deltaYear
        mov output, ax

        mov ah, 000H
        mov al, 12
        mul ax, deltaMonth
        add output, ax

        add output, deltaDay
        

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



        ;; CALCULATE DELTA MONTH PROCEDURE ********************
        ;; Calculate the month difference
        
        monthDifference PROC
        CMP currentMonth, monthOfBirth
        JNG MONTHOFBIRTHISGREATER
        
        ;; IF CURRENT MONTH IS GREATER OR EQUAL TO MONTH OF BIRTH
        ;; DELTAMONTH = CURRENTMONTH - MONTHOFBIRTH
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
        ;; Calculate the month difference
        
        monthDifference PROC
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
        monthDifference ENDP



        END main
