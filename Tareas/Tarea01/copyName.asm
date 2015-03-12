ORG 100H
                
MOV [200H], 'G' 
MOV [201H], 'U'
MOV [202H], 'A'
MOV [203H], 'L'
MOV [204H], 'B'
MOV [205H], 'E'
MOV [206H], 'R'
MOV [207H], 'T'
MOV [208H], 'O'
MOV [209H], ' '
MOV [20AH], 'C'
MOV [20BH], 'A'
MOV [20CH], 'S'
MOV [20DH], 'A'
MOV [20EH], 'S'
MOV [20FH], ' '
MOV [210H], 'M'
MOV [211H], 'E'
MOV [212H], 'D'
MOV [213H], 'I'
MOV [214H], 'N'
MOV [215H], 'A'
MOV [216H], ' '

MOV CX, 115
MOV SI, 200H
MOV DI, 217H
REP MOVSB

RET