import 'dart:collection';
import 'Token.dart';

class Coder {
  String _targetFile;
  HashMap<String, Token> _symbolTable;

  Coder(this._targetFile, this._symbolTable);

  Token semanticRule(int prodIndex, List<Token> args) {
    print(args);
    return args[0];
  }
}
