;;; PROYECTO ORGANIZACION COMPUTACIONAL.
;;; PROF. KARINA SOSA.

;;; GERARDO GARCIA-TERUEL NORIEGA
;;; JUAN PABLO
;;; GUALBERTO CASAS
;;; JOSE DAVID RICO
;;;


;;; CALCULADORA EN ENSAMBLADOR.


;;; ********************** MACROS **************************


;;; PRINTFORWARDS: ASCIIZ, POSITIVE INTEGER, POSITIVE INTEGER.
;;; REQUIERS: - MSG IS IN ASCIIZ
;;;           - ROW IS A VALID SCREEN POSITION
;;;           - COL IS A VALID SCREEN POSITION
;;; PRINTS A NULL TERMINATED STRING IN THE SPECIFIED POSITION. 
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

        CMP AL, 0
        JZ printExit
        
        MOV AH, 0EH
        INT 10H                 ;IMPRIMIR CARACTER.

        INC SI
        JMP printLoop

printExit:  

printForwards ENDM


;;; STRINGTONUM:
;;; STRING NATURAL INT  ->
;;; GETS A STRING MADE OF DIGITS AND THE SIZE OF THE STRING.
;;; REQUIRES: THE STRING IS MADE OF DIGITS. SIZE IS SIZE OF THE STRING.
;;; MODIFIES: numberVar. SI. AH. CX. BL
;;; EFFECTS:  TRANSFORMS THE NUMBER STRING TO A NUMBER. 
stringToNum MACRO numberString, size, numberVar
        LOCAL STNL

        MOV SI, 00 
        MOV AH, 00
        MOV AL, 10
        MOV CX, size
        MOV numberVar, 0

STNL:              
        MUL numberVar 
        MOV numberVar, AX 
        MOV BL, numberString[SI]
        SUB BL, 30H   
        MOV BH, 0
        ADD numberVar, BX
        INC SI
        LOOP STNL

stringToNum ENDM
        
;;; INT INT ->
;;; MODIFIES: AX. 
printSum MACRO intA, intB
        
        MOV AX, intA
        ADD AX, intB
        printNum AX, 10, 2, 6
        
printSum ENDM 

;;; INT INT ->
;;; MODIFIES: AX. BX. DX. REMAINDER. 
printPercent MACRO  intA, intB
              
        ;; PRINT QUOTIENT*100
        MOV DX, 0
        MOV AX, intA
        DIV intB
        MOV BX, 100 
        MOV remainder, DX
        MUL BX
        MOV SI, AX

        ;; ADD REMAINDER*100/DIVISOR TO AX.
        MOV AX, remainder
        MOV DX, 0
        MUL BX
        DIV intB
        MOV remainder, DX
        ADD SI, AX

        ;; PRINT NUM
        printNum SI, 10, 2, 6

        ;; PRINT DOT SYMBOL
        MOV AH, 02H
        MOV AL, '.'
        MOV BH, 00
        MOV BL, 0F0H
        MOV DH, 10
        MOV DL, 9
        INT 10H
        MOV AH, 0EH
        INT 10H

        ;; PRINT DECIMAL TO TWO SIG FIGS. 
        printDecimal remainder, intB, 2, 10, 10

        ;; PRINT PERCENT SYMBOL
        MOV AH, 02H
        MOV AL, '%'
        MOV BH, 00
        MOV BL, 0F0H
        MOV DH, 10
        MOV DL, 12
        INT 10H
        MOV AH, 0EH
        INT 10H
        
printPercent ENDM       
                  
                  
                  
;; TODO: MULTIPLY MAXNUM TIMES DX AFTER
;; MULTIPLICATION IS DONE. 
                  
