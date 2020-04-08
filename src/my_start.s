// ------------------- DECLARACOES INICIAIS ------------------- //
// Tornaremos externo , pois esse eh o mesmo nome do main C no kernel.c
.extern kernel_main

// O linker busca essa label
.global start


// Constantes que o GRUB reconhece e que sera utilizada no
// 'Mutiboot header'
.set MB_MAGIC, 0x1BADB002  // Valor usado pelo GRUB para detectar a localizacao do kernel, identificando o header
.set MB_FLAGS, (1 << 0) | (1 << 1) // Pede para o GRUB carregar os modulos em alinhamento "page boundaries"(4KB)
                                   // Pede para o GRUB deixar avaliabel memory map

.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS)) // checksum 32-bits sem sinal que é o resultado da soma de todos os magics com flags

// ------------------- CABECALHO MULTIBOOT ------------------- //
.section .multiboot
  .align 4 // alinhamento sempre multiplos de 4 bytes
  .long MB_MAGIC // Gera um int 32bits e usa os dados gerados anteriormente
  .long MB_FLAGS // Gera um int 32bits e usa os dados gerados anteriormente
  .long MB_CHECKSUM // Gera um int 32bits e usa os dados gerados anteriormente
// Na seção .bss, a diretiva .long não é válida.
// No x86, a pilha cresce PARA BAIXO


// ------------------- VARIAVEIS ALOCADAS ESTATICAMENTE ------------------- //
.section .bss
  // Criacao da stack para C poder rodar. Alocamos 4kb para isso.
  .align 16
  stack_bottom:
    .skip 4096 // Reservando 4k para a stack
  stack_top:

// ------------------- CODIGO ASSEMBLY ------------------- //
.section .text
  // Este é o primeiro código executado no seu kernel.
  start:
    // Configurar o ambiente para o codigo C. Para isso só precisamos Configurar a nossa stack
    mov $stack_top, %esp // Defina o ponteiro da stack para o topo da stack

    // Apos configurado podemos chamar nossa funcao main C
    call kernel_main

    // Nosso try/catch caso por algumas circunstâncias misteriosas
    // para isso iremos apenas desligar a CPU
    hang:
      cli // Desliga as interrupcoes do CPU
      hlt // Parar a CPU
      jmp hang // Se isso não funcionar so tentar novamente
