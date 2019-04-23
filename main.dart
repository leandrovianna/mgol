import 'Lexer.dart';
import 'dart:collection';

main() {
  Map<String, Token> symbolTable = new HashMap();

  // cria um analisador lexico para o arquivo fonte texto.alg
  var lexer = new Lexer('texto.alg', symbolTable);

  // leitura dos tokens
  var token = lexer.getToken();

  do {
    token = lexer.getToken();

    print('${token.lexeme.padRight(25, ' ')}${token.token.padRight(25, ' ')}${token.type.padRight(25, ' ')}');
    if (token.token == 'ERRO') {
      print('Linha: ${lexer.currentLine}, Coluna: ${lexer.currentColumn}');
    }
  } while (token.token != 'EOF');
}
