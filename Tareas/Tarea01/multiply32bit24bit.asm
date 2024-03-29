;;; REALICE LA MULTIPLICACION SIGUIENTE: C3A CBC4H * 32 FDE5H
;;; CONSIDERE QUE LA MULTIPLICACION ES GENERICA:
;;; PRIMER NUMERO: 32 BITS.
;;; SEGUNDO NUMERO: 24 BITS. 
	
;;; Starts a .COM file. 
ORG 100H

;;; Do the lower bit multiplication:
MOV AX, 0CBC4H
MOV BX, 0FDE5H
MUL BX

;;; Store lower four bits in SI
MOV SI, AX
;;; Store multiplication carry in DI
MOV DI, DX

;;; MAKE SURE CARRY FLAG IS ZERO.
CLC
	
;;; MULTIPLY HIGHER 4 BITS OF FIRST NUMBER,
;;; TIMES THE LOWER 4 BITS OF SECOND NUMBER.
MOV AX, 0C3AH
MUL BX

;;; MOVE CARRY OF SECOND MULTIPLICATION TO BP
MOV BP, DX
	
;;; ADD CARRY OF FIRST MULTIPLICATION TO
;;; FOUR LOWER BITS OF SECOND MULTIPLICATION.
;;; STORE RESULT IN DI. 
ADD DI, AX
	
	
;;; ADD ADDITION CARRY TO CARRY OF SECOND MULTIPLICATION
ADC BP, 0000H
	
;;; MOVE CARRY OF ADDITION TO SP 
MOV SP, 0
ADC SP, 0


	
;;; DO THE HIGHER BIT MULTIPLICATION
MOV AX, 032H
MOV BX, 0CBC4H	
MUL BX

;;; MOVE THIRD MULTIPLICATION CARRY TO SP
ADD BP, DX

;;; ADD ADDITION CARRY TO SP
ADC SP, 0

;;; ADD LOWER 4 BITS TO DI
ADD DI, AX
	
;;; ADD ADDITION CARRY TO BP
ADC BP, 0

;;; ADD ADDITION CARRY TO SP
ADC SP, 0


;;; PERFORM LAST MULTIPLICATION   
MOV AX, 032H
MOV BX, 0C3AH
MUL BX

;;; ADD MULTIPLICATION CARRY TO SP
ADD SP, DX

;;; ADD FOURTH MULTIPLICATION TO BP
ADD BP, AX

;;; ADD ADDITION CARRY TO SP
ADC SP, 0
