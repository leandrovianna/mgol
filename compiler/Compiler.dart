import 'Token.dart';
import 'dart:collection';
import 'Lexer.dart';
import 'Parser.dart';
import 'Coder.dart';

class Compiler {
  String _sourceCode, _targetFile;

  Compiler(this._sourceCode, this._targetFile);

  compile() {
    Map<String, Token> symbolTable = HashMap();
    Lexer lexer = Lexer(this._sourceCode, symbolTable);
    Coder coder = new Coder(this._targetFile, symbolTable);
    Parser parser = Parser(lexer, coder);
    parser.process();
  }
}
