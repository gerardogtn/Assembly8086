        ;; PRACTICA08
        ;; TEMPORIZADOR GRANDE

        
        VIDEO MACRO MSG, REN, COL

        LOCAL AB
        
        MOV SI, 00              ;CONTADOR DE INDICE (MAX 25)
        MOV DI, 1               ;CONTADOR DE FILAS (MAX 5)

        MOV BH, 00
        MOV BL 0F0H             ;FONDO BLANCO, LETRA NEGRA.
        
        MOV DH, REN             ;UBICAR CURSOR EN POSICION (COL, REN)
        MOV DL, COL
        
AB:     MOV AH, 02
        INT 10H

        MOV AH, 09              ;IMPRIMIR EL ELEMENTO EN EL INDICE SI
        MOV CX, 01              ;UNA VEZ. 
        MOV AL, MSG[SI]
        INT 10H
        
        INC SI                  ;INCREMENTAR INDICE
        INC DL                  ;INCREMENTAR COLUMNA

        MOV AX, DI              ;MULTIPLICA FILAS POR 5
        MOV AH, 05
        MUL AH

        CMP SI, AX              ;COMPARA INDICE CON CARACTERES NECESARIOS
                                ;PARA INCREMENTAR FILA.
        JNZ AB


        INC DH
        INC DI
        CMP DI, 06
        MOV DL, COL
        JNZ AB

        VIDEO ENDM
        
  
        ORG 100H

        .DATA
        ;; CADA BLOQUE CUENTA ES UNA MATRIZ DE 5X5.
        ;; EN TOTAL CADA BLOQUE TIENE 25 ELEMENTOS
        printZero  DB '00000'
                   DB '0   0'
                   DB '0   0'
                   DB '0   0'
                   DB '00000'

        printOne   DB '  11 '
                   DB '   1 '
                   DB '   1 '
                   DB '   1 '
                   DB '11111'

        printTwo   DB '22222'
                   DB '    2'
                   DB '22222'
                   DB '2    '
                   DB '22222'
        
        
        printThree DB '33333'
                   DB '    3'
                   DB '  333'
                   DB '    3'
                   DB '33333'


        printFour  DB '4   4'
                   DB '4   4'
                   DB '44444'
                   DB '    4'
                   DB '    4'


        printFive  DB '55555'
                   DB '5    '
                   DB '55555'
                   DB '    5'
                   DB '55555'

        printSix   DB '6    '
                   DB '6    '
                   DB '66666'
                   DB '6   6'
                   DB '66666'

        printSeven DB '77777'
                   DB '    7'
                   DB '    7'
                   DB '    7'
                   DB '    7'

        printEight DB '88888'
                   DB '8   8'
                   DB '88888'
                   DB '8   8'
                   DB '88888'

        printNine  DB '99999'
                   DB '9   9'
                   DB '99999'
                   DB '    9'
                   DB '    9'

        printSlash DB '    /'
                   DB '   / '
                   DB '  /  '
                   DB ' /   '
                   DB '/    '
        
        password      DB 'GGJVSRGCJR', 0
        passwordInput DB '          ', 0

        welcome DB 'Bienvenido al temporizador',      0
        minuteS DB 'Inserte el numero de minutos: ',  0
        secondS DB 'Inserte el numero de segundos: ', 0

        minute DB 0
        second DB 0

        printrow DB 2

        .CODE

;;; ************************************************************
main PROC
        
        MOV AH, 00              ;INITIALIZE VIDEO MODE
        MOV AH, 03H
        INT 10H

        MOV SI, 1300H
        
        MOV CX, 05              ;INSERTAR 5 DIGITOS. 
INSERTARDIGITO:
        CALL TECLA
        SUB AL, 30H             ;CONVERTIR ASCII A DECIMAL
        
        MOV  [SI], AL
        INC  SI
        LOOP INSERTARDIGITO

        MOV SI, 1300H
        CALL print

        RET
        
main ENDP

;;; **************************************************************
TECLA PROC
        MOV AH, 01

AC:
        INT 16H                 ;INSERTAR NUEVA TECLA SI LA TECLA
        JZ AC                   ;INSERTADA NO ES VALIDA
        
        MOV AH, 00              ;RECIBIR INFO DEL TECLADO, GUARDAR
        INT 16H                 ;EN AL
        
        MOV AH, 0EH             ;IMPRIMIR VALOR INSERTADO.
        INT 10H
        
        RET
TECLA ENDP


;;; **************************************************************
PRINT PROC
        MOV CX, 5
        
START:
        MOV AL, [SI]
        PUSH SI
        PUSH CX
        
        CMP AL, 0
        JZ ONE
        VIDEO printZero,  printrow, 2
        JMP NEXT
        
ONE:    CMP AL, 1
        JNZ TWO
        VIDEO printOne,   printrow, 2
        JMP NEXT
        
TWO:
        CMP AL, 2
        JNZ THREE
        VIDEO printTwo,   printrow, 2
        JMP NEXT
        
THREE:
        CMP AL, 3
        JNZ FOUR
        VIDEO printThree, printrow, 2
        JMP NEXT
        
FOUR:
        CMP AL, 4
        JNZ FIVE
        VIDEO printFour,  printrow, 2
        JMP NEXT
        
FIVE:
        CMP AL, 5
        JNZ SIX
        VIDEO printFive,  printrow, 2
        JMP NEXT
        
SIX:
        CMP AL, 6
        JNZ SEVEN
        VIDEO printSix,   printrow, 2
        JMP NEXT
        
SEVEN:
        CMP AL, 7
        JNZ EIGHT
        VIDEO printSeven, printrow, 2
        JMP NEXT
        
EIGHT:
        CMP AL, 8
        JNZ NINE
        VIDEO printEight, printrow, 2
        JMP NEXT
        
NINE:
        CMP AL, 9
        JNZ NOTNUMBER
        VIDEO printNine, printrow, 2
        JMP NEXT

NOTNUMBER:
        VIDEO printSlash, printrow, 2
        
        
NEXT:
        POP  CX
        POP  SI
        INC  SI
        ADD  printrow, 8
        LOOP START


        RET
PRINT ENDP


;;; ***************************************************
GETPASSWORD PROC
        MOV SI,  0
        MOV CX, 10

INSERTARPASSWORD:
        MOV AH, 01

AD:
        INT 16H                 ;INSERTAR NUEVA TECLA SI LA TECLA
        JZ AD                   ;INSERTADA NO ES VALIDA
        
        MOV AH, 00              ;RECIBIR INFO DEL TECLADO, GUARDAR
        INT 16H                 ;EN AL
        
        MOV  passwordInput[SI], AL
        INC  SI

        MOV AH, 0EH             ;IMPRIMIR VALOR INSERTADO.
        MOV AL, 2AH
        INT 10H
        
        LOOP INSERTARPASSWORD
        
        RET
GETPASSWORD ENDP
