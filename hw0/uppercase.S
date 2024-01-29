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

        # load 0 into register a1
        la, a1, x0
        
        first_process:
                # put current character address into a5
                add a5, a0, a1

                # load value of a5 into a6
                la a6, a5

                # end program if value was NUL
                beq x0, a6, end_program
                
                # load immediates
                li a2, 96
                li a3, 213
                li a4, 32

                # if value less than 213
                blt a6, a3, lower

                lower:
                        # if value greater than 96
                        bge a6, a2, case

                case:
                        # subtract value by 32
                        sub a6, a6, a4

                        # load value into memory at address of character
                        la 0x2000+a1, a6
        
        # increment a1
        addi a1, a1, 1
        j first_process




        
end_program:
        # jump here when you're done
        j end_program

