//
// Payload launcher stub.
//

.globl _start

.section ".text"
_start:

    // First, we'll need to move ourselves _out_ of the target area.
    // We'll copy down into the start of the IRAM.
    ldr r0, =post_relocation
    ldr r1, =START_OF_IRAM
    ldr r2, =intermezzo_end
    sub r2, r2, r0
    bl  copy

    // Jump to the start of RAM, which should now contain the post-relocation code.
    ldr r0, =START_OF_IRAM
    bx  r0


.align 4
post_relocation:

    // Next, we'll copy our payload down to the appropriate relocaiton address.
    ldr r0, =LOAD_BLOCK_START
    ldr r1, =RELOCATION_TARGET
    ldr r2, =LOAD_BLOCK_LENGTH
    bl  copy

    // Finally, jump into the relocated target.
    ldr r0, =RELOCATION_TARGET
    bx r0


//
// Simple block copy.
//   r0 = source address
//   r1 = destination address
//   r2 = length in bytes
// Destroys r3.
//
copy:

    // Copy the word...
    ldr r3, [r0], #4
    str r3, [r1], #4

    // And continue while we have words left to copy.
    subs r2, r2, #4
    bne copy

    // Once we're done, return.
    bx lr

