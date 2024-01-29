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


end_program:
        # jump here when you're done
        j end_program
