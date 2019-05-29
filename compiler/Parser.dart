import 'Lexer.dart';
import 'Pda.dart';

class Parser {
  Lexer _lexer;
  Pda _pda;

  Parser(this._lexer);

  void process() {
    _constructPda();

    while (true) {
      var token = _lexer.getToken();
      var action = _pda.getAction(token);

      if (action?.type == ActionType.SHIFT) {
        _pda.shift(action.param);
      } else if (action?.type == ActionType.REDUCE) {
        _pda.reduce(action.param);
      } else if (action?.type == ActionType.ACCEPT) {
        break;
      } else {
        // TODO: Rotina de Erro
        print('Parser Error');
        break;
      }
    }
  }

  void _constructPda() {
    _pda = Pda();

    _pda.addProduction(0, "P'", 'P');
    _pda.addProduction(1, 'P', 'inicio V A');
    _pda.addProduction(2, 'V', 'varinicio LV');
    _pda.addProduction(3, 'LV', 'D LV');
    _pda.addProduction(4, 'LV', 'varfim ;');
    _pda.addProduction(5, 'D', 'id TIPO ;');
    _pda.addProduction(6, 'TIPO', 'int');
    _pda.addProduction(7, 'TIPO', 'real');
    _pda.addProduction(8, 'TIPO', 'lit');
    _pda.addProduction(9, 'A', 'ES A');
    _pda.addProduction(10, 'ES', 'leia id ;');
    _pda.addProduction(11, 'ES', 'escreva ARG ;');
    _pda.addProduction(12, 'ARG', 'literal');
    _pda.addProduction(13, 'ARG', 'num');
    _pda.addProduction(14, 'ARG', 'id');
    _pda.addProduction(15, 'A', 'CMD A');
    _pda.addProduction(16, 'CMD', 'id rcb LD ;');
    _pda.addProduction(17, 'LD', 'OPRD opm OPRD');
    _pda.addProduction(18, 'LD', 'OPRD');
    _pda.addProduction(19, 'OPRD', 'id');
    _pda.addProduction(20, 'OPRD', 'num');
    _pda.addProduction(21, 'A', 'COND A');
    _pda.addProduction(22, 'COND', 'CAB CORPO');
    _pda.addProduction(23, 'CAB', 'se ( EXP_R ) entao');
    _pda.addProduction(24, 'EXP_R', 'OPRD opr OPRD');
    _pda.addProduction(25, 'CORPO', 'ES CORPO');
    _pda.addProduction(26, 'CORPO', 'CMD CORPO');
    _pda.addProduction(27, 'CORPO', 'COND CORPO');
    _pda.addProduction(28, 'CORPO', 'fimse');
    _pda.addProduction(29, 'A', 'fim');
    _pda.addProduction(30, 'A', 'REP A');
    _pda.addProduction(31, 'REP', 'enquanto ( EXP_R ) faca REPCORPO');
    _pda.addProduction(32, 'REPCORPO', 'ES REPCORPO');
    _pda.addProduction(33, 'REPCORPO', 'CMD REPCORPO');
    _pda.addProduction(34, 'REPCORPO', 'COND REPCORPO');
    _pda.addProduction(35, 'REPCORPO', 'REP REPCORPO');
    _pda.addProduction(36, 'REPCORPO', 'fimenquanto');
    _pda.addProduction(37, 'CORPO', 'REP CORPO');

    _pda.addAction(0, 'inicio', ActionType.SHIFT, 2);
    _pda.addAction(1, '\$', ActionType.ACCEPT, -1);
    _pda.addAction(2, 'varinicio', ActionType.SHIFT, 4);
    _pda.addAction(3, 'id', ActionType.SHIFT, 13);
    _pda.addAction(3, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(3, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(3, 'se', ActionType.SHIFT, 16);
    _pda.addAction(3, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(3, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(4, 'varfim', ActionType.SHIFT, 19);
    _pda.addAction(4, 'id', ActionType.SHIFT, 20);
    _pda.addAction(5, '\$', ActionType.REDUCE, 1);
    _pda.addAction(6, 'id', ActionType.SHIFT, 13);
    _pda.addAction(6, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(6, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(6, 'se', ActionType.SHIFT, 16);
    _pda.addAction(6, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(6, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(7, 'id', ActionType.SHIFT, 13);
    _pda.addAction(7, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(7, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(7, 'se', ActionType.SHIFT, 16);
    _pda.addAction(7, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(7, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(8, 'id', ActionType.SHIFT, 13);
    _pda.addAction(8, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(8, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(8, 'se', ActionType.SHIFT, 16);
    _pda.addAction(8, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(8, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(9, '$', ActionType.REDUCE, 29);
    _pda.addAction(10, 'id', ActionType.SHIFT, 13);
    _pda.addAction(10, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(10, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(10, 'se', ActionType.SHIFT, 16);
    _pda.addAction(10, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(10, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(11, 'id', ActionType.SHIFT, 25);
    _pda.addAction(12, 'id', ActionType.SHIFT, 29);
    _pda.addAction(12, 'literal', ActionType.SHIFT, 27);
    _pda.addAction(12, 'num', ActionType.SHIFT, 28);
    _pda.addAction(13, 'rcb', ActionType.SHIFT, 30);
    _pda.addAction(14, 'id', ActionType.SHIFT, 13);
    _pda.addAction(14, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(14, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(14, 'se', ActionType.SHIFT, 16);
    _pda.addAction(14, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(14, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(15, '(', ActionType.SHIFT, 37);
    _pda.addAction(16, '(', ActionType.SHIFT, 38);
    _pda.addAction(17, 'id', ActionType.REDUCE, 2);
    _pda.addAction(17, 'leia', ActionType.REDUCE, 2);
    _pda.addAction(17, 'escreva', ActionType.REDUCE, 2);
    _pda.addAction(17, 'se', ActionType.REDUCE, 2);
    _pda.addAction(17, 'fim', ActionType.REDUCE, 2);
    _pda.addAction(17, 'enquanto', ActionType.REDUCE, 2);
    _pda.addAction(18, 'varfim', ActionType.SHIFT, 19);
    _pda.addAction(18, 'id', ActionType.SHIFT, 20);
    _pda.addAction(19, ';', ActionType.SHIFT, 40);
    _pda.addAction(20, 'int', ActionType.SHIFT, 42);
    _pda.addAction(20, 'real', ActionType.SHIFT, 43);
    _pda.addAction(20, 'lit', ActionType.SHIFT, 44);
    _pda.addAction(21, '$', ActionType.REDUCE, 9);
    _pda.addAction(22, '$', ActionType.REDUCE, 15);
    _pda.addAction(23, '$', ActionType.REDUCE, 21);
    _pda.addAction(24, '$', ActionType.REDUCE, 30);
    _pda.addAction(25, ';', ActionType.SHIFT, 45);
    _pda.addAction(26, ';', ActionType.SHIFT, 46);
    _pda.addAction(27, ';', ActionType.REDUCE, 12);
    _pda.addAction(28, ';', ActionType.REDUCE, 13);
    _pda.addAction(29, ';', ActionType.REDUCE, 14);
    _pda.addAction(30, 'id', ActionType.SHIFT, 49);
    _pda.addAction(30, 'num', ActionType.SHIFT, 50);
    _pda.addAction(31, 'id', ActionType.REDUCE, 22);
    _pda.addAction(31, 'leia', ActionType.REDUCE, 22);
    _pda.addAction(31, 'escreva', ActionType.REDUCE, 22);
    _pda.addAction(31, 'se', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fimse', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fim', ActionType.REDUCE, 22);
    _pda.addAction(31, 'enquanto', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fimenquanto', ActionType.REDUCE, 22);
    _pda.addAction(32, 'id', ActionType.SHIFT, 13);
    _pda.addAction(32, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(32, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(32, 'se', ActionType.SHIFT, 16);
    _pda.addAction(32, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(32, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(33, 'id', ActionType.SHIFT, 13);
    _pda.addAction(33, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(33, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(33, 'se', ActionType.SHIFT, 16);
    _pda.addAction(33, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(33, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(34, 'id', ActionType.SHIFT, 13);
    _pda.addAction(34, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(34, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(34, 'se', ActionType.SHIFT, 16);
    _pda.addAction(34, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(34, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(35, 'id', ActionType.REDUCE, 28);
    _pda.addAction(35, 'leia', ActionType.REDUCE, 28);
    _pda.addAction(35, 'escreva', ActionType.REDUCE, 28);
    _pda.addAction(35, 'se', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fimse', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fim', ActionType.REDUCE, 28);
    _pda.addAction(35, 'enquanto', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fimenquanto', ActionType.REDUCE, 28);
    _pda.addAction(36, 'id', ActionType.SHIFT, 13);
    _pda.addAction(36, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(36, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(36, 'se', ActionType.SHIFT, 16);
    _pda.addAction(36, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(36, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(37, 'id', ActionType.SHIFT, 49);
    _pda.addAction(37, 'num', ActionType.SHIFT, 50);
    _pda.addAction(38, 'id', ActionType.SHIFT, 49);
    _pda.addAction(38, 'num', ActionType.SHIFT, 50);
    
  }
}
