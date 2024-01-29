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
        # Load the address of the input string into a0
        la a0, input_string
        j first_process
        
first_process:
        # put current character address into t3
        lw t3, 0(a0)

        # end program if value was NUL
        beq x0, t3, end_program
        
        # load immediates
        li t4, 97
        li t5, 213
        li t6, 32

        # if value less than 213
        blt t3, t5, upper

        j increment

increment:
        #increment memory address
        add a0, a0, 1
        j first_process

upper:
        # if value greater than/ equal 97
        bge t3, t4, lower
        j increment

lower:
        # subtract value by 32
        sub t3, t3, t6
        # load value into memory at original address of character
        la a0, t3
        j increment
        

end_program:
        # jump here when you're done
        j end_program
