printNum MACRO intA, ROW, COL, numDigits
        LOCAL printLoop
        MOV CX, numDigits

        MOV SI, intA
        MOV DI, COL
        ADD DI, numDigits
        MOV BX, 10

printLoop:
        ;; DIVIDE NUMBER BY TEN.
        MOV DX, 0
        MOV AX, SI
        DIV BX

        ;; STORE RESULT IN SI
        MOV SI, AX

        ;; PRINT REMAINDER
        MOV AH, 0EH
        MOV AL, DL
        ADD AL, 30H
        MOV DH, ROW
        MOV DL, DI
        INT 10H
        
        LOOP printLoop

printNum ENDM 







;;; ########################################################################
.DATA
        numA DW 400
        numB DB 25






;;; ########################################################################
.CODE

main PROC
        CALL startVideoMode
        printNum numA, 4, 2
        printNum numB, 8, 2
        RET
main ENDP


startVideoMode PROC
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
        RET
startVideoMode ENDP 


        
