// main.s - Paso 0: Leer un archivo con extensión propia en ARM64 Linux
.global _start

.data
err_msg: .asciz "Uso: ./micompilador <archivo.mio>\n"
err_len = . - err_msg

.bss
.lcomm buffer, 1024  // Búfer de 1KB en memoria RAM para almacenar el código fuente

.text
_start:
    // 1. Comprobar los argumentos pasados por la terminal (argc y argv)
    ldr x0, [sp]         // x0 = argc (número de argumentos)
    cmp x0, #2           // ¿Pasamos al menos el archivo fuente (argv[1])?
    b.lt error_args      // Si argc < 2, saltamos a error

    // 2. Obtener la ruta del archivo (argv[1])
    // En la pila de ARM64 Linux: [sp] = argc, [sp + 8] = argv[0], [sp + 16] = argv[1]
    ldr x1, [sp, #16]    // x1 = puntero a la cadena de texto con el nombre del archivo

    // 3. Abrir el archivo mediante la syscall openat (número 56 en ARM64)
    // x0 = -100 (AT_FDCWD, indica el directorio actual)
    // x1 = puntero al nombre del archivo (ya cargado)
    // x2 = 0 (O_RDONLY, modo solo lectura)
    mov x0, #-100        // AT_FDCWD
    mov x2, #0           // O_RDONLY
    mov x8, #56          // Syscall openat
    svc #0               // Llamada al kernel de Linux

    // Si x0 es menor que 0, hubo un error al abrir el archivo
    cmp x0, #0
    b.lt error_args
    
    mov x19, x0          // Guardamos el Descriptor de Archivo (fd) en el registro x19

    // 4. Leer el contenido del archivo con la syscall read (número 63)
    // x0 = descriptor de archivo (fd)
    // x1 = dirección de memoria del búfer
    // x2 = tamaño máximo a leer (1024 bytes)
    mov x0, x19
    ldr x1, =buffer      // Cargamos la dirección del búfer definido en .bss
    mov x2, #1024
    mov x8, #63          // Syscall read
    svc #0

    mov x20, x0          // Guardamos cuántos bytes leímos realmente en x20

    // 5. Imprimir por pantalla lo que leímos para comprobar que funciona (syscall write = 64)
    // x0 = 1 (stdout - salida estándar de la terminal)
    // x1 = puntero al búfer
    // x2 = número de bytes leídos
    mov x0, #1           
    ldr x1, =buffer
    mov x2, x20          
    mov x8, #64          // Syscall write
    svc #0

    // 6. Cerrar el archivo con la syscall close (número 57)
    mov x0, x19
    mov x8, #57
    svc #0

    // 7. Salir del programa limpiamente con sys_exit (número 93)
    mov x0, #0           // Código de salida 0 (éxito)
    mov x8, #93          // Syscall exit
    svc #0

error_args:
    // Si faltan argumentos o falla la apertura, imprimimos el mensaje de uso
    mov x0, #1           // stdout
    ldr x1, =err_msg
    ldr x2, =err_len
    mov x8, #64          // write
    svc #0

    // Salir con error 1
    mov x0, #1
    mov x8, #93
    svc #0