;;; INT INT ->
;;; MODIFIES: AX. BX. DX.
printMultiplication MACRO  intA, intB
        LOCAL p1
        LOCAL p2
        LOCAL p3
        LOCAL p4
        LOCAL p5
        LOCAL p6
        LOCAL p7
        LOCAL p8
        LOCAL p9
        LOCAL p10
        LOCAL p11
        LOCAL p12
        LOCAL p13
        LOCAL overflow
        LOCAL exit

        ;; MAKE MULTIPLICATION
        MOV AX, intA
        MUL intB  

        ;; HANDLE OVERFLOW
        JO overflow

        ;; PRINT AND EXIT IF NO OVERFLOW. 
        printNum AX, 10, 2, 8
        JMP exit

        

overflow:
        CMP DX, 1
        JNZ p2
        printSumNumString AX, maxNum1
        JMP exit

p2:     
        CMP DX, 2
        JNZ p3
        printSumNumString AX, maxNum2
        JMP exit

p3:     
        CMP DX, 3
        JNZ p4
        printSumNumString AX, maxNum3
        JMP exit

p4:     
        CMP DX, 4
        JNZ p5
        printSumNumString AX, maxNum4
        JMP exit

p5:     
        CMP DX, 5
        JNZ p6
        printSumNumString AX, maxNum5
        JMP exit

p6:     
        CMP DX, 6
        JNZ p7
        printSumNumString AX, maxNum6
        JMP exit

p7:     
        CMP DX, 7
        JNZ p8
        printSumNumString AX, maxNum7
        JMP exit

p8:     
        CMP DX, 8
        JNZ p9
        printSumNumString AX, maxNum8
        JMP exit

p9:     
        CMP DX, 9
        JNZ p10
        printSumNumString AX, maxNum9
        JMP exit

p10:    
        CMP DX, 10
        JNZ p11
        printSumNumString AX, maxNumA
        JMP exit

p11:    
        CMP DX, 11
        JNZ p12
        printSumNumString AX, maxNumB
        JMP exit

p12:    
        CMP DX, 12
        JNZ p13
        printSumNumString AX, maxNumC
        JMP exit

p13:    
        CMP DX, 13     
        JNZ p14
        printSumNumString AX, maxNumD 
        
p14:
        CMP DX, 14
        JNZ p15
        printSumNumString AX, maxNumE
        
p15: 
        printSumNumString AX, maxNumF
        
exit:
        
        
printMultiplication ENDM



        
printSumNumString MACRO numA, stringA
        LOCAL overflow
        LOCAL modifyOutput
        LOCAL exit
        
        MOV AX, numA
        
        ;; SI: OVERFLOW STRING INDEX
        MOV SI, 6
        ;; DI: MAXNUM STRING INDEX
        MOV DI, 6

overflow:       
        ;; STOPPING CONDITION.
        CMP DI, 0
        JNG exit

        ;; DIVIDE RESULT BY TEN.
        MOV DX, 0
        MOV BX, 10
        DIV BX 
        MOV remainder, DX

        ;; ADD RESPECTIVE POSITIONS.
        MOV BL,stringA[DI]
        SUB BL, 30H
        ADD BX, remainder

        ;; IF SUM OF DIGITS IS GREATER THAN 10, JMP TO MTTD
        CMP BL, 10
        JGE modifyOutput

        ;; STORE OUTPUT IN OVERFLOWSTRING
        ADD BL, 30H
        MOV overflowString[SI], BL
        DEC SI
        DEC DI
        JMP overflow
        
modifyOutput:
        
        SUB BL, 10
        ADD BL, 30H
        MOV overflowString[SI], BL
        DEC SI
        DEC DI

        MOV BL, stringA[DI]
        INC BL
        MOV stringA[DI], BL
        JMP overflow

exit:

        printForwards overflowString, 10,2

