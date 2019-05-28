import 'Lexer.dart';
import 'Pda.dart';

class Parser {
  Lexer _lexer;

  Parser(this._lexer);

  void process() {
    var pda = Pda();

    while (true) {
      var token = _lexer.getToken();
      var action = pda.getAction(token);

      if (action?.type == ActionType.SHIFT) {
        pda.shift(action.param);
      } else if (action?.type == ActionType.REDUCE) {
        pda.reduce(action.param);
      } else if (action?.type == ActionType.ACCEPT) {
        break;
      } else {
        // TODO: Rotina de Erro
        print('ERRO Sintático!');
        break;
      }
    }
  }
}
