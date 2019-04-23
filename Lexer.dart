import 'dart:io';
import 'dart:collection';

class Token {
  String lexeme, token, type;

  Token({this.lexeme = '', this.token = '', this.type = ''});
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
  bool operator ==(dynamic other) {
    if (other is! Pair<F, S>) return false;

    return other.first == this.first && other.second == this.second;
  }
}

class Lexer {
  static const List<String> _KEYWORDS = [
    'inicio',
    'varinicio',
    'varfim',
    'escreva',
    'leia',
    'se',
    'entao',
    'fimse',
    'fim',
    'inteiro',
    'lit',
    'real'
  ];

  String _sourceCode;
  int _position;
  int _line, _column;

  int get currentLine => _line;
  int get currentColumn => _column;

  Map<Pair<int, String>, int> _transitions;
  Map<int, String> _finalStates; // state number -> token name

  Map<String, Token> _symbolTable;

  Lexer(String sourceCodeFilename, this._symbolTable) {
    var file = new File(sourceCodeFilename);
    this._sourceCode = file.readAsStringSync();
    this._position = 0;
    this._line = 1;
    this._column = 1;
    this._constructDFA();
    this._populateKeywords();
  }

  Token getToken() {
    int begin = 0, state = 0;

    while (this._position < this._sourceCode.length) {
      if (state == 0) {
        begin = this._position;
      }

      var pair = Pair(state, this._sourceCode[this._position]);

      if (this._transitions.containsKey(pair)) {
        state = this._transitions[pair];
      } else {
        break;
      }

      if (this._sourceCode[this._position] == '\n') {
        this._line++;
        this._column = 0;
      }
      this._column++;

      this._position++;
    }

    String tokenName = this._finalStates[state];

    if (tokenName != null) {
      String lexeme = this._sourceCode.substring(begin, this._position);
      Token token = Token(lexeme: lexeme, token: tokenName, type: '-');

      if (tokenName == 'Id') {
        if (!this._symbolTable.containsKey(lexeme)) {
          this._symbolTable[lexeme] = token;
        }

        return this._symbolTable[lexeme];
      } else {
        return token;
      }
    } else {
      // end of file
      if (this._position == this._sourceCode.length) {
        return Token(lexeme: 'EOF', token: 'EOF');
      }

      this._position++;
      String lexeme = this._sourceCode.substring(begin, this._position);
      return Token(lexeme: lexeme, token: 'ERRO');
    }
  }

  void _constructDFA() {
    const String letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String digits = '0123456789';
    // const String specialSymbols = '.+-_<>=*/();';

    // construction of DFA transition table
    this._transitions = new HashMap();

    this._transitions[Pair(0, '\n')] = 0;
    this._transitions[Pair(0, '\t')] = 0;
    this._transitions[Pair(0, ' ')] = 0;

    this._transitions[Pair(0, '\$')] = 13; // $ represent EOF

    for (var ch in letters.split('')) {
      this._transitions[Pair(0, ch)] = 10;

      this._transitions[Pair(8, ch)] = 8;
      this._transitions[Pair(10, ch)] = 10;
      this._transitions[Pair(12, ch)] = 12;
    }

    for (var d in digits.split('')) {
      this._transitions[Pair(0, d)] = 1;

      this._transitions[Pair(1, d)] = 1;
      this._transitions[Pair(2, d)] = 3;
      this._transitions[Pair(3, d)] = 3;
      this._transitions[Pair(4, d)] = 6;
      this._transitions[Pair(5, d)] = 6;
      this._transitions[Pair(6, d)] = 6;

      this._transitions[Pair(8, d)] = 8;
      this._transitions[Pair(10, d)] = 10;
      this._transitions[Pair(12, d)] = 12;
    }

    // loop over all visible character of ASCII
    for (var i = 32; i <= 126; i++) {
      var s = String.fromCharCode(i);

      if (s != '"') {
        this._transitions[Pair(8, s)] = 8;
      }

      if (s != '}') {
        this._transitions[Pair(12, s)] = 12;
      }
    }

    this._transitions[Pair(0, '"')] = 8;
    this._transitions[Pair(0, '{')] = 12;
    this._transitions[Pair(0, '=')] = 18;
    this._transitions[Pair(0, '<')] = 14;
    this._transitions[Pair(0, '>')] = 19;
    this._transitions[Pair(0, ';')] = 26;
    this._transitions[Pair(0, '(')] = 24;
    this._transitions[Pair(0, ')')] = 25;
    this._transitions[Pair(0, '+')] = 23;
    this._transitions[Pair(0, '-')] = 23;
    this._transitions[Pair(0, '/')] = 23;
    this._transitions[Pair(0, '*')] = 23;

    this._transitions[Pair(1, '.')] = 2;
    this._transitions[Pair(1, 'E')] = 4;
    this._transitions[Pair(3, 'E')] = 4;
    this._transitions[Pair(1, 'e')] = 4;
    this._transitions[Pair(3, 'e')] = 4;
    this._transitions[Pair(4, '+')] = 5;
    this._transitions[Pair(4, '-')] = 5;

    this._transitions[Pair(8, '"')] = 9;
    this._transitions[Pair(8, '\t')] = 8;

    this._transitions[Pair(10, '_')] = 10;

    this._transitions[Pair(12, '}')] = 0;
    this._transitions[Pair(12, '\t')] = 12;

    this._transitions[Pair(14, '>')] = 16;
    this._transitions[Pair(14, '=')] = 15;
    this._transitions[Pair(14, '-')] = 22;

    this._transitions[Pair(19, '=')] = 20;

    this._finalStates = HashMap.fromIterables([
      1,
      3,
      6,
      9,
      10,
      13,
      18,
      14,
      16,
      15,
      22,
      19,
      20,
      26,
      24,
      25,
      23
    ], [
      'Num',
      'Num',
      'Num',
      'Literal',
      'Id',
      'EOF',
      'OPR',
      'OPR',
      'OPR',
      'OPR',
      'RCB',
      'OPR',
      'OPR',
      'PT_V',
      'AB_P',
      'FC_P',
      'OPM'
    ]);
  }

  void _populateKeywords() {
    for (var keyword in _KEYWORDS) {
      this._symbolTable[keyword] =
          new Token(lexeme: keyword, token: keyword, type: '-');
    }
  }
}
