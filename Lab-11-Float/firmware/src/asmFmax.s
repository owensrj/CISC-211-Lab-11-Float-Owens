/*** asmFmax.s   ***/

#include <xc.h>

// Declare the following to be in data memory
.data  

// Define the globals so that the C code can access them

.global f1,f2,fMax,signBitMax,expMax,mantMax
.type f1,%gnu_unique_object
.type f2,%gnu_unique_object
.type fMax,%gnu_unique_object
.type signBitMax,%gnu_unique_object
.type expMax,%gnu_unique_object
.type mantMax,%gnu_unique_object

.global sb1,sb2,biasedExp1,biasedExp2,exp1,exp2,mant1,mant2
.type sb1,%gnu_unique_object
.type sb2,%gnu_unique_object
.type biasedExp1,%gnu_unique_object
.type biasedExp2,%gnu_unique_object
.type exp1,%gnu_unique_object
.type exp2,%gnu_unique_object
.type mant1,%gnu_unique_object
.type mant2,%gnu_unique_object
 
.align
# use these locations to store f1 values
f1: .word 0
sb1: .word 0
biasedExp1: .word 0  /* the unmodified 8b exp value extracted from the float */
exp1: .word 0
mant1: .word 0
 
# use these locations to store f2 values
f2: .word 0
sb2: .word 0
exp2: .word 0
biasedExp2: .word 0  /* the unmodified 8b exp value extracted from the float */
mant2: .word 0
 
# use these locations to store fMax values
fMax: .word 0
signBitMax: .word 0
biasedExpMax: .word 0
expMax: .word 0
mantMax: .word 0

.global nanValue 
.type nanValue,%gnu_unique_object
nanValue: .word 0x7FFFFFFF            

# Tell the assembler that what follows is in instruction memory    
.text
.align

/* VB Comment: This next directive is required!
// It allows the assembler to use both ARM 16b
// and 32b instructions together. Without this
// directive, the assembler will be limited to generating
// 16b op-codes, and will give errors when specifying
// arguments to instructions that will only work for
// their 32b versions. Want proof? Remove this directive
// and try to do a "push {r4-r11}" instruction. The
// assembler will generate an error. The 16b version
// of the "push" instruction
// can only deal with registers r0-r7, so specifying
// a register outside that range causes the assembler
// to fail.
*/
 
.syntax unified

/********************************************************************
 function name: getSignBit
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store sign bit (bit 31).
                Store a 1 if the sign bit is negative,
                Store a 0 if the sign bit is positive
                use sb1, sb2, or signBitMax for storage, as needed
    output: [r1]: mem location given by r1 contains the sign bit
********************************************************************/
.type getSignBit,%function
getSignBit:
    /* YOUR getSignBit CODE BELOW THIS LINE! Don't forget to push and pop! */

    /* YOUR getSignBit CODE ABOVE THIS LINE! Don't forget to push and pop! */
    
MOV pc,lr  /* getSignBit return to caller */
    
/********************************************************************
 function name: getExponent
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store BIASED 
                bits 23-30 (exponent) 
                BIASED means the unpacked value (range 0-255)
                use exp1, exp2, or expMax for storage, as needed
            r2: address of mem to store unpacked and UNBIASED 
                bits 23-30 (exponent) 
                UNBIASED means the unpacked value - 127
                use exp1, exp2, or expMax for storage, as needed
    output: [r1]: mem location given by r1 contains the unpacked
                  original (biased) exponent bits, in the lower 8b of the mem 
                  location
            [r2]: mem location given by r2 contains the unpacked
                  and UNNBIASED exponent bits, in the lower 8b of the mem 
                  location
********************************************************************/
.type getExponent,%function
getExponent:
    /* YOUR getExponent CODE BELOW THIS LINE! Don't forget to push and pop! */
    
    /* YOUR getExponent CODE ABOVE THIS LINE! Don't forget to push and pop! */
   
MOV pc,lr  /*  getExponent return to caller */
    
/********************************************************************
 function name: getMantissa
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store unpacked bits 0-22 (mantissa) 
                of 32b float. 
                Use mant1, mant2, or mantMax for storage, as needed
    output: [r1]: mem location given by r1 contains the unpacked
                  mantissa bits
********************************************************************/
.type getMantissa,%function
getMantissa:
    /* YOUR getMantissa CODE BELOW THIS LINE! Don't forget to push and pop! */
    
    /* YOUR getMantissa CODE ABOVE THIS LINE! Don't forget to push and pop! */
   
MOV pc,lr  /*  getExponent return to caller */

    
/********************************************************************
function name: asmFmax
function description:
     max = asmFmax ( f1 , f2 )
     
where:
     f1, f2 are 32b floating point values passed in by the C caller
     max is the ADDRESS of fMax, where the greater of (f1,f2) must be stored
     
     if f1 equals f2, return either one
     notes:
        "greater than" means the most positive numeber.
        For example, -1 is greater than -200
     
     The function must also unpack the greater number and update the 
     following global variables prior to returning to the caller:
     
     signBitMax: 0 if the larger number is positive, otherwise 1
     expMax:     The UNBIASED exponent of the larger number
                 i.e. the BIASED exponent - 127
     mantMax:    the lower 23b unpacked from the larger number


********************************************************************/    
.global asmFmax
.type asmFmax,%function
asmFmax:   

    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
    /* Placeholder code: 
     * STUDENTS: Make sure to disable this code by changing the
     * .if statement from 0 to 1. Then scroll down and add your
     * own code between the comments below.
     */
.if 1    
    # just return r0 for now in the global
    LDR r2,=fMax
    STR r0,[r2]
    # now return the address of fMax
    LDR r0,=fMax
    /* Add a conditional here just to make sure assembler options
     * are correctly set up to auto-generate the IT instructions.
     * If the assembler complains, make sure the following option
     * is added to the compiler options line in XC32 project properties:
     *     -Wa,-mimplicit-it=always
     */
    CMP r0,r0 /* guarantee that they are equal */
    ADDNE r2,r2,r2 /* see if the assembler complains on this line */
.endif
    /* END: Placeholder code */

    /* YOUR asmFmax CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    
    
    /* YOUR asmFmax CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFmax return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




