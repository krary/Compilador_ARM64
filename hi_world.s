.global _start


.section .data
	mensaje: .ascii "HELLO WORLD\n"
	len = . - mensaje


.section .text
	_start:
		mov x0, #1    //FILEDESCRIPTOR
		ldr x1, =mensaje  //POINTER TO MESSAGE
		mov x2, len       //NUMBER BYTES
		mov x8, #64  //SYSCALL PRINT
		svc #0



		mov x0, #0
		mov x8, 93
		svc #0
		
		
