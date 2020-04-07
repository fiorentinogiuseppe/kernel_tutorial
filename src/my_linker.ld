/* O linker pega codigo binario gerado pelo compilador e junta tudo em um executavel */
/* O linker ira descrever como as secoes nos arquivos de entrada devem ser mapeadas no arquivo de saida */
/* alem disso ira controlar o layout da memoria do arquivo de saida. */

/* O bootloader comeca a execucao com o start definido no start.s como global */
/* O ENTRY indica a primeira instrucao executavel em um arquivo de saida, ou seja seu ponto de entrada */
ENTRY(start)

/* SECTIONS Indica para o linker do compilador onde estao as secoes do kernel*/
/* para que este possa mapear nos arquivos de saida */
SECTIONS{

  /* Define o valor do simbolo especial '.', que eh o contador de localizacoes. */
  /* Coloca as secoes em 1M, pois valores abaixo de 1M sao reservadas para outras coisas relacionadas ao x86 */
  . = 1M;

  /* Os alinhamentos serao multiplos de 4K. */
  /* Na estrutura devemos por o multiboot header perto do arquivo de start senao nao sera encontrado pelo bootloader */

  /* Como .rodata eh um segmento para dados constantes/Read-only podemos por aqui */
  .rodata BLOCK(4K) : ALIGN(4K){
    *(.multiboot)
  }

  /* Nosso codigo executavel */
  .text BLOCK(4K) : ALIGN(4K){
    *(.text)
  }

  /* Mais dados constantes do tipo READ-ONLY */
  .rodata BLOCK(4K) : ALIGN(4K){
    *(.rodata)
  }

  /* Dados inicializados por padrao/Read-write */
  .data BLOCK(4K) : ALIGN(4K){
    *(.data)
  }

  /* dados nao inicializados e a stack */
  .bss BLOCK(4K) : ALIGN(4K){
    *(COMMON)
    *(.bss)
  }

}