printSumNumString ENDM
        
        
;;; INT INT ->
;;; MODIFIES: AX. BX. DX. REMAINDER
printDivision MACRO  intA, intB

        ;; PRINT QUOTIENT
        MOV DX, 0
        MOV AX, intA
        DIV intB
        MOV remainder, DX
        printNum AX, 10, 2, 4

        ;; PRINT DOT
        MOV AH, 02H
        MOV AL, '.'
        MOV BH, 00
        MOV BL, 0F0H
        MOV DH, 10
        MOV DL, 7
        INT 10H
        MOV AH, 0EH
        INT 10H

        ;; PRINT DECIMAL TO TWO SIG FIGS. 
        printDecimal remainder, intB, 2, 10, 8
        
printDivision ENDM


        
printDecimal MACRO remainder, divisor, sigFigs, row, col
        LOCAL PRL

        ;; ADJUST CURSOR
        MOV CX, sigFigs
        MOV AH, 02H
        MOV BH, 00
        MOV BL, 0F0H
        MOV DH, row
        MOV DL, col
        INT 10H

PRL:
        ;; MULTIPLY REMAINDER BY 10
        MOV AX, remainder
        MOV BX, 10
        MUL BX

        ;; DIVIDE MODIFIED REMAINDER BY DIVISOR. RESULT IN AX. 
        MOV DX, 0
        DIV divisor

        ;; STORE NEW REMAINDER IN remainder. 
        MOV remainder, DX

        ;; PRINT CHARACTER IN SCREEN. 
        MOV AH, 0EH
        ADD AL, 30H
        INT 10H

        LOOP PRL

printDecimal ENDM

        
;;; INT INT ->
;;; MODIFIES: AX.
printSubstraction MACRO intA, intB
        LOCAL negative
        LOCAL exit

        MOV AX, intA
        MOV BX, intB

        ;; IF intA is NOT >= intB, jump to Negative:
        CMP AX, BX
        JNGE negative

        ;; Print result of substraction.
        SUB AX, BX
        printNum AX, 10, 2, 4

        ;; EXIT
        JMP exit

negative:
        ;; PRINT NEGATIVE SIGN.
        MOV AH, 02H
        MOV AL, '-'
        MOV BH, 00
        MOV BL, 0F0H
        MOV DH, 10
        MOV DL, 2
        INT 10H
        MOV AH, 0EH
        INT 10H

        ;; MAKE SUBSTRACTION IN REVERSE ORDER. 
        MOV AX, intB
        SUB AX, intA

        ;; PRINT OUTPUT
        printNum AX, 10, 3, 4

exit:   
        
printSubstraction ENDM
        

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
      
;;; ********************** DATA ****************************
.DATA
        instructionA DB 'Inserte un numero (3 digitos), un operador'
                     DB ' y otro numero (3 digitos)', 0

        numA      DW 900
        numB      DW 999
        remainder DW ?
        output    DW 0
        
        numAString     DB '000',         0
        numBString     DB '000',         0
        operatorString DB '-',           0
        outputString   DB '00000',       0
        
        overflowString  DB '       ', 0
        maxNum1         DB '0065536',   0
        maxNum2         DB '0131072',   0
        maxNum3         DB '0196608',   0
        maxNum4         DB '0262144',   0
        maxNum5         DB '0327680',   0
        maxNum6         DB '0393216',   0
        maxNum7         DB '0458752',   0
        maxNum8         DB '0524288',   0
        maxNum9         DB '0589824',   0
        maxNumA         DB '0655360',   0
        maxNumB         DB '0720896',   0
        maxNumC         DB '0786432',   0
        maxNumD         DB '0851968',   0 
        maxNumE         DB '0917504',   0
        maxNumF         DB '0983040',   0
        
        
        operatorASCII DB ?



;;; ********************** CODE ****************************
.CODE

;;; MAIN: starts program. 
main PROC
        CALL startVideoMode
        ;CALL printInstructions
        ;CALL getInputA
        ;CALL getOperator
        ;CALL getInputB
        ;CALL inputStringToNum   
        printNum numA, 2, 2, 3
        printForwards operatorString, 2, 6
        printNum numB, 2, 7, 3  
        CALL printOperation
        RET
main ENDP


