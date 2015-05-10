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
        MOV AH, 02H
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 4      
        MOV DL, 4 
        INT 10H
          
        MOV AH, 0EH
        MOV AL, '1'
        INT 10H

        ;; PRINT TWO
        MOV AH, 02H
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 8
        MOV DL, 8
        INT 10H 
        
        MOV AH, 0EH
        MOV AL, '2'
        INT 10H
  
        ;; START MOUSE TRACKING
        MOV AX, 0
        INT 33H
        CMP AX, 0
        JE MNA   
        
        ;; DISPLAY MOUSE
        MOV AX, 1
        INT 33H
  
  
mouse:
              
        MOV AH, 00          
        MOV AL, 3
        MOV BX, 0
        INT 33H
        CMP BX, 1
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

        CMP xCoordinate, 4
        JNE next
        CMP yCoordinate, 4
        JNE next

        ;; PRINT ONE. 
        MOV AH, 02H
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 10
        MOV DL, 2 
        INT 10H
          
        MOV AH, 0EH
        MOV AL, '1'
        INT 10H      
        JMP EXIT

next:   
        CMP xCoordinate, 8
        JNE mouse
        CMP yCoordinate, 8
        JNE mouse

        ;; PRINT TWO. 
        MOV AH, 02H
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 10
        MOV DL, 2 
        INT 10H
          
        MOV AH, 0EH
        MOV AL, '2'
        INT 10H  
        JMP exit      
        
  
MNA:
        MOV AH, 02H
        MOV BH, 00H
        MOV BL, 0F0H
        MOV CX, 0
        MOV DH, 10
        MOV DL, 2 
        INT 10H
          
        MOV AH, 0EH
        MOV AL, 'A'
        INT 10H 
        
  
  
exit:     
        
        RET
main ENDP
