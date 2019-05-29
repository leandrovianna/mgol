class Token {
  String lexeme, token, type;

  Token({this.lexeme = '', this.token = '', this.type = ''});

  String toString() => "$lexeme, $token";
}
