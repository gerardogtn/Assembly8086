; Calcular y almacenar los primeros 35 digitos de la serie
; de Fibonacci.         

ORG 100H ; Archivo COM.  


MOV [0200H], 0
MOV [0201H], 0
MOV [0202H], 1
MOV [0203H], 0
MOV [0204H], 0
MOV [0205H], 1


MOV AX, 1
MOV BX, 0205H
MOV CX, 33

FIBONACCI:   
    ; Find F(i+1) = F(i - 1) + F(i)
    ADD AX, [BX]         
              
    ; Stores F(i+1) in DX
    MOV DX, AX  
    
    ; Updates AX to F(i)
    MOV AX, [BX]   
    
    ; Increases BX to the appropiate memory location. 
    INC BX
    INC BX
    INC BX
    
    ; Stores F(i + 1) in the memory location that BX points to. 
    MOV [BX], DX
                        
    LOOP FIBONACCI 

    
RET