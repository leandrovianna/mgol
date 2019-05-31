inicio 
  varinicio A lit; 
  B int; 
  D int; 
  C real; 
varfim; 

escreva "Digite B"; 
leia B; 
escreva "Digite A:"; 
leia A; 
se(B>2) entao 
  se(B<=4) entao 
    escreva "B esta entre 2 e 4";
    enquanto ( B <= 4 ) faca
      escreva "Sou lindo\n";
      B <- B + 1;
    fimenquanto
  fimse 
fimse 

enquanto ( B <= 10 ) faca
  escreva "Sou muito lindo\n";
  B <- B + 1;
fimenquanto

B<-B+1; 
B<-B+2; 
B<-B+3; 
D<-B; 
C<-5.0; 
escreva "\nB=\n"; 
escreva D; 
escreva "\n"; 
escreva C;    
escreva "\n";    
escreva A;fim
