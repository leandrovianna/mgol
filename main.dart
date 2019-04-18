import 'Lexer.dart';

main() {
  // cria um analisador lexico para o arquiv fonte texto.alg
  var lexer = new Lexer('texto.alg');

  // leitura dos tokens

  var token = lexer.getToken();
  while (token != null) {
    print('${token.lexeme} ${token.token} ${token.type}');
    token = lexer.getToken();
  }
}
