# Compilador_ARM64
PARA COMPILAR Y EJECUTAR ESTE CODIGO EN ENTORNO ARCH64
as name_file.s -o name_file.o

as name_file.o -o name_file

./name_file

PARA COMPILAR CODIGO PURO EN ARM64 EN ENTORNO x86-64
aarch64-linux-gnu-gcc -nostdlib -static name_file.s name_file
./name_file



**********************************************************************
[ANTES DE ELLO DEBEMOS HABER INSTALADO QUEMU:]
sudo apt update
sudo apt install qemu-user qemu-user-binfmt
**********************************************************************
