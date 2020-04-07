//  Arquivo cabeçalho que fornece definições da linguagem de programação C
#include <stddef.h>
//  Declara conjuntos de tipos inteiros com larguras especificadas
//  e define conjuntos correspondentes de macros
#include <stdint.h>

// Checa se ta sendo usado cross compiler correto
// Evitando erros
#if defined(__linux__)
#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
#error "This code must be compiled with an x86-elf compiler"
#endif

// A matriz gráfica de vídeo (VGA) é um padrão gráfico para o controlador de vídeo
volatile uint16_t* vga_buffer = (uint16_t*) 0xB8000;

// buffer do modo de texto VGA tem um tamanho de 80x25 caracteres
// O buffer do modo de texto VGA possui tamanho (VGA_COLS * VGA_ROWS).
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

// Posicao para mostrar o texto canto superior esquerdo da tela (coluna = 0, linha = 0)
int term_col = 0;
int term_row = 0;
uint8_t term_color = 0x0F; // Fundo preto e letras brancas

// Inicia o terminal e limpa a tela do terminal
// Percorre (colxrow) cada pixel colocando espaco no local para que tudo seja limpo na tela
void term_init(){
  // Limpe o buffer do modo de texto
  for (int col = 0; col < VGA_COLS; col++){
    for (int row = 0; row < VGA_ROWS; col++){
      // Encontramos um índice no buffer para o caracter
      const size_t index = (VGA_COLS * row) + col;
      // As entradas no buffer VGA assumem o formato binário BBBBFFFFCCCCCCCC, onde:
      // - B é a cor do plano de fundo
      // - F é a cor do primeiro plano
      // - C é o caractere ASCII
      // Assim eh criado uma variavel de tamanho 16
      // left-shift transforma 0x000F em 0x0F00. Usando or do valor ascii do space
      // temos o valor de 0x0F20
      vga_buffer[index] = ((uint16_t)term_col << 8) | ' '; // Coloca o espaço como caractere

    }
  }
}

// Printa cada caractere na tela
void term_putc(char c)
{
  // Usado para printarmos certos caracteres e utilizar a funcao de outros
  switch (c) {
    // Usando a funcao de new line e nao printando-o
    case '\n':{
      // Nova linha retorna o carro e pula a linha
      term_col = 0;
      term_row ++;
      break;

    }
    default:{
      // Printa o caracter e move o carro para prox color
      // Parecido com o que foi feito na funcao term_init
      const size_t index = (VGA_COLS * term_row) + term_col; // Calcula o index
      vga_buffer[index] = ((uint16_t) term_color << 8) | c; // Coloca o caracter na variavel c como caracter para por na tela
      term_col ++;
      break;
    }

    // Chegamos no fim da coluna
    // Retornamos o carro para o inicio e pulamos uma linha
    if(term_col >= VGA_COLS){
        term_col = 0;
        term_row ++;
    }
    // Se chegarmos a ultima linha
    // Voltamos o carro para o inicio linha, ou seja coluna 0, e voltamos para a linha 0
    if(term_row >= VGA_ROWS){
      term_col = 0;
      term_row = 0;
    }
  }


}

// Printa a string toda na tela
void term_print(const char* str){
  // Move-se pela string ate encontrar uma terminação nula ('\0')
  for (size_t i=0; str[i] != '\0'; i++)
    term_putc(str[i]);
}


// Nossa funcao main
void kernel_main(){
  // inicia o terminal
  term_init();

  // Printa a mensagem
  term_print("Ola mundo!\n");
  term_print("Minha propria versao do kernel.\n");
}
