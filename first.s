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
	   VMOV.F32 S14,R1; Y1
	   BL __SPIRAL1;
	   VMOV.F32 S17,R0; X2
	   VMOV.F32 S18,R1; Y2
	   
stop B stop	  
   ENDFUNC
   END
 
 