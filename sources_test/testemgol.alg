{este eh um programa teste em Mgol
elaborado por Carlos Henrique Rorato
e Larissa Santos}

inicio
    varinicio
        B inteiro;
        C literal;
        C2 literal;
        A real;
        c inteiro;
        D inteiro;
    varfim;

    leia C;
    c <- 0;
    enquanto (c <= 10) faca
      escreva C;
     escreva "\n";
      c <- c + 1;
    fimenquanto

   escreva "Digite um numero:";
   leia B;

   {Este eh um comentario no meio do programa}

   B <- 2;
   B <- 3;
   c <- B+1;
   c <- c+1;

   C2 <- C;

   escreva C2;
   escreva "\n";

    
   se (B<1)
   entao
     se (c <2)
     entao
       escreva "texto";
     fimse
   fimse

   {o contador B recebe valor dez e vai decaindo
   com as iteracoes}

   enquanto (B >= 0) faca
     escreva "iteracao...iterando...";
     B <- B -  1;
     se (B > 5)
     entao
       escreva "Numero maior que cinco";
       D <- 2;
       enquanto (D >= 0) faca
        escreva "imprimindo teste...";
       fimenquanto
     fimse
   fimenquanto

   escreva "programa finalizado";

fim
