/*** asmFmax.s   ***/
#include <xc.h>
.syntax unified

@ Declare the following to be in data memory
.data  

@ Define the globals so that the C code can access them

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
@ use these locations to store f1 values
f1: .word 0
sb1: .word 0
biasedExp1: .word 0  /* the unmodified 8b exp value extracted from the float */
exp1: .word 0
mant1: .word 0
 
@ use these locations to store f2 values
f2: .word 0
sb2: .word 0
exp2: .word 0
biasedExp2: .word 0  /* the unmodified 8b exp value extracted from the float */
mant2: .word 0
 
@ use these locations to store fMax values
fMax: .word 0
signBitMax: .word 0
biasedExpMax: .word 0
expMax: .word 0
mantMax: .word 0

.global nanValue 
.type nanValue,%gnu_unique_object
nanValue: .word 0x7FFFFFFF            

@ Tell the assembler that what follows is in instruction memory    
.text
.align

/********************************************************************
 function name: initVariables
    input:  none
    output: initializes all f1*, f2*, and *Max varibales to 0
********************************************************************/
.global initVariables
 .type initVariables,%function
initVariables:
    /* YOUR initVariables CODE BELOW THIS LINE! Don't forget to push and pop! */
    
    /* Save callee-saved registers and link register*/
    push {r4-r11,LR}
    
    ldr r4, =0  @ initialize r4 as zero register
    
    /* initialize f1* variables to zero */
    ldr r5, =fMax
    str r4, [r5]
    ldr r6, =sb1
    str r4, [r6]
    ldr r7, =biasedExp1
    str r4, [r7]
    ldr r8, =exp1
    str r4, [r8]
    ldr r9, =mant1
    str r10, [r9]
    
    /* initialize f2* variables to zero */
    ldr r5, =f2
    str r4, [r5]
    ldr r6, =sb2
    str r4, [r6]
    ldr r7, =biasedExp2
    str r4, [r7]
    ldr r8, =exp2
    str r4, [r8]
    ldr r9, =mant2
    str r10, [r9]
    
    /* initialize fMax variables to zero */
    ldr r5, =fMax
    str r4, [r5]
    ldr r6, =signBitMax
    str r4, [r6]
    ldr r7, =biasedExpMax
    str r4, [r7]
    ldr r8, =expMax
    str r4, [r8]
    ldr r9, =mantMax
    str r10, [r9]
    
    /* Restore callee-saved registers and link register */
    pop {r4-r11,LR} 
    
    /*return to address pointed to by the link register */
    bx lr 
    
    /* YOUR initVariables CODE ABOVE THIS LINE! Don't forget to push and pop! */

    
/********************************************************************
 function name: getSignBit
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store sign bit (bit 31).
                Store a 1 if the sign bit is negative,
                Store a 0 if the sign bit is positive
                use sb1, sb2, or signBitMax for storage, as needed
    output: [r1]: mem location given by r1 contains the sign bit
********************************************************************/
.global getSignBit
.type getSignBit,%function
getSignBit:
    /* YOUR getSignBit CODE BELOW THIS LINE! Don't forget to push and pop! */
    
    /* Save callee-saved registers and link register*/
    push {r4-r11,LR}
    
    /* Load the 32-bit float from the address in r0 into r4 */
    ldr r4, [r0]  
    
    /* Load the mask for the sign bit into r3 */
    ldr r3, =0x80000000
    
    /* Perform bitwise AND with floating point number & sign bit mask & update flags */
    tst r4, r3  
    
    ldreq r4, =0      @ If zero flag is set (MSB of r4 is 0), set r4 to 0
    ldrne r4, =1      @ If zero flag is clear (MSB of r4 is 1), set r4 to 1

    str r4, [r1]      @ Store the result to the address in r1
   
    /* Restore callee-saved registers and link register */
    pop {r4-r11,LR} 
    
    /*return to address pointed to by the link register */
    bx lr 
    
   /* YOUR getSignBit CODE ABOVE THIS LINE! Don't forget to push and pop! */
    

    
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
                  and UNBIASED exponent bits, in the lower 8b of the mem 
                  location
