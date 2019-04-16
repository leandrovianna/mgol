import 'Lexer.dart';

main() {
  var lexer = new Lexer('code.mgol');
  lexer.getToken();
}
