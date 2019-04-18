import 'dart:io';
import 'dart:collection';

class Token {
  String lexeme, token, type;

  Token({this.lexeme, this.token, this.type});
}

class Pair<F, S> {
  F first;
  S second;

  Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  bool operator==(dynamic other) {
      if (other is! Pair<F, S>)
        return false;

      return other.first == this.first && other.second == this.second;
  }
}

class Lexer {
  String sourceCode;
  int position;

  int state;
  Map<Pair<int, String>, int> transitions;
  Set<int> finalStates;

  Lexer(String sourceCodeFilename) {
    var file = new File(sourceCodeFilename);
    this.sourceCode = file.readAsStringSync() + '\$';
    this.position = 0;
    this._constructDFA();
  }

  Token getToken() {
    if (this.position == this.sourceCode.length)
      return null;

    int begin = 0;

    this.state = 0;

    while (this.position < this.sourceCode.length) {
      if (this.state == 0) {
        begin = this.position;
      }

      var pair = Pair(this.state, this.sourceCode[this.position]);

      if (this.transitions.containsKey(pair)) {
        this.state = this.transitions[pair];
      } else {
        break;
      }

      this.position++;
    }

    String buffer = sourceCode.substring(begin, this.position);
    if (this.finalStates.contains(this.state)) {
      return new Token(lexeme: buffer, token: buffer, type: '-');
    } else {
      print('ERRO!');
      return null;
    }
  }

  void _constructDFA() {
    const String letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String digits = '0123456789';
    const String specialSymbols = '.+-_<>=*/();';

    // construction of DFA transition table
    this.transitions = new HashMap();

    this.transitions[Pair(0, '\n')] = 0;
    this.transitions[Pair(0, '\t')] = 0;
    this.transitions[Pair(0, ' ')] = 0;

    this.transitions[Pair(0, '\$')] = 13; // $ represent EOF

    for (var ch in letters.split('')) {
      this.transitions[Pair(0, ch)] = 10;

      this.transitions[Pair(8, ch)] = 8;
      this.transitions[Pair(10, ch)] = 10;
      this.transitions[Pair(12, ch)] = 12;
    }

    for (var d in digits.split('')) {
      this.transitions[Pair(0, d)] = 1;

      this.transitions[Pair(1, d)] = 1;
      this.transitions[Pair(2, d)] = 3;
      this.transitions[Pair(3, d)] = 3;
      this.transitions[Pair(4, d)] = 6;
      this.transitions[Pair(5, d)] = 6;
      this.transitions[Pair(6, d)] = 6;

      this.transitions[Pair(8, d)] = 8;
      this.transitions[Pair(10, d)] = 10;
      this.transitions[Pair(12, d)] = 12;
    }

    // loop over all visible character of ASCII
    for (var i = 32; i <= 126; i++) {
      var s = String.fromCharCode(i);

      if (s != '"') {
        this.transitions[Pair(8, s)] = 8;
      }

      if (s != '}') {
        this.transitions[Pair(12, s)] = 12;
      }
    }

    this.transitions[Pair(0, '"')] = 8;
    this.transitions[Pair(0, '{')] = 12;
    this.transitions[Pair(0, '=')] = 18;
    this.transitions[Pair(0, '<')] = 14;
    this.transitions[Pair(0, '>')] = 19;
    this.transitions[Pair(0, ';')] = 26;
    this.transitions[Pair(0, '(')] = 24;
    this.transitions[Pair(0, ')')] = 25;
    this.transitions[Pair(0, '+')] = 23;
    this.transitions[Pair(0, '-')] = 23;
    this.transitions[Pair(0, '/')] = 23;
    this.transitions[Pair(0, '*')] = 23;

    this.transitions[Pair(1, '.')] = 2;
    this.transitions[Pair(1, 'E')] = 4;
    this.transitions[Pair(3, 'E')] = 4;
    this.transitions[Pair(1, 'e')] = 4;
    this.transitions[Pair(3, 'e')] = 4;
    this.transitions[Pair(4, '+')] = 5;
    this.transitions[Pair(4, '-')] = 5;

    this.transitions[Pair(8, '"')] = 9;
    this.transitions[Pair(8, '\t')] = 8;

    this.transitions[Pair(10, '_')] = 10;

    this.transitions[Pair(12, '}')] = 0;
    this.transitions[Pair(12, '\t')] = 12;

    this.transitions[Pair(14, '>')] = 16;
    this.transitions[Pair(14, '=')] = 15;
    this.transitions[Pair(14, '-')] = 22;

    this.transitions[Pair(19, '=')] = 20;

    this.finalStates = new Set();
    this.finalStates.addAll([1, 3, 6, 9, 10, 13, 18, 14, 16, 15, 22, 19, 20, 26, 24, 25, 23]);
  }
}
