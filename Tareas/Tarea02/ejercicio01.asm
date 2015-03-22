;;; ********************************************************************
;;; * 1. Escriba un programa que ponga margen a la pantalla y tambien, *
;;; * una equis exactamente enmedio. El margen debe ir de un color,    *
;;; * y la X de otro.                                                  *
;;; ********************************************************************
        
        ORG 100H                ;.COM FILE


;;; ********************************************************************
.DATA




;;; ********************************************************************
.CODE

                                ; MAIN PROCEDURE
        
main PROC
        MOV AH, 00H
        MOV AL, 00H             ; 40X25 SCREEN
        INT 10H                 ; INITIALIZE VIDEO MODE

        CALL printTopHorizontalMargin
        CALL printBottomHorizontalMargin
        CALL printRightMargin
        CALL printLeftMargin
        

        CALL printCenterX

        RET

        
main ENDP

                                ;PRINT TOP MARGIN
        
printTopHorizontalMargin PROC

        MOV AH, 02H
        MOV DH,   2
        MOV DL,   2             ;MOVE CURSOR TO (2, 2)
        INT 10H
        
        CALL printHorizontalMargin

        RET
printTopHorizontalMargin ENDP


                                ;PRINT BOTTOM MARGIN      
printBottomHorizontalMargin PROC
        MOV AH, 02H
        MOV DH,  24
        MOV DL,   2
        INT 10H

        CALL printHorizontalMargin

        RET
printBottomHorizontalMargin ENDP


        
                                ;PRINT HORIZONTAL MARGIN
printHorizontalMargin PROC

        MOV AH, 09H 
        MOV AL, '-'
        MOV BH, 00H
        MOV BL, 004H            ;LETRA ROJA, FONDO NEGRO. 
        MOV CX, 36
        
        INT 10H

        RET
printHorizontalMargin ENDP



                                ;PRINT RIGHT MARGIN
printRightMargin PROC

        MOV AH, 02H
        MOV DH,   3
        MOV DL,   38             ;MOVE CURSOR TO (38, 3)
        INT 10H
        
        CALL printVerticalMargin


        RET
printRightMargin ENDP



                                ;PRINT LEFT MARGIN
printLeftMargin PROC

        MOV AH, 02H
        MOV DH,   3
        MOV DL,   2             ;MOVE CURSOR TO (3, 2)
        INT 10H
        
        CALL printVerticalMargin
        
        RET
printLeftMargin ENDP



                                ;PRINT VERTICAL MARGIN
printVerticalMargin PROC
        MOV CX, 21

verticalLoop:
        PUSH CX

        MOV AH, 02H
        INT 10H                 ;ADJUST CURSOR

        MOV AH, 09H
        MOV AL, '|'
        MOV BH, 00H
        MOV BL, 004H            ;LETRA ROJA, FONDO NEGRO
        MOV CX, 1
        INT 10H

        POP CX
        INC DH
        LOOP verticalLoop
        
        RET
printVerticalMargin ENDP


        
                                ;PRINT X
printCenterX PROC

        MOV AH, 02H
        MOV DH, 12
        MOV DL, 21
        INT 10H                 ;ADJUST CURSOR POSITION

        MOV AH, 09H
        MOV AL, 'X'
        MOV BH, 00H
        MOV BL, 003             ;LETRA CYAN, FONDO NEGRO
        MOV CX, 1
        INT 10H

        RET
printCenterX ENDP

        END main
