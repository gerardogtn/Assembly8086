
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

        CMP AL, 'A'
        JZ printExit
        
        MOV AH, 0EH
        INT 10H                 ;IMPRIMIR CARACTER.

        INC SI
        JMP printLoop

printExit:  

printForwards ENDM


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
       
stringToNum MACRO string, integer
        LOCAL exit
        LOCAL start

start:  
        MOV SI, 0
        MOV BX, 10
        MOV AX, string[SI]
        CMP AL, 'A'
        JE exit

        MOV DI, AX
        MOV AX, integer
        MUL BX
        ADD AX, DI
        MOV integer, AX
        INC SI
        JMP start

exit:
        

stringToNum ENDM
        
        ORG 100H


        .DATA
        numAString DB  "999", 'A'
        numA       DB 0



        .CODE

        main PROC
        printForwards numAString, 2, 2
        printNum      numA, 3, 2, 3

        stringToNum numAString, numA
        printForwards numAString, 4, 2
        printNum      numA, 5, 2, 3

        RET

        main ENDP


        ENDS main
