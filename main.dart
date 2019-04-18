import 'Lexer.dart';
import 'dart:collection';

main() {
  Map<String, Token> symbolTable = new HashMap();

  // cria um analisador lexico para o arquivo fonte texto.alg
  var lexer = new Lexer('texto.alg', symbolTable);

  // leitura dos tokens
  var token = lexer.getToken();
  print('Lexema\tToken\tTipo');
  while (token != null) {
    print('${token.lexeme}\t${token.token}\t${token.type}');
    token = lexer.getToken();
  }
}
