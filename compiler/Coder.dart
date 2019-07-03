import 'dart:collection';
import 'dart:io';
import 'Term.dart';
import 'Token.dart';

class TempVar {
  String _type, _name;

  TempVar(this._type, this._name);

  get type => _type;
  get name => _name;
}

class Coder {
  String _targetFile;
  String _objcode;
  int _tabs;
  HashMap<String, Token> _symbolTable;
  List<TempVar> _tempVars;

  Coder(this._targetFile, this._symbolTable) {
    this._objcode = '';
    this._tempVars = [];
    this._tabs = 1;
  }

  Token semanticRule(int state, List<Token> args) {
    // for each reduction (represented by state)
    // execute the semantic rule associated

    print(args);
    switch (state) {
      case 47:
        // LV -> varfim ;
        return this._endVarDecl();
      case 69:
        // D -> id TIPO ;
        return this._varDecl(args[0], args[1]);
      case 49:
      case 50:
      case 51:
        // TIPO -> inteiro
        // TIPO -> real
        // TIPO -> literal
        return this._typeDef(args[0]);
      case 52:
        // ES -> leia id ;
        return this._readVar(args[1]);
      case 53:
        // ES -> escreva ARG ;
        return this._writeVar(args[1]);
      case 28:
      case 29:
      case 30:
        // ARG -> const_literal
        // ARG -> num
        // ARG -> id
        return this._argDef(args[0]);
      case 70:
        // CMD -> id rcb LD ;
        return this._assigment(args[0], args[1], args[2]);
      case 75:
        // LD -> OPRD opm OPRD
        return this._mathOperation(args[0], args[1], args[2]);
      case 55:
        // LD -> OPRD
        return this._rightHandSingle(args[0]);
      case 56:
      case 57:
        // OPRD -> id
        // OPRD -> num
        return this._operand(args[0]);
      case 32:
        // COND -> CAB CORPO
        return this._ifend();
      case 76:
        // CAB -> se ( EXP_R ) entao
        return this._ifbegin(args[2]);
      case 77:
        // EXP_R -> OPRD opr OPRD
        return this._relational(args[0], args[1], args[2]);
      case 78:
        // REPCAB -> enquanto ( EXP_R ) faca
        return this._whilebegin(args[2]);
      case 38:
        // REP -> REPCAB REPCORPO
        return this._whileend(args[0]);
    }

    return null;
  }

  _writeLine(String line) {
    for (int i = 0; i < this._tabs; i++) {
      this._objcode += '  ';
    }
    this._objcode += line + '\n';
  }

  String _newTemp(String type) {
    String name = 'T${this._tempVars.length}';
    this._tempVars.add(TempVar(type, name));
    return name;
  }

  _incrementTabs() => _tabs = _tabs + 1;

  _decrementTabs() {
    if (_tabs > 1) _tabs = _tabs - 1;
  }

  build() {
    var objfile = File(this._targetFile);
    var sink = objfile.openWrite();

    sink.write('''
#include <stdio.h>
#include <string.h>

typedef char literal[512];

int main() {
''');
    for (var tmp in this._tempVars) {
      switch (tmp.type) {
        case Term.inteiro:
          sink.write('  int ');
          break;
        case Term.real:
          sink.write('  double ');
          break;
        case Term.lit:
          sink.write('  literal ');
          break;
      }

      sink.write('${tmp.name};\n');
    }

    sink.write(_objcode);

    sink.write('''
  return 0;
}
    ''');

    sink.close();
  }

  Token _endVarDecl() {
    this._writeLine('');
    this._writeLine('');
    this._writeLine('');
    return Token(lexeme: '', token: 'LV');
  }

  Token _varDecl(Token id, Token tipo) {
    this._symbolTable[id.lexeme].type = tipo.type;

    String ctype = null;

    switch (tipo.type) {
      case Term.inteiro:
        ctype = 'int';
        break;
      case Term.real:
        ctype = 'double';
        break;
      case Term.lit:
        ctype = 'literal';
        break;
    }

    assert(ctype != null);

    this._writeLine('$ctype ${id.lexeme};');
    return Token(lexeme: '', token: 'D');
  }

