printNum MACRO intA, ROW, COL, numDigits
        LOCAL printLoop  
        LOCAL printExit 
                               
        MOV BH, 00  
        MOV CH, 00
        MOV CL, numDigits
        ADD CL, COL
        MOV SI, intA

printLoop:   
        MOV BL, 10
        CMP SI, 0
        JNG printExit
        
        ;; DIVIDE NUMBER BY TEN.
        MOV DX, 0000
        MOV AX, SI
        DIV BX

        ;; STORE RESULT IN SI
        MOV SI, AX

        ;; ADJUST CURSOR
        MOV BL, DL 
        MOV DH, ROW
        MOV DL, CL  
        MOV AH, 02H
        INT 10H        
                   
        ;; PRINT DIGIT        
        MOV AH, 0EH
        MOV AL, BL
        ADD AL, 30H
        DEC CL 
        INT 10H    
        
        JMP printLoop
                
printExit:                
                

printNum ENDM 



ORG 100H



;;; ########################################################################
.DATA
        numA DW 400
        numB DW 2500  
        numC DW 400



;;; ########################################################################
.CODE

main PROC
        MOV AH, 00H
        MOV AL, 00H
        INT 10H            
        
        printNum numA, 4, 2, 3
        printNum numB, 8, 2, 4
        printNum numC, 4, 2, 3
        RET
main ENDP 


        
