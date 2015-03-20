printStrings MACRO MSG, ROW, COL
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

printStrings ENDM  

        
        ORG 100H                ;START .COM FILE.

.DATA
        ;; LENGTH: 43
        mensajeBienvenida DB 'Inserte el numero de la opcion a ejecutar: ', 0
        clearBienvenida   DB '                                             ', 0

        ;; LENGTH: 6
        printMenu         DB 'Menu: ', 0
        clearMenu         DB '      ', 0
        ;; LENGTH: 13
        printCronometro   DB '1: Cronometro',   0
        clearCronometro   DB '             ',   0
        ;; LENGTH: 15
        printTemporizador DB '2: Temporizador', 0
        clearTemporizador DB '               ', 0
        ;; LENGTH: 8
        printSalir        DB '3: Salir',        0
        clearSalir        DB '        ',        0

        
        opcionSeleccionada DB 0

        ;; OPCIONES CRONOMETRO
        printStop   DB 'Para detener, oprima ENTER',   0
        clearStop   DB '                          ',   0
        printPlay   DB 'Para continuar, oprima S',     0
        clearPlay   DB '                        ',     0
        printGoBack DB 'Para salir al menu, oprima R', 0
        clearGoBack DB '                            ', 0
        
        counterCronometro   DW 0
        counterCronometroString DB '    ', 0
        isCronometroOn      DW 1
        addToCronometro     DW 1

        ;; OPCIONES TEMPORIZADOR
        ;; LENGTH 42
        printInstructions DB 'Inserte el numero de segundos (2 digitos): ', 0
        counterTemporizador DB 0
        counterTemporizadorString DB '  ', 0
        
       
        


.CODE

main PROC
        MOV AX, @DATA           ;INITIALIZE DATA SEGMENT. 
        MOV DS, AX

        
        MOV AH, 00H
        MOV AL, 03H
        INT 10H                 ;START VIDEO MODE.

        call displayMenu
        call selectOption


        RET
main ENDP

displayMenu PROC

        ;; IMPRIMIR OPCIONES DE MENU
        printStrings printMenu,          8, 37
        printStrings printCronometro,   12,  2
        printStrings printTemporizador, 16,  2
        printStrings printSalir,        20,  2

        
        ;; IMPRIMIR MENSAJE DE BIENVENIDA
        printStrings mensajeBienvenida, 24,  2
        RET
displayMenu ENDP


selectOption PROC
        call insertarOpcion

        CMP opcionSeleccionada, 1
        JNZ optionTwo
        CALL cronometro
        RET

optionTwo:
        CMP opcionSeleccionada, 2
        JNZ optionThree
        CALL temporizador
        RET
        

optionThree:
        CMP opcionSeleccionada, 3
        JNZ exit
        CALL salirST
        RET

exit:
        

        RET
selectOption ENDP        

insertarOpcion PROC
        ;; Ajustar posicion del cursor
        MOV DH, 24
        MOV DL, 46

        ;; Ajustar color de los valores a insertar
        MOV BH, 00
        MOV BL, 0F0H

        ;; Recibir valores del teclado
        MOV AH, 01
teclaValida:
        INT 16H
        JZ teclaValida

        MOV AH, 00
        INT 16H

        MOV AH, 0EH
        INT 10H

        SUB AL, 30H             ;CONVERTIR ASCII A DECIMAL
        
        MOV opcionSeleccionada, AL 

        RET
insertarOpcion ENDP

        
cronometro PROC
        call emptyMenuScreen
        call cronometroMenu

        

        ;; print currentCronometro
incrementCronometro:
        mov al, counterCronometro
        ADD AL, 30H

        CALL CRONOMETROTOASCII
        printStrings counterCronometroString, 10, 40

        ;; Wait one second
        MOV CX, 0FH
        MOV DX, 04240H
        MOV AH, 86H
        INT 15H
        
        ;; Increment cronometro counter
        MOV AX, addToCronometro
        ADD counterCronometro, AX
        
        ;; Recibir tecla:
