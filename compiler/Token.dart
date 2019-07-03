class Token {
  String lexeme, token, type;

  Token({this.lexeme, this.token, this.type});

  String toString() => "{Lexeme: $lexeme, Token: $token, Type: $type}";

  Token clone() {
    Token t = Token(lexeme: lexeme, token: token, type: type);
    return t;
  }
}
