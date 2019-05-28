import 'compiler/Lexer.dart';
import 'compiler/Parser.dart';
import 'compiler/Token.dart';
import 'dart:collection';

main(List<String> args) {
  if (args.length != 1) {
    print('ERRO: O arquivo fonte deve ser informado como parâmetro.');
    return;
  }

  String sourceCode = args[0];

  Map<String, Token> symbolTable = HashMap();

  Lexer lexer = Lexer(sourceCode, symbolTable);
  Parser parser = Parser(lexer);

  parser.process();
}