valida: 
        MOV AH, 01
        INT 16H
        JZ incrementCronometro

        MOV AH, 00
        INT 16H

        CMP AL, 13
        JZ stopCronometro

        CMP AL, 83
        JZ playCronometro

        CMP AL, 82
        JZ goToMenu

        JMP incrementCronometro

stopCronometro:
        CMP isCronometroOn, 1
        JNZ incrementCronometro

        MOV isCronometroOn, 0
        MOV addToCronometro, 0
        DEC counterCronometro
        JMP incrementCronometro


playCronometro:
        CMP isCronometroOn, 0
        JNZ incrementCronometro

        MOV isCronometroOn, 1
        MOV addToCronometro, 1
        INC counterCronometro
        JMP incrementCronometro
        
goToMenu:  
        CALL emptyCronometroScreen
        CALL main 
       
        RET
cronometro ENDP

        
cronometroMenu PROC      
        printStrings printCronometro,  1, 2 
        printStrings printStop,        3, 2
        printStrings printPlay,        4, 2
        printStrings printGoBack,      5, 2
        RET
cronometroMenu ENDP

        
emptyCronometroScreen PROC
        printStrings clearCronometro,  1, 2 
        printStrings clearStop,        3, 2
        printStrings clearPlay,        4, 2
        printStrings clearGoBack,      5, 2
        RET
emptyCronometroScreen ENDP

        
temporizador PROC
        call emptyMenuScreen
        call temporizadorMenu
        call obtenerCounterTemporizador

FINALLOOP:      
        printStrings counterTemporizadorString, 10, 40
        DEC counterTemporizador
        CALL ASCIITOTEMPORIZADOR

        ;; Wait one second
        MOV CX, 0FH
        MOV DX, 04240H
        MOV AH, 86H
        INT 15H
        
        CMP counterTemporizador, 0
        JNZ FINALLOOP

        
        RET
temporizador ENDP

temporizadorMenu PROC
        printStrings printTemporizador, 1, 2
        printStrings printInstructions, 3, 2 
        RET
temporizadorMenu ENDP

obtenerCounterTemporizador PROC
       
        MOV CX, 2
        MOV BL, 100
        MOV SI, 0
        
COUNTERLOOP:  
        MOV AH, 01
AC:     INT 16H
        JZ AC

        MOV AH, 00
        INT 16H

        MOV AH, 0EH
        INT 10H

        MOV counterTemporizadorString[SI], AL
        INC SI
        
        MUL BL
        ADD counterTemporizador, AL

        mov BX, 10
        LOOP COUNTERLOOP
       
        
        RET
obtenerCounterTemporizador ENDP
        

salirST PROC
        RET
salirST ENDP


emptyMenuScreen PROC
        printStrings clearMenu,          8, 37
        printStrings clearCronometro,   12,  2
        printStrings clearTemporizador, 16,  2
        printStrings clearSalir,        20,  2

        printStrings clearBienvenida,   24,  2
 
        RET
        
emptyMenuScreen ENDP
        

CRONOMETROTOASCII         PROC
        MOV DX, 0000H
        MOV SI, 3
        MOV AX, counterCronometro
        MOV BX, 10
        MOV CX, 4

LOOPS:
        DIV BX
        ADD DX, 30H             ;CONVERT TO ASCII
        MOV counterCronometroString[SI], DL
        DEC SI
        MOV DX, 0
        LOOP LOOPS

        RET
CRONOMETROTOASCII         ENDP


        
ASCIITOTEMPORIZADOR       PROC
        MOV DX, 0000H
        MOV SI, 1
        MOV AX, counterTemporizador
        MOV BX, 10
        MOV CX, 2

LOOPS2:
        DIV BX
        ADD DX, 30H             ;CONVERT TO ASCII
        MOV counterTemporizadorString[SI], DL
        DEC SI
        MOV DX, 0
        LOOP LOOPS2

        RET
ASCIITOTEMPORIZADOR      ENDP
