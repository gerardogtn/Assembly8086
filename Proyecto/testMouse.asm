;;; TEST MOUSE



        ORG 100H



        .DATA
        xCoordinate DW 0
        yCoordinate DW 0





        .CODE
        
main PROC

        ;; START VIDEO MODE
        MOV AH, 00H
        MOV AL, 03H
        INT 10H

        ;; PRINT ONE
        MOV AH, 0EH
        MOV AL, '1'
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 4
        MOV DL, 4
        INT 10H

        ;; PRINT TWO
        MOV AH, 0EH
        MOV AL, '2'
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 8
        MOV DL, 8
        INT 10H

mouse:
        
        MOV AX, 5
        MOV BX, 0
        INT 33H
        CMP AX, 0
        JNE mouse

        MOV xCoordinate, CX
        MOV yCoordinate, DX

        MOV AX, xCoordinate
        MOV DX, 0
        MOV BX, 8
        DIV BX
        MOV xCoordinate, AX

        MOV AX, yCoordinate
        MOV DX, 0
        MOV BX, 8
        DIV BX
        MOV yCoordinate, AX

        CMP xCoordinate, 2
        JNE next
        CMP yCoordinate, 2
        JNE next

        ;; PRINT ONE. 
        MOV AH, 0EH
        MOV AL, '1'
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 10
        MOV DL, 2
        INT 10H
        JMP exit

next:   
        CMP xCoordinate, 2
        JNE mouse
        CMP yCoordinate, 2
        JNE mouse

        ;; PRINT TWO. 
        MOV AH, 0EH
        MOV AL, '2'
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 10
        MOV DL, 2
        INT 10H

exit:     
        
        RET
main ENDP
