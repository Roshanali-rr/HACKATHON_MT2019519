  AREA     factorial, CODE, READONLY
     EXPORT __main
     IMPORT printMsg
	 IMPORT printMsg2p
	
     ENTRY 


__main  FUNCTION		
	
        MOV R4, #3610 ;	no of iterations
		VLDR.F32 S25, =360 ;
		VLDR.F32 S26, =3.1415926;
	   VDIV.F32     S23,S26,S25 ; S23 = pi/360;
	   MOV R6, #1 ;  ;THETA
LOOPC	ADD R6,#1  ; THETA +1
		CMP R4,R6  ; 
		BEQ stop
        VMOV.F32 S24,R6; THETA
        VCVT.F32.U32 S24,S24 ; converts floating point to integer
        VMUL.F32  S22,S24,S23  ;S29 (t)= i*pi/360
        VMOV.F32 R0,S22; 
		
		B LOOPSINE
LOOPR   VMOV.F32 S21,R0 ; S10 = cost
		VCVT.S32.F32 S21,S21,#16 ; converting floating point in x to 16 bit fixed point
		VMOV.F32 R0,S21 ; S10 = cost
		BL printMsg2p
		B LOOPC
	
LOOPSINE   PUSH         {R4-R12,LR} 	
    VMOV.F32	S20,R0 ;X
	VLDR.F32	S9, = 2;
	MOV	R5,#100 ; loop FOR 100 ITERATIONS
    VLDR.F32	S10, = 3.1415926;
	VMOV.F32     S6,S10;
	VMUL.F32	S6,S6,S9 ; s6 = 2pi

COMPARE VCMP.F32	S20,S6  ; compare x, 2pi
	   VMRS.F32	APSR_nzcv, FPSCR ;
	   BGE	LOOP1  ; 

	   VMUL.F32		S1,S20,S20 ;X2
	   VNMUL.F32	S2,S20,S20 ;-X2
	   VMUL.F32     S2,S2,S20 ; -X3
	   VMOV.F32		S30,S20    ;The Value of sinx after each iterarion is stored in S30
	   VLDR.F32		S5, = 1;
	   VLDR.F32		S3, = 3	;
	   B LOOP

LOOP1 VSUB.F32 S20,S6    ; x-2pi 
	  B	 COMPARE

LOOP   SUB			R5,#1
	   CMP			R5,#0	;N=100 ITERATIONS
	   BEQ 			MOV1	;
       VMUL.F32     S9,S9,S3 ; 3!,5!..
       VDIV.F32		S4,S2,S9 ; X3/3!,X5/5!
	   VMOV.F32		S8,S30 	; STORE PREVIOUS VALUE X, X3/3!,..
	   VADD.F32		S30,S30,S4   ; X-X3/3!
	   VCMP.F32		S8,S30	; Compare with previous iteration value
	   VMRS.F32		APSR_nzcv, FPSCR ;
	   BEQ			MOV1;  	
							
	   VADD.F32		S3,S3,S5 	; 3+1=4
	   VMUL.F32		S9,S9,S3	; 4*3!=4!
	   VADD.F32		S3,S3,S5 	; 4+1=5
	   VNMUL.F32	S2,S2,S1 	; (-X3*X2)=X5
	   B LOOP
		
MOV1   VMOV.F32		R0,S30
	   POP          {R4-R12,LR}
	   B LOOPR

stop B stop 
   ENDFUNC
   END
 
 
