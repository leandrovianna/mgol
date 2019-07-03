import 'dart:collection';
import 'dart:io';
import 'Token.dart';

class Coder {
  String _targetFile;
  String _objcode;
  HashMap<String, Token> _symbolTable;

  Coder(this._targetFile, this._symbolTable) {
    this._objcode = '';
  }

  Token semanticRule(int state, List<Token> args) {
    // for each reduction (represented by state)
    // execute the semanticRule associated

    print(args);
    switch (state) {
      case 40:
        // LV -> varfim ;
        return this._endVarDecl();
        break;
      case 58:
        // D -> id TIPO ;
        return this._varDecl(args[0], args[1]);
        break;
      case 42:
        // TIPO -> int
        return this._typeDef(args[0]);
        break;
      case 43:
        // TIPO -> real
        return this._typeDef(args[0]);
        break;
      case 44:
        // TIPO -> lit
        return this._typeDef(args[0]);
        break;
    }

    return null;
  }

  build() {
    var objfile = File(this._targetFile);
    var sink = objfile.openWrite();

    sink.write('''
typedef char lit[512];
typedef double real;

int main() {
''');

    sink.write(_objcode);

    sink.write('''
  return 0;
}
    ''');

    sink.close();
  }

  Token _endVarDecl() {
    _objcode += '\n\n\n';
    return Token(lexeme: '', token: 'LV');
  }

  Token _varDecl(Token id, Token tipo) {
    this._symbolTable[id.lexeme].type = tipo.type;
    _objcode += '\t${tipo.type} ${id.lexeme};\n';
    return Token(lexeme: '', token: 'D');
  }

  Token _typeDef(Token tipo) {
    return Token(lexeme: '', token: 'TIPO', type: tipo.type);
  }
}
