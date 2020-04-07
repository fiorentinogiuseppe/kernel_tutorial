# Tutorial for kernel development on the x86 architecture
* Minimal example
## GCC Cross-Compiler
* The first thing we need to do is to build ourselves a cross-compiler toolchain to let us compile and link code for the x86.
* $HOME/opt/cross/bin/$TARGET-gcc --version

#  Compiling and linking
We'll be compiling the code we've just written into object files
## Compilling
To compile our code, we'll need to run the following commands:
`
i686-elf-gcc -std=gnu99 -ffreestanding -g -c my_start.s -o my_start.o
i686-elf-gcc -std=gnu99 -ffreestanding -g -c my_kernel.c -o my_kernel.o
`
This will create two object files named start.o and kernel.o ready for linking.

### There are several parts to the above command
* -std=gnu99 tells the compiler to adhere to the C99 GNU standard. This gives us all of the abilities of C99, plus a bunch of useful extra things that the GNU developers added in for us.
* -ffreestanding tells the compiler to generate free-standing code (i.e: does not rely on an existing operating system to run).
* -g tells the compiler to add debugging symbols to the compiled code. As the kernel grows, it'll be increasingly useful to have a good way of debugging problems. It's best to start early.
* -c tells the compiler to generate just object files rather than compiled and linked executables.


## Linking
`
i686-elf-gcc -ffreestanding -nostdlib -g -T my_linker.ld my_start.o my_kernel.o -o mykernel.elf -lgcc
`
### There are several parts to the above command
* -nostdlib is used to specify that we aren't linking against a C standard library. This should be obvious, since we're running freestanding.
* -T <link-script> is used to specify our linker script, 'linker.ld'.
* -lgcc tells the linker to link against libgcc which the the built-in platform-independent library that gcc provides for us to deal with simple code that GCC can implicitly generate (i.e: moving and manipulating data, low-level maths operations, etc.)

#  Running The Kernel With QEMU
* After all that, the linker command should have produced a file named mykernel.elf. This is our kernel image.
* To run your kernel with QEMU, you can use the following command
`
qemu-system-i386 -kernel mykernel.elf
`

#  Running The Kernel With GRUB And Real Hardware  
Doing...

## Reference
> - https://wiki.osdev.org/GCC_Cross-Compiler#Downloading_the_Source_Code
> - https://wiki.osdev.org/User:Zesterer/Bare_Bones
