import 'Lexer.dart';
import 'dart:collection';

main() {
  Map<String, Token> symbolTable = new HashMap();

  // cria um analisador lexico para o arquivo fonte texto.alg
  var lexer = new Lexer('texto.alg', symbolTable);

  print('Lexema, Token, Tipo');

  // leitura dos tokens
  var token = lexer.getToken();

  while (token != null) {
    print('${token.lexeme}, ${token.token}, ${token.type}');
    if (token.token == 'ERRO') {
      print('Linha: ${lexer.currentLine}, Coluna: ${lexer.currentColumn}');
    }

    token = lexer.getToken();
  }
}
