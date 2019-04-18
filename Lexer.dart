import 'dart:io';
import 'dart:collection';
import 'dart:convert';

class Token {
  String lexeme, token, type;

  Token({this.lexeme, this.token, this.type});
}

class Pair<F, S> {
  F first;
  S second;

  Pair(this.first, this.second);
}

class Lexer {
  String sourceCode;
  int position;

  int state;
  Map<Pair<int, String>, int> transitions;

  Lexer(String sourceCodeFilename) {
    var file = new File(sourceCodeFilename);
    this.sourceCode = file.readAsStringSync();
    this.position = 0;
    this._constructTransitionTable();
  }

  Token getToken() {
    String buffer = "";

    while (this.position < this.sourceCode.length) {
      var pair = Pair<int, String>(this.state, this.sourceCode[this.position]);
      if (this.transitions.containsKey(pair)) {
        buffer += this.sourceCode[this.position];
        this.state = this.transitions[pair];
      } else {
        break;
      }

      this.position++;
    }

    // TODO: Verify if this.state is final when no transitions is allowed or input is finished
    return new Token(lexeme: buffer, token: buffer, type: '-');
  }

  void _constructTransitionTable() {
    this.transitions = new HashMap();
    // TODO: Construct transitions table of DFA
  }
}
