ORG 100H
MOV AL, 18 
MOV BL, 25
MUL BL 
MOV DI, AX
MOV DX, 00
MOV AX , 18
CICLO: MOV CL, BL 
MOV CH, 00
AB: ADD DX, AX 
LOOP AB
RET