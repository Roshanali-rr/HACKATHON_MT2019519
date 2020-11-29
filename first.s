  AREA     factorial, CODE, READONLY
     EXPORT __main
     IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p
	 IMPORT __SPIRAL1
     IMPORT __SPIRAL		 
     ENTRY 
__main  FUNCTION
   	
       BL __SPIRAL;
	   VMOV.F32 S13,R0; X1
	   VMOV.F32 S14,R1; Y1 ;
	   VMOV.F32 S11,S13; X1
	   VMOV.F32 S12,S14; Y1
	   BL __SPIRAL1;
	  VMOV.F32 S1,S17; X2
	   VMOV.F32 S2,S18; Y2
	   
	    VSUB.F32 S3,S2,S12 ; y2-y1
        VSUB.F32 S4,S1,S11 ;   x2-x1
		VDIV.F32 S5,S3,S4 ; SLOPE m
		VMOV.F32 S6,S11 ; S6=x1
		VLDR.F32 S9,=1  ;
LOOPSL  VSUB.F32 S7,S6,S11  ;x-x1
		VMUL.F32 S7,S5 ; m(x-x1)
		VADD.F32 S8,S7,S12 ;y=m(x-x1)+y1
		VMOV.F32 S7,S6 
		VCVT.S32.F32 S7,S7,#16  ; S7=x
		VCVT.S32.F32 S8,S8,#16  ;S8=y
		VMOV.F32 R0,S7   ;
		VMOV.F32 R1,S8  ; 
		BL  printMsg2p
		VADD.F32 S6,S9  ; x1+1
		VCMP.F32 S6 ,S1  ;
		VMRS.F32		APSR_nzcv, FPSCR
        BLT LOOPSL
	   
stop B stop	  
   ENDFUNC
   END
 
 
