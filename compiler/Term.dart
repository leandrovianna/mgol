import 'Token.dart';

abstract class Term {
  static const String inicio = 'inicio';
  static const String varinicio = 'varinicio';
  static const String varfim = 'varfim';
  static const String escreva = 'escreva';
  static const String leia = 'leia';
  static const String se = 'se';
  static const String entao = 'entao';
  static const String fimse = 'fimse';
  static const String fim = 'fim';
  static const String inteiro = 'inteiro';
  static const String lit = 'literal';
  static const String real = 'real';
  static const String enquanto = 'enquanto';
  static const String fimenquanto = 'fimenquanto';
  static const String id = 'id';
  static const String literal = 'const_literal';
  static const String numerico = 'num';
  static const String rcb = 'rcb';
  static const String opm = 'opm';
  static const String abp = '(';
  static const String fcp = ')';
  static const String ptv = ';';
  static const String opr = 'opr';
  static const String faca = 'faca';
  static const String eof = 'eof';
  static const String error = 'error';

  static Token dummyToken(String terminal) {
    return Token(lexeme: terminal, token: terminal);
  }
}
