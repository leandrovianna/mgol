import 'Lexer.dart';
import 'dart:collection';

main(List<String> args) {
  if (args.length != 1) {
    print('ERRO: O arquivo fonte deve ser informado como parâmetro.');
    return;
  }

  String sourceCode = args[0];

  Map<String, Token> symbolTable = new HashMap();

  // cria um analisador lexico para o arquivo fonte sourceCode
  var lexer = new Lexer(sourceCode, symbolTable);

  // leitura dos tokens
  var token = lexer.getToken();

  do {
    token = lexer.getToken();

    print('${token.lexeme.padRight(25, ' ')}${token.token.padRight(25, ' ')}${token.type.padRight(25, ' ')}');
    if (token.token == 'ERRO') {
      print('ERRO: Linha: ${lexer.currentLine}, Coluna: ${lexer.currentColumn}');
    }
  } while (token.token != 'EOF');
}
