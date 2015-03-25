ORG 100H
JMP INICIO  
    
TEXTO DB 'SELECCIONA FORMATO 1)HH:MM:SS 2)MM:HH:SS 3)SS:MM:HH', 0
P1 DB 0
P2 DB 0
P3 DB 0
  
INICIO: 
MOV AX,0  
INT 10H ;INICIALIZA 
MOV SI,0
MOV BL,0FH 
MOV DX,00   

ITEXTO: MOV AH, 02
        MOV BH, 00
        INT 10H   ;POSICION EN DONDE INDICA
        MOV AH, 09
        MOV AL, TEXTO[SI] 
        MOV CX, 1
        INT 10H ;IMPRIME COLOR
        INC SI
        INC DL 
        MOV AL, TEXTO[SI] 
O1:     CMP AL, 31H
        JNZ O2
        MOV DL,0
        MOV DH,1 
        JMP ITEXTO  
O2:     CMP AL, 32H
        JNZ O3
        MOV DL,0
        MOV DH,2 
        JMP ITEXTO 
O3:     CMP AL,33H
        JNZ BACK
        MOV DL,0
        MOV DH,3 
        JMP ITEXTO
BACK:   CMP AL,0
        JNZ ITEXTO 
        
AT:       
    MOV AH,01
    INT 16H 
    JZ AT  
    MOV AH,00
    INT 16H 
    CMP AL,31H
    JNZ OP1 
    MOV P1,0
    MOV P2,3
    MOV P3,6 
    JMP SIGNOS
OP1:CMP AL,32H
    JNZ OP2  
    MOV P1,3
    MOV P2,0
    MOV P3,6 
    JMP SIGNOS
OP2:CMP AL,33H
    JNZ OP3
    MOV P1,6
    MOV P2,3
    MOV P3,0 
    JMP SIGNOS
OP3:JMP AT 


SIGNOS:
MOV AH,02H
MOV DH,5
MOV DL,2
INT 10H 
MOV AH,0AH
MOV AL,3AH
MOV CX,1  
MOV BX,0
INT 10H 
MOV AH,02H
MOV DL,05
INT 10H
MOV AH,0AH
INT 10H 

HORA:
MOV AH,2CH
INT 21H 
MOV AL,CH 
MOV DH,5 
MOV DL,P1
MOV CX,1
JMP NO  

MIN:
MOV AH,2CH
INT 21H 
MOV AL,CL 
MOV DH,5
MOV DL,P2 
MOV CX,1
JMP NO  

SEG:  
MOV AH,2CH
INT 21H 
MOV AL,DH 
MOV DH,5
MOV DL,P3
MOV CX,1
JMP NO 

NO:
    CMP AL,09H
    JG U    
    MOV AH,02H
    INC DL
    INT 10H 
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H 
    MOV AH,0AH
    MOV AL,30H
    INT 10H 
    CMP DL,P1
    JZ MIN 
    CMP DL,P2
    JZ SEG
    CMP DL,P3
    JZ HORA
    
U:  CMP AL,13H
    JG  D
    MOV AH,02H
    INC DL
    INT 10H 
    SUB AL,0AH
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H  
    MOV AH,0AH
    MOV AL,31H
    INT 10H
    CMP DL,P1
    JZ MIN 
    CMP DL,P2
    JZ SEG
    CMP DL,P3
    JZ HORA

D:  CMP AL,1DH
    JG  T
    MOV AH,02H
    INC DL
    INT 10H 
    SUB AL,14H
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H
    MOV AH,0AH
    MOV AL,32H
    INT 10H
    CMP DL,P1
    JZ MIN  
    CMP DL,P2
    JZ SEG
    CMP DL,P3 
    JZ HORA

T:  CMP AL,27H
    JG  C
    MOV AH,02H
    INC DL
    INT 10H 
    SUB AL,1EH
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H 
    MOV AH,0AH
    MOV AL,33H
    INT 10H
    CMP DL,P1
    JZ MIN 
    CMP DL,P2
    JZ SEG
    CMP DL,P3
    JZ HORA

C:  CMP AL,31H
    JG  CI
    MOV AH,02H
    INC DL
    INT 10H 
    SUB AL,28H
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H   
    MOV AH,0AH
    MOV AL,34H
    INT 10H
    CMP DL,P1
    JZ MIN 
    CMP DL,P2
    JZ SEG
    CMP DL,P3 
    JZ HORA
    
CI: MOV AH,02H
    INC DL
    INT 10H 
    SUB AL,32H
    ADD AL,30H
    MOV AH,0AH
    INT 10H  
    MOV AH,02H
    DEC DL
    INT 10H  
    MOV AH,0AH
    MOV AL,35H
    INT 10H
    CMP DL,P1
    JZ MIN 
    CMP DL,P2
    JZ SEG
    CMP DL,P3 
    JZ HORA
    
  
