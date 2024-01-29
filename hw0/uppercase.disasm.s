
uppercase.bin:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <_start>:
   10074:	ffff2297          	auipc	t0,0xffff2
   10078:	f8c28293          	addi	t0,t0,-116 # 2000 <__DATA_BEGIN__>

0001007c <first_process>:
   1007c:	00028303          	lb	t1,0(t0)
   10080:	02030463          	beqz	t1,100a8 <end_program>
   10084:	06100393          	li	t2,97
   10088:	00734a63          	blt	t1,t2,1009c <second_process>
   1008c:	07a00393          	li	t2,122
   10090:	0063c663          	blt	t2,t1,1009c <second_process>
   10094:	fe030313          	addi	t1,t1,-32
   10098:	0040006f          	j	1009c <second_process>

0001009c <second_process>:
   1009c:	00628023          	sb	t1,0(t0)
   100a0:	00128293          	addi	t0,t0,1
   100a4:	fd9ff06f          	j	1007c <first_process>

000100a8 <end_program>:
   100a8:	0000006f          	j	100a8 <end_program>
