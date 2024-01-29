        .section .data
input_string:   .asciz "Hello world!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        .section .text
        .globl _start

_start:
        # load address of ascii string into t0
        la t0, input_string

first_process:
        # load byte from memory address stored in t0 into t1
        lb t1, 0(t0)

        # end program if NUL character (end of ascii string)
        beq t1, x0, end_program

        #if less than 97 or greater than 122, branch to second process
        # (if not a lowercase ascii character, dont change it)
        li t2, 97
        blt t1, t2, second_process
        li t2, 122
        bgt t1, t2, second_process

        # if between 97 an 122, subtract 32
        # (if lowercase ascii character, make uppercase)
        addi t1, t1, -32

        # begin second process
        j second_process

second_process:
        # store the result back into memory at original address
        sb t1, 0(t0)

        # increment address in t0 to start with next byte
        addi t0, t0, 1

        # loop on first process
        j first_process

end_program:
        # jump here when you're done
        j end_program
