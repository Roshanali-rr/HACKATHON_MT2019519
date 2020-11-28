  AREA     factorial, CODE, READONLY
     EXPORT __main
     IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p
     ENTRY 
__main  FUNCTION	
	
        MOV R4, #3610 ;	no of iterations
		VLDR.F32 S25, =360 ;
		VLDR.F32 S26, =3.1415926;
	   VDIV.F32     S23,S26,S25 ; S23 = pi/360;
	   MOV R6, #1 ;  ;THETA
LOOPC	ADD R6,#1  ; THETA +1
		CMP R4,R6  ; 
		BEQ STOP
        VMOV.F32 S24,R6; THETA
        VCVT.F32.U32 S24,S24 ; converts floating point to integer
        VMUL.F32  S22,S24,S23  ;S29 (t)= i*pi/360
        VMOV.F32 R0,S22; 
		
		B LOOPCOS
LOOPR   VMOV.F32 S21,R0 ; S10 = cost
		VCVT.S32.F32 S21,S21,#16 ; converting floating point in x to 16 bit fixed point
		VMOV.F32 R0,S21 ; S10 = cost
		BL printMsg2p
		B LOOPC
	
LOOPCOS   PUSH  {R4-R12,LR}	
       VMOV.F32	S20,R0 ;X
	   VLDR.F32	S9, = 2;
	   MOV	R3,#100 ; loop FOR 100 ITERATIONS
           VLDR.F32	S10, = 3.1415926;
	   VMOV.F32     S6,S10;
	   VMUL.F32	S6,S6,S9 ; s6 = 2pi

COMPARE VCMP.F32	S20,S6  ; compare x, 2pi
	   VMRS.F32	APSR_nzcv, FPSCR ;
	   BGE	LOOP1  ; 

	   VMUL.F32	S1,S20,S20 ;S1= X2
	   VNMUL.F32	S2,S20,S20 ;S2=-X2
	   VLDR.F32	S3, = 2	;
	   VLDR.F32	S5,=1 ; PREVIOUS ITERATION VALUES
	   VLDR.F32	S7, = 1;
	   B LOOP

LOOP1 VSUB.F32 S20,S6    ; x-2pi 
	  B	 COMPARE	

LOOP       SUB			R3,#1
	   CMP			R3,#0	; ITERATE FOR 100 TIMES
	   BEQ 			LOOP
           VDIV.F32		S4,S2,S9 ; -X2/2! X4/4!...
           VMOV.F32		S8,S5 	; 1, 1-X2/2! STORES PREVIOUS ITERATION VALUES 
	   VADD.F32		S5,S4   ; 1-X2/2!
	   VCMP.F32		S8,S5	; COMPARE PREVIOUS ITERATION VALYE
	   VMRS.F32		APSR_nzcv, FPSCR ;
	   BEQ			MOV1  	; 
							
	   VADD.F32		S3,S7 	; 2+1=3
	   VMUL.F32		S9,S3	; 3*2=6=3!
	   VADD.F32		S3,S7 	; S+1=4
	   VMUL.F32		S9,S3	; 3!*4=4!
	   VNMUL.F32	S2,S1 	;-(X2*-X2) = X4
	   B LOOP;
	   
MOV1   VMOV.F32	R0,S5
       POP {R4-R12,LR}
       B LOOPR
	   
STOP    B STOP 	   
	 	
     ENDFUNC
	 END
 
 