  Token _typeDef(Token tipo) {
    return Token(lexeme: '', token: 'TIPO', type: tipo.type);
  }

  Token _readVar(Token id) {
    switch (id.type) {
      case Term.lit:
        this._writeLine('scanf("%s", ${id.lexeme});');
        break;
      case Term.inteiro:
        this._writeLine('scanf("%d", &${id.lexeme});');
        break;
      case Term.real:
        this._writeLine('scanf("%lf", &${id.lexeme});');
        break;
      default:
        throw 'Erro semântico: Variável ${id.lexeme} não declarada';
    }

    return Token(lexeme: '', token: 'ES');
  }

  Token _writeVar(Token arg) {
    switch (arg.type) {
      case Term.lit:
        this._writeLine('printf(${arg.lexeme});');
        break;
      case Term.inteiro:
        this._writeLine('printf("%d", ${arg.lexeme});');
        break;
      case Term.real:
        this._writeLine('printf("%lf", ${arg.lexeme});');
        break;
    }

    return Token(lexeme: '', token: 'ES');
  }

  Token _argDef(Token arg) {
    if (arg.token == Term.id && arg.type == null) {
      throw 'Erro semântico: Variável ${arg.lexeme} não declarada';
    }

    Token copy = arg.clone();
    copy.token = 'ARG';
    return copy;
  }

  Token _assigment(Token id, Token rcb, Token ld) {
    if (id.type == null) {
      throw 'Erro semântico: Variável ${id.lexeme} não declarada';
    }

    if (id.type != ld.type) {
      throw 'Erro semântico: Tipos diferentes para atribução';
    }

    if (id.type == Term.lit) {
      this._writeLine('strcpy(${id.lexeme}, ${ld.lexeme});');
    } else {
      this._writeLine('${id.lexeme} ${rcb.type} ${ld.lexeme};');
    }

    return Token(lexeme: '', token: 'CMD');
  }

  Token _mathOperation(Token operand1, Token operation, Token operand2) {
    if (operand1.type == Term.lit || operand2.type == Term.lit) {
      throw 'Erro semântico: Operandos com tipos incompatíveis';
    }

    String opType = Term.inteiro;
    if (operand1.type == Term.real || operand2.type == Term.real) {
      opType = Term.real;
    }

    var tx = this._newTemp(opType);
    Token ld = Token(lexeme: tx, token: 'LD', type: opType);
    this._writeLine(
        '$tx = ${operand1.lexeme} ${operation.type} ${operand2.lexeme};');

    return ld;
  }

  Token _rightHandSingle(Token operand) {
    Token ld = operand.clone();
    ld.token = 'LD';
    return ld;
  }

  Token _operand(Token operand) {
    if (operand.token == Term.id && operand.type == null) {
      throw 'Erro semântico: Variável ${operand.lexeme} não declarada';
    }

    Token oprd = operand.clone();
    oprd.token = 'OPRD';
    return oprd;
  }

  Token _ifbegin(Token expr) {
    this._writeLine('if (${expr.lexeme}) {');
    this._incrementTabs();
    return Token(lexeme: '', token: 'CAB');
  }

  Token _ifend() {
    this._decrementTabs();
    this._writeLine('}');
    return Token(lexeme: '', token: 'COND');
  }

  Token _relational(Token operand1, Token operation, Token operand2) {
    if (operand1.type != operand2.type) {
      throw 'Erro semântico: Operandos com tipos incompatíveis';
    }

    var tx = this._newTemp(Term.inteiro);
    Token expr = Token(lexeme: tx, token: 'EXP_R', type: Term.inteiro);
    this._writeLine(
        'L$tx: $tx = ${operand1.lexeme} ${operation.type} ${operand2.lexeme};');
    return expr;
  }

  Token _whilebegin(Token expr) {
    this._writeLine('if (${expr.lexeme}) {');
    this._incrementTabs();
    return Token(lexeme: 'L${expr.lexeme}', token: 'REPCAB');
  }

  Token _whileend(Token repcab) {
    this._writeLine('goto ${repcab.lexeme};');
    this._decrementTabs();
    this._writeLine('}');
    return Token(lexeme: '', token: 'REP');
  }
}
