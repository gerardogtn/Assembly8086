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






        ORG 100H


;;; ********************** DATA ****************************
.DATA
        instructionA DB 'Inserte un numero (3 digitos), un operador
                     DB 'y otro numero (3 digitos)', 0

        numA DW ?
        numB DW ?
        numAString DB '000',  0
        numBString DB '000',  0
        operatorString DB '0', 0
        output DW ?
        outputString '00000', 0



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
        CALL makeOperation
        CALL outputToString
        CALL displayOutput

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
printInstructions PROC
        ;; STUB
        RET
printInstructions ENDP


;;; GETINPUTA:
;;; REQUIRES: GLOBAL VARIABLE NUMASTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: numAstring. 
;;; EFFECTS: Gets from the keyboard the 3 character input. 
;;; Gets the first string number
getInputA PROC
        ;; STUB
        RET

getInputA ENDP 

;;; GETOPERATOR:
;;; REQUIRES: GLOBAL VARIABLE NUMASTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: operatorString. 
;;; EFFECTS: Gets from the keyboard the operator input.
;;;          The operator must be one of: + / * - %
;;; Gets the operator string. 
getOperator PROC
        ;; STUB
        RET

getOperator ENDP

;;; GETINPUTB:
;;; REQUIRES: GLOBAL VARIABLE NUMBSTRING EXISTS AND IS THREE CHARACTERS LONG.
;;; MODIFIES: numBString. 
;;; EFFECTS: Gets from the keyboard the 3 character input. 
;;; Gets the second string number        
getInputB PROC
        ;; STUB
        RET
getInputB ENDP


;;; INPUTSTRINGTONUM
;;; REQUIRES: Global variables NumAString, NumBString, NumA, and NumB exist.
;;; ASSUMES : numAString and NumBString only contain numerical characters. 
;;; MODIFIES: numA. NumB.
;;; EFFECTS : Transform a string of digits to its numerical representation. 
;;; Transform the number strings to numbers. 
inputStringToNum PROC
        ;; STUB
        RET
inputStringToNum ENDP
        

;;; MAKEOPERATION:
;;; REQUIRES: Operator is one of: + / * - %
;;; MODIFIES: output
;;; EFFECTS : Gets the result of doing operator on the arguments numA and numB
;;; Numerical output is obtained
;;; WARNING: OVERFLOW MAY OCCUR. 
makeOperation PROC
        ;; STUB
        RET

makeOperation ENDP
        

;;; OUTPUTTOSTRING
;;; REQUIRES: Output is a valid number. 
;;; MODIFIES: OutputString. 
;;;  EFFECTS: Gets the output string from output. 
;;; 
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
        ;; STUB
        RET
displayOutput ENDP
        
        
        END main


        
