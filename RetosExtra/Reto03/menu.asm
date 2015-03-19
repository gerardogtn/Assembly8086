printStrings MACRO MSG, ROW, COL
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
        RET

printStrings ENDM  

        
        ORG 100H                ;START .COM FILE.

.DATA
        ;; LENGTH: 43
        mensajeBienvenida DB 'Inserte el numero de la opcion '
                          DB 'a ejecutar: ', 0


        ;; LENGTH: 6
        printMenu         DB 'Menu: ', 0
        ;; LENGTH: 13
        printCronometro   DB '1: Cronometro',   0
        ;; LENGTH: 15
        printTemporizador DB '2: Temporizador', 0
        ;; LENGTH: 8
        printSalir        DB '3: Salir',        0
        



.CODE

main PROC

        MOV AH, 00H
        MOV AL, 03H
        INT 10H                 ;START VIDEO MODE.

        call displayMenu
        call selectOption


        RET
main ENDP

displayMenu PROC

        ;; IMPRIMIR MENSAJE DE BIENVENIDA
        printStrings mensajeBienvenida, 2, 20

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



        RET
selectOption ENDP        


temporizador PROC



        RET
temporizador ENDP



cronometro PROC

        RET
cronometro ENDP
