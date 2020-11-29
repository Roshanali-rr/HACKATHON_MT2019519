  AREA     factorial, CODE, READONLY
     EXPORT __main
     IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p
     ENTRY 
__main  FUNCTION	
        MOV R4, #3610 ;	no of iterations
		MOV R6, #1 ;  ;i
		VLDR.F32 S28, =360 
	    VLDR.F32 S29, =3.1415926; 
	    VLDR.F32 S14, =5 ; b=5
	    VDIV.F32     S27,S29,S28 ; pi/360;
	   
	   
LOOPC	ADD R6,#1  ; theta
		CMP R4,R6  ; theta increment by 1 degree to 5 times
		BEQ stop1          
        VMOV.F32 S25,R6; s25=theta
        VCVT.F32.U32 S25,S25 ; 
        VMUL.F32  S26,S25,S27  ;S26 = theta * pi/360
        VMOV.F32 R0,S26; R0=X FOR SINX AND COSX
		B LOOPCOS
LOOPR   VMOV.F32 S21,R0 ; COSX
        VMOV.F32 R0,S26;		
		B LOOPSINE
LOOPR1  VMOV.F32 S22,R0 ; SINX
        VMUL.F32  S13,S14,S26 ; R=B*T
		VMUL.F32 S23,S13,S21; X=R*COSX
        VMUL.F32 S24,S13,S22; Y=R*SINX
		VCVT.S32.F32 S23,S23,#16 ; 
		VCVT.S32.F32 S24,S24,#16 ;  
		VMOV.F32 R0,S23  ; 
		VMOV.F32 R1,S24   ; 
		BL  printMsg2p
		B LOOPC 
		
stop1 B stop

LOOPCOS PUSH  {R4-R12,LR}	
       VMOV.F32	S20,R0 ;X
	   VLDR.F32	S9, = 2;
	   MOV	R3,#100 ; loop FOR 100 ITERATIONS
       VLDR.F32	S10, = 3.1415926;
	   VMOV.F32     S6,S10;
	   VMUL.F32	S6,S6,S9 ; s6 = 2PI

COMPARE VCMP.F32	S20,S6  ; compare X ,2PI
	   VMRS.F32	APSR_nzcv, FPSCR ;
	   BGE	LOOP1  ; 

	   VMUL.F32	S1,S20,S20 ;S1= X2
	   VNMUL.F32	S2,S20,S20 ;S2=-X2
	   VLDR.F32	S3, = 2	;
	   VLDR.F32	S5,=1 ; PREVIOUS ITERATION VALUES
	   VLDR.F32	S7, = 1;
	   B LOOP

LOOP1 VSUB.F32 S20,S6    ; X-2PI
	  B	 COMPARE	

LOOP   SUB			R3,#1
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
	   
LOOPSINE PUSH         {R4-R12,LR} 	
    VMOV.F32	S20,R0 ;X
	VLDR.F32	S9, = 2;
	MOV	R3,#100 ; loop FOR 100 ITERATIONS
    VLDR.F32	S10, = 3.1415926;
	VMOV.F32     S6,S10;
	VMUL.F32	S6,S6,S9 ; 2PI

COMPARE1 VCMP.F32	S20,S6  ; COMPARE X,2PI
	   VMRS.F32	APSR_nzcv, FPSCR ;
	   BGE	LOOP12  ; 

	   VMUL.F32		S1,S20,S20 ;X2
	   VNMUL.F32	S2,S20,S20 ;-X2
	   VMUL.F32     S2,S2,S20 ; -X3
	   VMOV.F32		S30,S20    ;The Value of sinx after each iterarion is stored in S30
	   VLDR.F32		S5, = 1;
	   VLDR.F32		S3, = 3	;
	   B LOOP13

LOOP12 VSUB.F32 S20,S6    ; X-2PI
	  B	 COMPARE1

LOOP13   SUB			R5,#1
	   CMP			R5,#0	;N=100 ITERATIONS
	   BEQ 			MOV2	;
       VMUL.F32     S9,S9,S3 ; 3!,5!..
       VDIV.F32		S4,S2,S9 ; X3/3!,X5/5!
	   VMOV.F32		S8,S30 	; STORE PREVIOUS VALUE X, X3/3!,..
	   VADD.F32		S30,S30,S4   ; X-X3/3!
	   VCMP.F32		S8,S30	; Compare with previous iteration value
	   VMRS.F32		APSR_nzcv, FPSCR ;
	   BEQ			MOV2 ;  	
							
	   VADD.F32		S3,S3,S5 	; 3+1=4
	   VMUL.F32		S9,S9,S3	; 4*3!=4!
	   VADD.F32		S3,S3,S5 	; 4+1=5
	   VNMUL.F32	S2,S2,S1 	; (-X3*X2)=X5
	   B LOOP13
		
MOV2   VMOV.F32		R0,S30
	   POP          {R4-R12,LR}
	   B LOOPR1  

stop B stop 
   ENDFUNC
   END
 
 