;;; STARTVIDEOMODE:
;;; REQUIRES: None
;;; MODIFIES: AX
;;; EFFECTS : Starts wide video mode. 
;;; Starts wide video mode. 
startVideoMode PROC
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
        RET
startVideoMode ENDP 


;;; PRINTINSTRUCTIONS:
;;; REQUIRES:
;;; MODIFIES:
;;;  EFFECTS:
;;; Prints all relevant instructions to the execution of the program.
        
;;; TODO: PROCEDURE.
printInstructions PROC
        printForwards instructionA, 2, 2
        RET
printInstructions ENDP


;;; GETINPUTA:
;;; REQUIRES: GLOBAL VARIABLE NUMASTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: numAstring. 
;;; EFFECTS: Gets from the keyboard the 3 character input. 
;;; Gets the first string number
getInputA PROC
        
        RET

getInputA ENDP 

;;; GETOPERATOR:
;;; REQUIRES: GLOBAL VARIABLE NUMASTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: operatorString. 
;;; EFFECTS: Gets from the keyboard the operator input.
;;;          The operator must be one of: + / * - %
;;; TODO: ENFORCE THAT OPERATOR IS A VALID ONE. SOLVED WITH MOUSE INPUT.
getOperator PROC
        
        RET

getOperator ENDP

;;; GETINPUTB:
;;; REQUIRES: GLOBAL VARIABLE NUMBSTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: numBString. 
;;; EFFECTS: Gets from the keyboard the 3 character input. 
;;; Gets the second string number
getInputB PROC
       
        RET
getInputB ENDP


;;; INPUTSTRINGTONUM
;;; REQUIRES: Global variables NumAString, NumBString, NumA, and NumB exist.
;;; ASSUMES : numAString and NumBString only contain numerical characters. 
;;; MODIFIES: numA. NumB.
;;; EFFECTS : Transform a string of digits to its numerical representation. 
;;; Transform the number strings to numbers.
inputStringToNum PROC
        stringToNum numAString, 3, numA
        stringToNum numBString, 3, numB
        RET
inputStringToNum ENDP
        

;;; MAKEOPERATION:
;;; REQUIRES: Operator is one of: + / * - %
;;; MODIFIES: output
;;; EFFECTS : Gets the result of doing operator on the arguments numA and numB
;;; Numerical output is obtained
;;; WARNING: OVERFLOW MAY OCCUR.
                
printOperation PROC
        MOV AH, operatorString[0]
        MOV operatorASCII, AH

                          
        ;; HANDLES +                  
        CMP operatorASCII, 53O
        JNZ F
        printSum numA, numB
        RET        
        
        ;; HANDLES %

F:          
        CMP operatorASCII, 45O
        JNZ G
        printPercent numA, numB
        RET         
        
        ;; HANDLES /

G:      
        CMP operatorASCII, 57O
        JNZ H
        printDivision numA, numB
        RET     
        
        
        ;; HANDLES *                 
H:             
        CMP operatorASCII, 52O
        JNZ I
        printMultiplication numA, numB
        RET
              
              
        ;; HANDLES -      
I:      
        CMP operatorASCII, 55O
        JNZ J
        printSubstraction numA, numB 
        
        ;; ELSE: DOES NOTHING

J:      
        RET

printOperation ENDP
        

;;; OUTPUTTOSTRING
;;; REQUIRES: Output is a valid number. 
;;; MODIFIES: OutputString. 
;;;  EFFECTS: Gets the output string from output. 
;;;
                
;;; TODO: PROCEDURE. CREATE A MACRO. 
outputToString PROC
        ;; STUB
        RET
outputToString ENDP

;;; DISPLAYOUTPUT
;;; ASSUMES:  outputString is correct.
;;; REQUIRES: None.
;;; MODIFIES:
;;; EFFECTS:  Prints to screen the output string. 
;;; Displays in screen
displayOutput PROC
        printForwards outputString, 13, 2
        RET
displayOutput ENDP
        
        
        END main


        
