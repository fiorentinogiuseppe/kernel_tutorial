# Tutorial para desenvolvimento de um kernel simples na arquitetura x86

Este projeto foi elaborado para que eu pudesse aprender um pouco mais sobre o desenvolvimento do kernel em uma arquitetura x86. Este projeto utiliza um conjunto de linguagens para desenvolver o kernel usando x86 assembly :heart_eyes:, C :heart: e o linker command language :cupid:. Diferente do [projeto de feriadão x86](https://github.com/fiorentinogiuseppe/x86_course) que utiliza apenas o x86 e é um projeto mais desenvolvido pois aceita input do usuário.

Este projeto tem como base o artigo do site
[OSDev.org](https://wiki.osdev.org/Main_Page) desenvolvido por [Bare Bones e evoluido por Zesterer](https://wiki.osdev.org/User:Zesterer/Bare_Bones). Irei me conter ao código pulando um pouco dos avisos e requisitos de conhecimento para desenvolver o projeto. Indico olhar o artigo original para ver este na íntegra o `warning`.

## GCC Cross-Compiler

A primeira coisa que é preciso fazer é instalar todas as ferramentas do `GCC Cross-Compiler` para nos permitir compilar e vincular o código para o x86. Indico seguir o [tutorial](https://wiki.osdev.org/GCC_Cross-Compiler) ou utilizar uma imagem docker do gcc cross-compiler i686-elf. ~Nunca usei, mas vi muita gente que desenvolveu~

##  O código

###  Freestanding (Autônomo)

O desenvolvimento de um código C em um SO hospedeiros nos da uma infinidade de interfaces disponíveis tudo com apenas algumas linhas de código e de forma simples e controlada. Contudo no desenvolvimento do `kernel` não temos esses auxílios fornecidos por um sistema operacional, pois dessa vez <b>SOMOS O SISTEMA OPERACIONAL</b>. No entanto temos acesso a alguns cabeçalhos úteis fornecidos pelo GCC de forma automática e o hardware do x86.

###  Estrutura do projeto

Todo os códigos necessários para o projeto estão no diretório [/src]() estes estão devidamente comentados em português para o melhor entendimento. Os arquivos são o seguinte

```
1. my_start.s
  Contém o código de montagem x86 que inicia o kernel e as configurações do x86.

2. my_kernel.c
  Este arquivo conterá a maioria do kernel, escrito em C.

3. my_linker.ld
  Este arquivo fornecerá ao compilador informações sobre como ele deve construir O executável do kernel, vinculando os arquivos anteriores.
```

##  Compilando e linkando


### Compilando
Para compilar nosso código os comandos são os seguintes:
```
$ i686-elf-gcc -std=gnu99 -ffreestanding -g -c my_start.s -o my_start.o

$ i686-elf-gcc -std=gnu99 -ffreestanding -g -c my_kernel.c -o my_kernel.o
```

:warning:

`Lembre-se de ter adicionado no seu arquivo .bashrc o comando que exporta o seu gcc cross-compiler para poder utilizar o comando i868-elf-gcc.`

:warning:

#### Explicação dos comandos acima
* -std=gnu99
  * Indica ao compilador para aderir ao padrão C99 GNU.
* -ffreestanding
  * Informa ao compilador para gerar código independente de um sistema operacional existente para ser executado.
* -g tells the compiler to add debugging symbols to the compiled code. As the kernel grows, it'll be increasingly useful to have a good way of debugging problems. It's best to start early.
* -c tells the compiler to generate just object files rather than compiled and linked executables.

O após termos rodado os comandos acima isso irá criar dois arquivos de objeto denominados my_start.o e my_kernel.o que serão linkados.

### Linkando
```
i686-elf-gcc -ffreestanding -nostdlib -g -T my_linker.ld my_start.o my_kernel.o -o mykernel.elf -lgcc
```
#### Explicação dos comandos acima
* -nostdlib
  * Especifica que não estamos vinculando a uma biblioteca padrão C.
* -T <link-script>
  * Especifica nosso linker script,  o `my_linker.ld`.
* -lgcc
  * Instrui ao linker para linkar à libgcc.

##  Executando o Kernel com QEMU

Depois de termos compilado e linkado teremos um arquivo chamado `my_kernel.elf`, que é a nossa imagem do kernel. Para executar seu kernel com o QEMU, você pode usar o seguinte comando:

```
qemu-system-i386 -kernel mykernel.elf
```


## Executando o kernel com GRUB
Para anexar seu kernel ao GRUB e testá-lo em hardware real, você precisará primeiro ter instalado o GRUB. Verifique a existência visualizando a versão do grub-mkrescue com o comandos

```
grub-mkrescue --version
```

Caso a saída seja a versão indica que você possui o grub instalado. Assim o próximo passo é criar uma árvore de diretórios para nossa compilação ISO do GRUB. Eu chamo de 'isoroot', como no tutorial inicial. Dentro desse diretório, tem que existir a seguinte árvore de arquivos

```
├── isoroot
│   └── boot
│       ├── grub
│       │   └── grub.cfg
│       └── mykernel.elf

```

E com isso no arquivo `grub.cfg` podemos por o seguinte:

```
menuentry "My Kernel" {
    multiboot /boot/mykernel.elf
    boot
}
```

E com este último comando comando produzir um ISO final no final:


```
grub-mkrescue isoroot/ -o mykernel.iso
```


Com isso poderemos executar nosso kernel em um hardware real ou utilizar no `virtualbox`.


#### Explicação dos comandos acima
* o isoroot/
  * pode ser qualquer diretório em que contenha nossos arquivos grub.cfg e mykernel.elf.
* -o mykernel.iso
  * mykernel.iso pode ser qualquer nome que desejar.

## Referências
> - https://wiki.osdev.org/User:Zesterer/Bare_Bones
> - https://wiki.osdev.org/GCC_Cross-Compiler
> - https://github.com/lordmilko/i686-elf-tools
> - https://github.com/lordmilko/i686-elf-tools
