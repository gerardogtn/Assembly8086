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

getStringFromKeyBoard MACRO variableToStore, numOfChar
        LOCAL validKeyStroke
        LOCAL getFromKBLoop
        
        MOV CX, numOfChar
        MOV SI, 00
        
getFromKBLoop:  
        ;; CLEAR BUFFER
        MOV AH, 01
        
validKeyStroke: 
        INT 16H
        JZ validKeyStroke

        ;; GET CHARACTER FROM KEYBOARD
        MOV AH, 00
        INT 16H

        ;; STORE CHARACTER IN STRING
        MOV variableToStore[SI], AL
        INC SI

        LOOP getFromKBLoop

getStringFromKeyboard ENDM


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
;;; MODIFIES: AX. BX. 
printModulo MACRO  intA, intB
        MOV AX, intA
        DIV intB
        printNum BX, 10, 2, 4

printModulo ENDM       

;;; INT INT ->
;;; MODIFIES: AX. BX. DX.
printMultiplication MACRO  intA, intB
        MOV AX, intA
        MUL intB
        printNum AX, 10, 2, 8
        
printMultiplication ENDM

;;; INT INT ->
;;; MODIFIES: AX. BX. DX
printDivision MACRO  intA, intB
        MOV AX, intA
        DIV intB
        printNum AX, 10, 2, 4
        ;printForwards "    0", 10, 6
        printNum DX, 10, 10, 4
        printForwards "/0", 10, 15
        printNum intA, 10, 16, 4
        
printDivision ENDM

;;; INT INT ->
;;; MODIFIES: AX.
printSubstraction MACRO  intA, intB
        LOCAL negative
        LOCAL exit
        
        MOV AX, intA
        SUB AX, intB
        CMP AX, 0
        JNGE negative

        printNum AX, 10, 2, 4
        JMP exit

negative:
        printForwards "-0", 10, 2
        printNum AX, 10, 2, 4

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
                     DB 'y otro numero (3 digitos)', 0

        numA DW ?
        numB DW ?
        numAString DB '000',  0
        numBString DB '000',  0
        operatorString DB '0', 0
        output DW ?
        outputString DB '00000', 0  
        operatorASCII DB ?



;;; ********************** CODE ****************************
.CODE

;;; MAIN: starts program. 
main PROC
        CALL startVideoMode
        CALL printInstructions
        CALL getInputA
        CALL getOperator
        CALL getInputB
        CALL inputStringToNum
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
        getStringFromKeyBoard numAString, 3 
        RET

getInputA ENDP 

;;; GETOPERATOR:
;;; REQUIRES: GLOBAL VARIABLE NUMASTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: operatorString. 
;;; EFFECTS: Gets from the keyboard the operator input.
;;;          The operator must be one of: + / * - %
;;; TODO: ENFORCE THAT OPERATOR IS A VALID ONE. SOLVED WITH MOUSE INPUT.
getOperator PROC
        getStringFromKeyBoard operatorString, 1
        RET

getOperator ENDP

;;; GETINPUTB:
;;; REQUIRES: GLOBAL VARIABLE NUMBSTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: numBString. 
;;; EFFECTS: Gets from the keyboard the 3 character input. 
;;; Gets the second string number
getInputB PROC
        getStringFromKeyBoard numBString, 3 
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

        
        CMP operatorASCII, 53
        JNZ F
        printSum numA, numB
        RET

F:      
        CMP operatorASCII, 45
        JNZ G
        printModulo numA, numB
        RET

G:      
        CMP operatorASCII, 57
        JNZ H
        printDivision numA, numB
        RET

H:      
        CMP operatorASCII, 52
        JNZ I
        printMultiplication numA, numB
        RET

I:      
        CMP operatorASCII, 55
        JNZ J
        printSubstraction numA, numB

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


        
