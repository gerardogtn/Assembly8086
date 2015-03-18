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
        printZero  BYTE '00000'
                   BYTE '0   0'
                   BYTE '0   0'
                   BYTE '0   0'
                   BYTE '00000'

        printOne   BYTE '  11 '
                   BYTE '   1 '
                   BYTE '   1 '
                   BYTE '   1 '
                   BYTE '11111'

        printTwo   BYTE '22222'
                   BYTE '    2'
                   BYTE '22222'
                   BYTE '2    '
                   BYTE '22222'
        
        
        printThree BYTE '33333'
                   BYTE '    3'
                   BYTE '  333'
                   BYTE '    3'
                   BYTE '33333'


        printFour  BYTE '4   4'
                   BYTE '4   4'
                   BYTE '44444'
                   BYTE '    4'
                   BYTE '    4'


        printFive  BYTE '55555'
                   BYTE '5    '
                   BYTE '55555'
                   BYTE '    5'
                   BYTE '55555'

        printSix   BYTE '6    '
                   BYTE '6    '
                   BYTE '66666'
                   BYTE '6   6'
                   BYTE '66666'

        printSeven BYTE '77777'
                   BYTE '    7'
                   BYTE '    7'
                   BYTE '    7'
                   BYTE '    7'

        printEight BYTE '88888'
                   BYTE '8   8'
                   BYTE '88888'
                   BYTE '8   8'
                   BYTE '88888'

        printNine  BYTE '99999'
                   BYTE '9   9'
                   BYTE '99999'
                   BYTE '    9'
                   BYTE '    9'

        printSlash BYTE '    /'
                   BYTE '   / '
                   BYTE '  /  '
                   BYTE ' /   '
                   BYTE '/    '
        
        password      BYTE 'GGJVSRGCJR', 0
        passwordInput BYTE '          ', 0

        welcome BYTE 'Bienvenido al temporizador',      0
        minuteS BYTE 'Inserte el numero de minutos: ',  0
        secondS BYTE 'Inserte el numero de segundos: ', 0

        minute BYTE 0
        second BYTE 0

        printrow BYTE 2

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
        
        MOV [SI], AL
        INC SI
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
        VIDEO SLASH,     printrow, 2
        
        
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

AC:
        INT 16H                 ;INSERTAR NUEVA TECLA SI LA TECLA
        JZ AC                   ;INSERTADA NO ES VALIDA
        
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