********************************************************************/
.global getExponent
.type getExponent,%function
getExponent:
    /* YOUR getExponent CODE BELOW THIS LINE! Don't forget to push and pop! */
    /* Save callee-saved registers and link register */
    push {r4-r11,LR}
    
    /* Load the 32-bit float from the address in r0 into r4 */
    ldr r4, [r0]
    
    /* Initialize r5 as a mask to test exponent bits (all 8 bits from bit 23 to bit 30 are set to 1)*/
    ldr r5, =0x7F800000
    
    /* Isolate the exponent bits in r4 by using an AND operation */
    and r4, r4, r5
    
    /* Shift the exponent bits to the LSB's of the register for storage */
    lsr r4, r4, 23
     
    /* Store the biased exponent to the appropriate return address in r1 */
    str r4, [r1]
    
    /* Calculate unbiased exponent */
    ldr r6, =127   @ initializes r6 to 127 to calculate unbiased exponent 
    sub r4, r4, r6 @ unbiased exponent == biased exponent-127
    
    /* Store the unbiased exponent to the appropriate return address in r2 */
    str r4, [r2]
    
    /* Restore callee-saved registers and link register */
    pop {r4-r11,LR}
    
    /* Return to address pointed to by the link register */
    bx lr
    
    /* YOUR getExponent CODE ABOVE THIS LINE! Don't forget to push and pop! */
   

    
/********************************************************************
 function name: getMantissa
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store unpacked bits 0-22 (mantissa) 
                of 32b float. 
                Use mant1, mant2, or mantMax for storage, as needed
    output: [r1]: mem location given by r1 contains the unpacked
                  mantissa bits
********************************************************************/
.global getMantissa
.type getMantissa,%function
getMantissa:
    /* YOUR getMantissa CODE BELOW THIS LINE! Don't forget to push and pop! */
    
    /* Save callee-saved registers and link register */
    push {r4-r11,LR}
    
    /* Load the 32-bit float from the address in r0 into r4 */
    ldr r4, [r0]
    
    /* Initialize r5 as a mask to isolate mantissa bits (all 23 bits from bit 0 to bit 22 are set to 1) */
    ldr r5, =0x7FFFFF
    
    /* Isolate the mantissa bits in r4 by using an AND operation */
    and r4, r4, r5
    
    /* Store the mantissa to the address in r1 */
    str r2, [r1]
    
   /* Restore callee-saved registers and link register */
    pop {r4-r11,LR}
    
    /* Return to address pointed to by the link register */
    bx lr 
    
    /* YOUR getMantissa CODE ABOVE THIS LINE! Don't forget to push and pop! */
   


    
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
     
     SEE LECTURE SLIDES FOR EXACT REQUIREMENTS on when and how to adjust values!


********************************************************************/    
.global asmFmax
.type asmFmax,%function
asmFmax:   

    /* YOUR asmFmax CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    
    /* Save callee-saved registers and link register */
    push {r4-r11,LR}
    
    /* First, let's compare the sign bits. */
    ldr r6, =sb1
    bl getSignBit
    ldr r7, [r6]
    ldr r8, =sb2
    bl getSignBit
    ldr r9, [r8]
    
    cmp r7, r9
    beq .SameSign  /* If both numbers have the same sign bit, move to next comparison */
    
    /* If signs are different, the one with the sign bit 0 is greater */
    teq r7, #0
    moveq r6, r4
    b .StoreAndExit
    teq r9, #0
    moveq r6, r5
    b .StoreAndExit
    
.SameSign:
    /* Compare exponents next */
    ldr r6, =biasedExp1
    ldr r8, =exp1
    bl getExponent
    ldr r7, [r6]
    ldr r9, [r8]
    
    ldr r6, =biasedExp2
    ldr r8, =exp2
    bl getExponent
    ldr r10, [r6]
    ldr r11, [r8]
    
    cmp r9, r11
    beq .SameExponent  /* If both numbers have the same exponent, move to next comparison */
    
    /* Whichever has larger exponent is greater */
    cmp r9, r11
    movgt r6, r4
    movle r6, r5
    b .StoreAndExit
    
.SameExponent:
    /* Lastly, compare mantissas */
    ldr r6, =mant1
    bl getMantissa
    ldr r7, [r6]
    ldr r8, =mant2
    bl getMantissa
    ldr r9, [r8]
    
    cmp r7, r9
    /* Whichever has larger mantissa is greater, if they are equal, it doesn't matter */
    movge r6, r4
    movlt r6, r5
    
.StoreAndExit:
    /* Storing maximum value and updating other global variables accordingly */
    ldr r7, =fMax
    str r6, [r7]
    
    /* Unpack the larger number */
    ldr r6, =signBitMax
    bl getSignBit
    ldr r7, =biasedExpMax
    ldr r8, =expMax
    bl getExponent
    ldr r9, =mantMax
    bl getMantissa
    /* Restore callee-saved registers and link register */
    pop {r4-r11,LR}
    
    /* Return to address pointed to by the link register */
    bx lr 
    
    /* YOUR asmFmax CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




