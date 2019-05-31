import 'Lexer.dart';
import 'Pda.dart';
import 'Term.dart';

class Parser {
  Lexer _lexer;
  Pda _pda;

  Parser(this._lexer);

  void process() {
    _constructPda();

    bool isError = false;
    bool done = false;

    while (!done) {
      try {
        var token = _lexer.getToken();

        while (true) {
          print(token);

          var type = _pda.run(token);

          if (type == ActionType.SHIFT) {
            if (token.token == Term.eof) {
              done = true;
              break;
            }

            token = _lexer.getToken();
          } else if (type == ActionType.ACCEPT) {
            done = true;
            break;
          }
        }
      } catch (error) {
        isError = true;
        print('$error em linha ${_lexer.currentLine} e coluna ' +
            '${_lexer.currentColumn}');
      }
    }

    if (isError) {
      print('Compilador terminou com erros.');
    } else {
      print('Compilação terminada.');
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
    _pda.addProduction(14, 'ARG', Term.id);
    _pda.addProduction(15, 'A', 'CMD A');
    _pda.addProduction(16, 'CMD', 'id rcb LD ;');
    _pda.addProduction(17, 'LD', 'OPRD opm OPRD');
    _pda.addProduction(18, 'LD', 'OPRD');
    _pda.addProduction(19, 'OPRD', Term.id);
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

    _pda.addFollow("P'", [Term.eof]);
    _pda.addFollow('P', [Term.eof]);
    _pda.addFollow('V',
        [Term.fim, Term.leia, Term.escreva, Term.id, Term.enquanto, Term.se]);
    _pda.addFollow('LV',
        [Term.fim, Term.leia, Term.escreva, Term.id, Term.enquanto, Term.se]);
    _pda.addFollow('D', [Term.varfim, Term.id]);
    _pda.addFollow('TIPO', [Term.ptv]);
    _pda.addFollow('A', [Term.eof]);
    _pda.addFollow('ES', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimse,
      Term.fimenquanto
    ]);
    _pda.addFollow('ARG', [Term.ptv]);
    _pda.addFollow('CMD', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimse,
      Term.fimenquanto
    ]);
    _pda.addFollow('LD', [Term.ptv]);
    _pda.addFollow('OPRD', [Term.opm, Term.ptv, Term.opr, Term.fcp]);
    _pda.addFollow('COND', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimse,
      Term.fimenquanto
    ]);
    _pda.addFollow('CAB',
        [Term.leia, Term.escreva, Term.id, Term.fimse, Term.enquanto, Term.se]);
    _pda.addFollow('EXP_R', [Term.fcp]);
    _pda.addFollow('CORPO', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimse,
      Term.fimenquanto
    ]);
    _pda.addFollow('REP', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimenquanto,
      Term.fimse
    ]);
    _pda.addFollow('REPCORPO', [
      Term.fim,
      Term.leia,
      Term.escreva,
      Term.id,
      Term.enquanto,
      Term.se,
      Term.fimenquanto,
      Term.fimse
    ]);

    _pda.addAction(0, Term.inicio, ActionType.SHIFT, 2);
    _pda.addAction(1, Term.eof, ActionType.ACCEPT, -1);
    _pda.addAction(2, 'varinicio', ActionType.SHIFT, 4);
    _pda.addAction(3, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(3, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(3, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(3, 'se', ActionType.SHIFT, 16);
    _pda.addAction(3, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(3, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(4, 'varfim', ActionType.SHIFT, 19);
    _pda.addAction(4, Term.id, ActionType.SHIFT, 20);
    _pda.addAction(5, Term.eof, ActionType.REDUCE, 1);
    _pda.addAction(6, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(6, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(6, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(6, 'se', ActionType.SHIFT, 16);
    _pda.addAction(6, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(6, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(7, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(7, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(7, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(7, 'se', ActionType.SHIFT, 16);
    _pda.addAction(7, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(7, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(8, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(8, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(8, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(8, 'se', ActionType.SHIFT, 16);
    _pda.addAction(8, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(8, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(9, Term.eof, ActionType.REDUCE, 29);
    _pda.addAction(10, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(10, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(10, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(10, 'se', ActionType.SHIFT, 16);
    _pda.addAction(10, 'fim', ActionType.SHIFT, 9);
    _pda.addAction(10, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(11, Term.id, ActionType.SHIFT, 25);
    _pda.addAction(12, Term.id, ActionType.SHIFT, 29);
    _pda.addAction(12, 'literal', ActionType.SHIFT, 27);
    _pda.addAction(12, 'num', ActionType.SHIFT, 28);
    _pda.addAction(13, 'rcb', ActionType.SHIFT, 30);
    _pda.addAction(14, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(14, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(14, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(14, 'se', ActionType.SHIFT, 16);
    _pda.addAction(14, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(14, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(15, '(', ActionType.SHIFT, 37);
    _pda.addAction(16, '(', ActionType.SHIFT, 38);
    _pda.addAction(17, Term.id, ActionType.REDUCE, 2);
    _pda.addAction(17, 'leia', ActionType.REDUCE, 2);
    _pda.addAction(17, 'escreva', ActionType.REDUCE, 2);
    _pda.addAction(17, 'se', ActionType.REDUCE, 2);
    _pda.addAction(17, 'fim', ActionType.REDUCE, 2);
    _pda.addAction(17, 'enquanto', ActionType.REDUCE, 2);
    _pda.addAction(18, 'varfim', ActionType.SHIFT, 19);
    _pda.addAction(18, Term.id, ActionType.SHIFT, 20);
    _pda.addAction(19, ';', ActionType.SHIFT, 40);
    _pda.addAction(20, 'int', ActionType.SHIFT, 42);
    _pda.addAction(20, 'real', ActionType.SHIFT, 43);
    _pda.addAction(20, 'lit', ActionType.SHIFT, 44);
    _pda.addAction(21, Term.eof, ActionType.REDUCE, 9);
    _pda.addAction(22, Term.eof, ActionType.REDUCE, 15);
    _pda.addAction(23, Term.eof, ActionType.REDUCE, 21);
    _pda.addAction(24, Term.eof, ActionType.REDUCE, 30);
    _pda.addAction(25, ';', ActionType.SHIFT, 45);
    _pda.addAction(26, ';', ActionType.SHIFT, 46);
    _pda.addAction(27, ';', ActionType.REDUCE, 12);
    _pda.addAction(28, ';', ActionType.REDUCE, 13);
    _pda.addAction(29, ';', ActionType.REDUCE, 14);
    _pda.addAction(30, Term.id, ActionType.SHIFT, 49);
    _pda.addAction(30, 'num', ActionType.SHIFT, 50);
    _pda.addAction(31, Term.id, ActionType.REDUCE, 22);
    _pda.addAction(31, 'leia', ActionType.REDUCE, 22);
    _pda.addAction(31, 'escreva', ActionType.REDUCE, 22);
    _pda.addAction(31, 'se', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fimse', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fim', ActionType.REDUCE, 22);
    _pda.addAction(31, 'enquanto', ActionType.REDUCE, 22);
    _pda.addAction(31, 'fimenquanto', ActionType.REDUCE, 22);
    _pda.addAction(32, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(32, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(32, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(32, 'se', ActionType.SHIFT, 16);
    _pda.addAction(32, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(32, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(33, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(33, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(33, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(33, 'se', ActionType.SHIFT, 16);
    _pda.addAction(33, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(33, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(34, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(34, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(34, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(34, 'se', ActionType.SHIFT, 16);
    _pda.addAction(34, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(34, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(35, Term.id, ActionType.REDUCE, 28);
    _pda.addAction(35, 'leia', ActionType.REDUCE, 28);
    _pda.addAction(35, 'escreva', ActionType.REDUCE, 28);
    _pda.addAction(35, 'se', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fimse', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fim', ActionType.REDUCE, 28);
    _pda.addAction(35, 'enquanto', ActionType.REDUCE, 28);
    _pda.addAction(35, 'fimenquanto', ActionType.REDUCE, 28);
    _pda.addAction(36, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(36, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(36, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(36, 'se', ActionType.SHIFT, 16);
    _pda.addAction(36, 'fimse', ActionType.SHIFT, 35);
    _pda.addAction(36, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(37, Term.id, ActionType.SHIFT, 49);
    _pda.addAction(37, 'num', ActionType.SHIFT, 50);
    _pda.addAction(38, Term.id, ActionType.SHIFT, 49);
    _pda.addAction(38, 'num', ActionType.SHIFT, 50);
    _pda.addAction(39, Term.id, ActionType.REDUCE, 3);
    _pda.addAction(39, 'leia', ActionType.REDUCE, 3);
    _pda.addAction(39, 'escreva', ActionType.REDUCE, 3);
    _pda.addAction(39, 'se', ActionType.REDUCE, 3);
    _pda.addAction(39, 'fim', ActionType.REDUCE, 3);
    _pda.addAction(39, 'enquanto', ActionType.REDUCE, 3);
    _pda.addAction(40, Term.id, ActionType.REDUCE, 4);
    _pda.addAction(40, 'leia', ActionType.REDUCE, 4);
    _pda.addAction(40, 'escreva', ActionType.REDUCE, 4);
    _pda.addAction(40, 'se', ActionType.REDUCE, 4);
    _pda.addAction(40, 'fim', ActionType.REDUCE, 4);
    _pda.addAction(40, 'enquanto', ActionType.REDUCE, 4);
    _pda.addAction(41, ';', ActionType.SHIFT, 58);
    _pda.addAction(42, ';', ActionType.REDUCE, 6);
    _pda.addAction(43, ';', ActionType.REDUCE, 7);
    _pda.addAction(44, ';', ActionType.REDUCE, 8);
    _pda.addAction(45, Term.id, ActionType.REDUCE, 10);
    _pda.addAction(45, 'leia', ActionType.REDUCE, 10);
    _pda.addAction(45, 'escreva', ActionType.REDUCE, 10);
    _pda.addAction(45, 'se', ActionType.REDUCE, 10);
    _pda.addAction(45, 'fimse', ActionType.REDUCE, 10);
    _pda.addAction(45, 'fim', ActionType.REDUCE, 10);
    _pda.addAction(45, 'enquanto', ActionType.REDUCE, 10);
    _pda.addAction(45, 'fimenquanto', ActionType.REDUCE, 10);
    _pda.addAction(46, Term.id, ActionType.REDUCE, 11);
    _pda.addAction(46, 'leia', ActionType.REDUCE, 11);
    _pda.addAction(46, 'escreva', ActionType.REDUCE, 11);
    _pda.addAction(46, 'se', ActionType.REDUCE, 11);
    _pda.addAction(46, 'fimse', ActionType.REDUCE, 11);
    _pda.addAction(46, 'fim', ActionType.REDUCE, 11);
    _pda.addAction(46, 'enquanto', ActionType.REDUCE, 11);
    _pda.addAction(46, 'fimenquanto', ActionType.REDUCE, 11);
    _pda.addAction(47, ';', ActionType.SHIFT, 59);
    _pda.addAction(48, ';', ActionType.REDUCE, 18);
    _pda.addAction(48, 'opm', ActionType.SHIFT, 60);
    _pda.addAction(49, ';', ActionType.REDUCE, 19);
    _pda.addAction(49, 'opm', ActionType.REDUCE, 19);
    _pda.addAction(49, ')', ActionType.REDUCE, 19);
    _pda.addAction(49, 'opr', ActionType.REDUCE, 19);
    _pda.addAction(50, ';', ActionType.REDUCE, 20);
    _pda.addAction(50, 'opm', ActionType.REDUCE, 20);
    _pda.addAction(50, ')', ActionType.REDUCE, 20);
    _pda.addAction(50, 'opr', ActionType.REDUCE, 20);
    _pda.addAction(51, Term.id, ActionType.REDUCE, 25);
    _pda.addAction(51, 'leia', ActionType.REDUCE, 25);
    _pda.addAction(51, 'escreva', ActionType.REDUCE, 25);
    _pda.addAction(51, 'se', ActionType.REDUCE, 25);
    _pda.addAction(51, 'fimse', ActionType.REDUCE, 25);
    _pda.addAction(51, 'fim', ActionType.REDUCE, 25);
    _pda.addAction(51, 'enquanto', ActionType.REDUCE, 25);
    _pda.addAction(51, 'fimenquanto', ActionType.REDUCE, 25);
    _pda.addAction(52, Term.id, ActionType.REDUCE, 26);
    _pda.addAction(52, 'leia', ActionType.REDUCE, 26);
    _pda.addAction(52, 'escreva', ActionType.REDUCE, 26);
    _pda.addAction(52, 'se', ActionType.REDUCE, 26);
    _pda.addAction(52, 'fimse', ActionType.REDUCE, 26);
    _pda.addAction(52, 'fim', ActionType.REDUCE, 26);
    _pda.addAction(52, 'enquanto', ActionType.REDUCE, 26);
    _pda.addAction(52, 'fimenquanto', ActionType.REDUCE, 26);
    _pda.addAction(53, Term.id, ActionType.REDUCE, 27);
    _pda.addAction(53, 'leia', ActionType.REDUCE, 27);
    _pda.addAction(53, 'escreva', ActionType.REDUCE, 27);
    _pda.addAction(53, 'se', ActionType.REDUCE, 27);
    _pda.addAction(53, 'fimse', ActionType.REDUCE, 27);
    _pda.addAction(53, 'fim', ActionType.REDUCE, 27);
    _pda.addAction(53, 'enquanto', ActionType.REDUCE, 27);
    _pda.addAction(53, 'fimenquanto', ActionType.REDUCE, 27);
    _pda.addAction(54, Term.id, ActionType.REDUCE, 37);
    _pda.addAction(54, 'leia', ActionType.REDUCE, 37);
    _pda.addAction(54, 'escreva', ActionType.REDUCE, 37);
    _pda.addAction(54, 'se', ActionType.REDUCE, 37);
    _pda.addAction(54, 'fimse', ActionType.REDUCE, 37);
    _pda.addAction(54, 'fim', ActionType.REDUCE, 37);
    _pda.addAction(54, 'enquanto', ActionType.REDUCE, 37);
    _pda.addAction(54, 'fimenquanto', ActionType.REDUCE, 37);
    _pda.addAction(55, ')', ActionType.SHIFT, 61);
    _pda.addAction(56, 'opr', ActionType.SHIFT, 62);
    _pda.addAction(57, ')', ActionType.SHIFT, 63);
    _pda.addAction(58, 'varfim', ActionType.REDUCE, 5);
    _pda.addAction(58, Term.id, ActionType.REDUCE, 5);
    _pda.addAction(59, Term.id, ActionType.REDUCE, 16);
    _pda.addAction(59, 'leia', ActionType.REDUCE, 16);
    _pda.addAction(59, 'escreva', ActionType.REDUCE, 16);
    _pda.addAction(59, 'se', ActionType.REDUCE, 16);
    _pda.addAction(59, 'fimse', ActionType.REDUCE, 16);
    _pda.addAction(59, 'fim', ActionType.REDUCE, 16);
    _pda.addAction(59, 'enquanto', ActionType.REDUCE, 16);
    _pda.addAction(59, 'fimenquanto', ActionType.REDUCE, 16);
    _pda.addAction(60, Term.id, ActionType.SHIFT, 49);
    _pda.addAction(60, 'num', ActionType.SHIFT, 50);
    _pda.addAction(61, 'faca', ActionType.SHIFT, 65);
    _pda.addAction(62, Term.id, ActionType.SHIFT, 49);
    _pda.addAction(62, 'num', ActionType.SHIFT, 50);
    _pda.addAction(63, 'entao', ActionType.SHIFT, 67);
    _pda.addAction(64, ';', ActionType.REDUCE, 17);
    _pda.addAction(65, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(65, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(65, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(65, 'se', ActionType.SHIFT, 16);
    _pda.addAction(65, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(65, 'fimenquanto', ActionType.SHIFT, 73);
    _pda.addAction(66, ')', ActionType.REDUCE, 24);
    _pda.addAction(67, Term.id, ActionType.REDUCE, 23);
    _pda.addAction(67, 'leia', ActionType.REDUCE, 23);
    _pda.addAction(67, 'escreva', ActionType.REDUCE, 23);
    _pda.addAction(67, 'se', ActionType.REDUCE, 23);
    _pda.addAction(67, 'fimse', ActionType.REDUCE, 23);
    _pda.addAction(67, 'enquanto', ActionType.REDUCE, 23);
    _pda.addAction(68, Term.id, ActionType.REDUCE, 31);
    _pda.addAction(68, 'leia', ActionType.REDUCE, 31);
    _pda.addAction(68, 'escreva', ActionType.REDUCE, 31);
    _pda.addAction(68, 'se', ActionType.REDUCE, 31);
    _pda.addAction(68, 'fimse', ActionType.REDUCE, 31);
    _pda.addAction(68, 'fim', ActionType.REDUCE, 31);
    _pda.addAction(68, 'enquanto', ActionType.REDUCE, 31);
    _pda.addAction(68, 'fimenquanto', ActionType.REDUCE, 31);
    _pda.addAction(69, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(69, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(69, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(69, 'se', ActionType.SHIFT, 16);
    _pda.addAction(69, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(69, 'fimenquanto', ActionType.SHIFT, 73);
    _pda.addAction(70, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(70, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(70, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(70, 'se', ActionType.SHIFT, 16);
    _pda.addAction(70, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(70, 'fimenquanto', ActionType.SHIFT, 73);
    _pda.addAction(71, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(71, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(71, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(71, 'se', ActionType.SHIFT, 16);
    _pda.addAction(71, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(71, 'fimenquanto', ActionType.SHIFT, 73);
    _pda.addAction(72, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(72, 'leia', ActionType.SHIFT, 11);
    _pda.addAction(72, 'escreva', ActionType.SHIFT, 12);
    _pda.addAction(72, 'se', ActionType.SHIFT, 16);
    _pda.addAction(72, 'enquanto', ActionType.SHIFT, 15);
    _pda.addAction(72, 'fimenquanto', ActionType.SHIFT, 73);
    _pda.addAction(73, Term.id, ActionType.REDUCE, 36);
    _pda.addAction(73, 'leia', ActionType.REDUCE, 36);
    _pda.addAction(73, 'escreva', ActionType.REDUCE, 36);
    _pda.addAction(73, 'se', ActionType.REDUCE, 36);
    _pda.addAction(73, 'fimse', ActionType.REDUCE, 36);
    _pda.addAction(73, 'fim', ActionType.REDUCE, 36);
    _pda.addAction(73, 'enquanto', ActionType.REDUCE, 36);
    _pda.addAction(73, 'fimenquanto', ActionType.REDUCE, 36);
    _pda.addAction(74, Term.id, ActionType.REDUCE, 32);
    _pda.addAction(74, 'leia', ActionType.REDUCE, 32);
    _pda.addAction(74, 'escreva', ActionType.REDUCE, 32);
    _pda.addAction(74, 'se', ActionType.REDUCE, 32);
    _pda.addAction(74, 'fimse', ActionType.REDUCE, 32);
    _pda.addAction(74, 'fim', ActionType.REDUCE, 32);
    _pda.addAction(74, 'enquanto', ActionType.REDUCE, 32);
    _pda.addAction(74, 'fimenquanto', ActionType.REDUCE, 32);
    _pda.addAction(75, Term.id, ActionType.REDUCE, 33);
    _pda.addAction(75, 'leia', ActionType.REDUCE, 33);
    _pda.addAction(75, 'escreva', ActionType.REDUCE, 33);
    _pda.addAction(75, 'se', ActionType.REDUCE, 33);
    _pda.addAction(75, 'fimse', ActionType.REDUCE, 33);
    _pda.addAction(75, 'fim', ActionType.REDUCE, 33);
    _pda.addAction(75, 'enquanto', ActionType.REDUCE, 33);
    _pda.addAction(75, 'fimenquanto', ActionType.REDUCE, 33);
    _pda.addAction(76, Term.id, ActionType.REDUCE, 34);
    _pda.addAction(76, 'leia', ActionType.REDUCE, 34);
    _pda.addAction(76, 'escreva', ActionType.REDUCE, 34);
    _pda.addAction(76, 'se', ActionType.REDUCE, 34);
    _pda.addAction(76, 'fimse', ActionType.REDUCE, 34);
    _pda.addAction(76, 'fim', ActionType.REDUCE, 34);
    _pda.addAction(76, 'enquanto', ActionType.REDUCE, 34);
    _pda.addAction(76, 'fimenquanto', ActionType.REDUCE, 34);
    _pda.addAction(77, Term.id, ActionType.REDUCE, 35);
    _pda.addAction(77, 'leia', ActionType.REDUCE, 35);
    _pda.addAction(77, 'escreva', ActionType.REDUCE, 35);
    _pda.addAction(77, 'se', ActionType.REDUCE, 35);
    _pda.addAction(77, 'fimse', ActionType.REDUCE, 35);
    _pda.addAction(77, 'fim', ActionType.REDUCE, 35);
    _pda.addAction(77, 'enquanto', ActionType.REDUCE, 35);
    _pda.addAction(77, 'fimenquanto', ActionType.REDUCE, 35);

    _pda.addGoto(0, 'P', 1);
    _pda.addGoto(2, 'V', 3);
    _pda.addGoto(3, 'A', 5);
    _pda.addGoto(3, 'ES', 6);
    _pda.addGoto(3, 'CMD', 7);
    _pda.addGoto(3, 'COND', 8);
    _pda.addGoto(3, 'CAB', 14);
    _pda.addGoto(3, 'REP', 10);
    _pda.addGoto(4, 'LV', 17);
    _pda.addGoto(4, 'D', 18);
    _pda.addGoto(6, 'A', 21);
    _pda.addGoto(6, 'ES', 6);
    _pda.addGoto(6, 'CMD', 7);
    _pda.addGoto(6, 'COND', 8);
    _pda.addGoto(6, 'CAB', 14);
    _pda.addGoto(6, 'REP', 10);
    _pda.addGoto(7, 'A', 22);
    _pda.addGoto(7, 'ES', 6);
    _pda.addGoto(7, 'CMD', 7);
    _pda.addGoto(7, 'COND', 8);
    _pda.addGoto(7, 'CAB', 14);
    _pda.addGoto(7, 'REP', 10);
    _pda.addGoto(8, 'A', 23);
    _pda.addGoto(8, 'ES', 6);
    _pda.addGoto(8, 'CMD', 7);
    _pda.addGoto(8, 'COND', 8);
    _pda.addGoto(8, 'CAB', 14);
    _pda.addGoto(8, 'REP', 10);
    _pda.addGoto(10, 'A', 24);
    _pda.addGoto(10, 'ES', 6);
    _pda.addGoto(10, 'CMD', 7);
    _pda.addGoto(10, 'COND', 8);
    _pda.addGoto(10, 'CAB', 14);
    _pda.addGoto(10, 'REP', 10);
    _pda.addGoto(12, 'ARG', 26);
    _pda.addGoto(14, 'ES', 32);
    _pda.addGoto(14, 'CMD', 33);
    _pda.addGoto(14, 'COND', 34);
    _pda.addGoto(14, 'CAB', 14);
    _pda.addGoto(14, 'CORPO', 31);
    _pda.addGoto(14, 'REP', 36);
    _pda.addGoto(18, 'LV', 39);
    _pda.addGoto(18, 'D', 18);
    _pda.addGoto(20, 'TIPO', 41);
    _pda.addGoto(30, 'LD', 47);
    _pda.addGoto(30, 'OPRD', 48);
    _pda.addGoto(32, 'ES', 32);
    _pda.addGoto(32, 'CMD', 33);
    _pda.addGoto(32, 'COND', 34);
    _pda.addGoto(32, 'CAB', 14);
    _pda.addGoto(32, 'CORPO', 51);
    _pda.addGoto(32, 'REP', 36);
    _pda.addGoto(33, 'ES', 32);
    _pda.addGoto(33, 'CMD', 33);
    _pda.addGoto(33, 'COND', 34);
    _pda.addGoto(33, 'CAB', 14);
    _pda.addGoto(33, 'CORPO', 52);
    _pda.addGoto(33, 'REP', 36);
    _pda.addGoto(34, 'ES', 32);
    _pda.addGoto(34, 'CMD', 33);
    _pda.addGoto(34, 'COND', 34);
    _pda.addGoto(34, 'CAB', 14);
    _pda.addGoto(34, 'CORPO', 53);
    _pda.addGoto(34, 'REP', 36);
    _pda.addGoto(36, 'ES', 32);
    _pda.addGoto(36, 'CMD', 33);
    _pda.addGoto(36, 'COND', 34);
    _pda.addGoto(36, 'CAB', 14);
    _pda.addGoto(36, 'CORPO', 54);
    _pda.addGoto(36, 'REP', 36);
    _pda.addGoto(37, 'OPRD', 56);
    _pda.addGoto(37, 'EXP_R', 55);
    _pda.addGoto(38, 'OPRD', 56);
    _pda.addGoto(38, 'EXP_R', 57);
    _pda.addGoto(60, 'OPRD', 64);
    _pda.addGoto(62, 'OPRD', 66);
    _pda.addGoto(65, 'ES', 69);
    _pda.addGoto(65, 'CMD', 70);
    _pda.addGoto(65, 'COND', 71);
    _pda.addGoto(65, 'CAB', 14);
    _pda.addGoto(65, 'REP', 72);
    _pda.addGoto(65, 'REPCORPO', 68);
    _pda.addGoto(69, 'ES', 69);
    _pda.addGoto(69, 'CMD', 70);
    _pda.addGoto(69, 'COND', 71);
    _pda.addGoto(69, 'CAB', 14);
    _pda.addGoto(69, 'REP', 72);
    _pda.addGoto(69, 'REPCORPO', 74);
    _pda.addGoto(70, 'ES', 69);
    _pda.addGoto(70, 'CMD', 70);
    _pda.addGoto(70, 'COND', 71);
    _pda.addGoto(70, 'CAB', 14);
    _pda.addGoto(70, 'REP', 72);
    _pda.addGoto(70, 'REPCORPO', 75);
    _pda.addGoto(71, 'ES', 69);
    _pda.addGoto(71, 'CMD', 70);
    _pda.addGoto(71, 'COND', 71);
    _pda.addGoto(71, 'CAB', 14);
    _pda.addGoto(71, 'REP', 72);
    _pda.addGoto(71, 'REPCORPO', 76);
    _pda.addGoto(72, 'ES', 69);
    _pda.addGoto(72, 'CMD', 70);
    _pda.addGoto(72, 'COND', 71);
    _pda.addGoto(72, 'CAB', 14);
    _pda.addGoto(72, 'REP', 72);
    _pda.addGoto(72, 'REPCORPO', 77);

    _pda.addReduction(0, 0, 0);
    _pda.addReduction(1, 0, 1);
    _pda.addReduction(2, 1, 1);
    _pda.addReduction(3, 1, 2);
    _pda.addReduction(4, 2, 1);
    _pda.addReduction(5, 1, 3);
    _pda.addReduction(6, 9, 1);
    _pda.addReduction(7, 15, 1);
    _pda.addReduction(8, 21, 1);
    _pda.addReduction(9, 29, 1);
    _pda.addReduction(10, 30, 1);
    _pda.addReduction(11, 10, 1);
    _pda.addReduction(12, 11, 1);
    _pda.addReduction(13, 16, 1);
    _pda.addReduction(14, 22, 1);
    _pda.addReduction(15, 31, 1);
    _pda.addReduction(16, 23, 1);
    _pda.addReduction(17, 2, 2);
    _pda.addReduction(18, 3, 1);
    _pda.addReduction(19, 4, 1);
    _pda.addReduction(20, 5, 1);
    _pda.addReduction(21, 9, 2);
    _pda.addReduction(22, 15, 2);
    _pda.addReduction(23, 21, 2);
    _pda.addReduction(24, 30, 2);
    _pda.addReduction(25, 10, 2);
    _pda.addReduction(26, 11, 2);
    _pda.addReduction(27, 12, 1);
    _pda.addReduction(28, 13, 1);
    _pda.addReduction(29, 14, 1);
    _pda.addReduction(30, 16, 2);
    _pda.addReduction(31, 22, 2);
    _pda.addReduction(32, 25, 1);
    _pda.addReduction(33, 26, 1);
    _pda.addReduction(34, 27, 1);
    _pda.addReduction(35, 28, 1);
    _pda.addReduction(36, 37, 1);
    _pda.addReduction(37, 31, 2);
    _pda.addReduction(38, 23, 2);
    _pda.addReduction(39, 3, 2);
    _pda.addReduction(40, 4, 2);
    _pda.addReduction(41, 5, 2);
    _pda.addReduction(42, 6, 1);
    _pda.addReduction(43, 7, 1);
    _pda.addReduction(44, 8, 1);
    _pda.addReduction(45, 10, 3);
    _pda.addReduction(46, 11, 3);
    _pda.addReduction(47, 16, 3);
    _pda.addReduction(48, 18, 1);
    _pda.addReduction(49, 19, 1);
    _pda.addReduction(50, 20, 1);
    _pda.addReduction(51, 25, 2);
    _pda.addReduction(52, 26, 2);
    _pda.addReduction(53, 27, 2);
    _pda.addReduction(54, 37, 2);
    _pda.addReduction(55, 31, 3);
    _pda.addReduction(56, 24, 1);
    _pda.addReduction(57, 23, 3);
    _pda.addReduction(58, 5, 3);
    _pda.addReduction(59, 16, 4);
    _pda.addReduction(60, 17, 2);
    _pda.addReduction(61, 31, 4);
    _pda.addReduction(62, 24, 2);
    _pda.addReduction(63, 23, 4);
    _pda.addReduction(64, 17, 3);
    _pda.addReduction(65, 31, 5);
    _pda.addReduction(66, 24, 3);
    _pda.addReduction(67, 23, 5);
    _pda.addReduction(68, 31, 6);
    _pda.addReduction(69, 32, 1);
    _pda.addReduction(70, 33, 1);
    _pda.addReduction(71, 34, 1);
    _pda.addReduction(72, 35, 1);
    _pda.addReduction(73, 36, 1);
    _pda.addReduction(74, 32, 2);
    _pda.addReduction(75, 33, 2);
    _pda.addReduction(76, 34, 2);
    _pda.addReduction(77, 35, 2);
  }
}
