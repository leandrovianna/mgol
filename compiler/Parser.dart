import 'Lexer.dart';
import 'Coder.dart';
import 'Pda.dart';
import 'Term.dart';

class Parser {
  Lexer _lexer;
  Coder _coder;
  Pda _pda;

  Parser(this._lexer, this._coder);

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
        print('[ERRO] $error em linha ${_lexer.currentLine} e coluna ' +
            '${_lexer.currentColumn}');
      }
    }

    if (isError) {
      print('Compilação terminou com erros.');
    } else {
      _coder.build(); // generate target code
      print('Compilação terminada.');
    }
  }

  void _constructPda() {
    _pda = Pda((state, args) => _coder.semanticRule(state, args));

    _pda.addProduction(0, "P'", 'P');
    _pda.addProduction(1, 'P', 'inicio V A');
    _pda.addProduction(2, 'V', 'varinicio LV');
    _pda.addProduction(3, 'LV', 'D LV');
    _pda.addProduction(4, 'LV', 'varfim ;');
    _pda.addProduction(5, 'D', 'id TIPO ;');
    _pda.addProduction(6, 'TIPO', 'inteiro');
    _pda.addProduction(7, 'TIPO', 'real');
    _pda.addProduction(8, 'TIPO', 'literal');
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
    _pda.addProduction(31, 'REP', 'REPCAB REPCORPO');
    _pda.addProduction(32, 'REPCORPO', 'ES REPCORPO');
    _pda.addProduction(33, 'REPCORPO', 'CMD REPCORPO');
    _pda.addProduction(34, 'REPCORPO', 'COND REPCORPO');
    _pda.addProduction(35, 'REPCORPO', 'REP REPCORPO');
    _pda.addProduction(36, 'REPCORPO', 'fimenquanto');
    _pda.addProduction(37, 'CORPO', 'REP CORPO');
    _pda.addProduction(38, 'REPCAB', 'enquanto ( EXP_R ) faca');

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
    _pda.addFollow('REPCAB', [
      Term.leia,
      Term.escreva,
      Term.id,
      Term.fimenquanto,
      Term.se,
      Term.enquanto
    ]);

    _pda.addAction(0, Term.inicio, ActionType.SHIFT, 2);
    _pda.addAction(1, Term.eof, ActionType.ACCEPT, -1);
    _pda.addAction(2, Term.varinicio, ActionType.SHIFT, 4);
    _pda.addAction(4, Term.varfim, ActionType.SHIFT, 20);
    _pda.addAction(4, Term.id, ActionType.SHIFT, 21);
    _pda.addAction(5, Term.eof, ActionType.REDUCE, 1);

    for (var st in [3, 6, 7, 8, 10]) {
      _pda.addAction(st, Term.id, ActionType.SHIFT, 13);
      _pda.addAction(st, Term.leia, ActionType.SHIFT, 11);
      _pda.addAction(st, Term.escreva, ActionType.SHIFT, 12);
      _pda.addAction(st, Term.se, ActionType.SHIFT, 16);
      _pda.addAction(st, Term.fim, ActionType.SHIFT, 9);
      _pda.addAction(st, Term.enquanto, ActionType.SHIFT, 17);
    }

    _pda.addAction(9, Term.eof, ActionType.REDUCE, 29);

    _pda.addAction(11, Term.id, ActionType.SHIFT, 26);
    _pda.addAction(12, Term.id, ActionType.SHIFT, 30);
    _pda.addAction(12, Term.literal, ActionType.SHIFT, 28);
    _pda.addAction(12, Term.numerico, ActionType.SHIFT, 29);
    _pda.addAction(13, Term.rcb, ActionType.SHIFT, 31);

    for (var st in [14, 33, 34, 35, 37]) {
      _pda.addAction(st, Term.id, ActionType.SHIFT, 13);
      _pda.addAction(st, Term.leia, ActionType.SHIFT, 11);
      _pda.addAction(st, Term.escreva, ActionType.SHIFT, 12);
      _pda.addAction(st, Term.se, ActionType.SHIFT, 16);
      _pda.addAction(st, Term.fimse, ActionType.SHIFT, 36);
      _pda.addAction(st, Term.enquanto, ActionType.SHIFT, 17);
    }

    _pda.addAction(15, Term.id, ActionType.SHIFT, 13);
    _pda.addAction(15, Term.leia, ActionType.SHIFT, 11);
    _pda.addAction(15, Term.escreva, ActionType.SHIFT, 12);
    _pda.addAction(15, Term.se, ActionType.SHIFT, 16);
    _pda.addAction(15, Term.fimenquanto, ActionType.SHIFT, 43);
    _pda.addAction(15, Term.enquanto, ActionType.SHIFT, 17);

    _pda.addAction(16, '(', ActionType.SHIFT, 44);
    _pda.addAction(17, '(', ActionType.SHIFT, 45);

    _pda.addAction(18, Term.id, ActionType.REDUCE, 2);
    _pda.addAction(18, Term.leia, ActionType.REDUCE, 2);
    _pda.addAction(18, Term.escreva, ActionType.REDUCE, 2);
    _pda.addAction(18, Term.se, ActionType.REDUCE, 2);
    _pda.addAction(18, Term.fim, ActionType.REDUCE, 2);
    _pda.addAction(18, Term.enquanto, ActionType.REDUCE, 2);

    _pda.addAction(19, Term.varfim, ActionType.SHIFT, 20);
    _pda.addAction(19, Term.id, ActionType.SHIFT, 21);

    _pda.addAction(20, Term.ptv, ActionType.SHIFT, 47);

    _pda.addAction(21, Term.inteiro, ActionType.SHIFT, 49);
    _pda.addAction(21, Term.real, ActionType.SHIFT, 50);
    _pda.addAction(21, Term.lit, ActionType.SHIFT, 51);

    _pda.addAction(22, Term.eof, ActionType.REDUCE, 9);
    _pda.addAction(23, Term.eof, ActionType.REDUCE, 15);
    _pda.addAction(24, Term.eof, ActionType.REDUCE, 21);
    _pda.addAction(25, Term.eof, ActionType.REDUCE, 30);

    _pda.addAction(26, Term.ptv, ActionType.SHIFT, 52);
    _pda.addAction(27, Term.ptv, ActionType.SHIFT, 53);
    _pda.addAction(28, Term.ptv, ActionType.REDUCE, 12);
    _pda.addAction(29, Term.ptv, ActionType.REDUCE, 13);
    _pda.addAction(30, Term.ptv, ActionType.REDUCE, 14);

    _pda.addAction(31, Term.id, ActionType.SHIFT, 56);
    _pda.addAction(31, Term.numerico, ActionType.SHIFT, 57);

    for (var st in [39, 40, 41, 42]) {
      _pda.addAction(st, Term.id, ActionType.SHIFT, 13);
      _pda.addAction(st, Term.leia, ActionType.SHIFT, 11);
      _pda.addAction(st, Term.escreva, ActionType.SHIFT, 12);
      _pda.addAction(st, Term.se, ActionType.SHIFT, 16);
      _pda.addAction(st, Term.fimenquanto, ActionType.SHIFT, 43);
      _pda.addAction(st, Term.enquanto, ActionType.SHIFT, 17);
    }

    for (var st in [31, 44, 45, 71, 73]) {
      _pda.addAction(st, Term.id, ActionType.SHIFT, 56);
      _pda.addAction(st, Term.numerico, ActionType.SHIFT, 57);
    }

    _pda.addAction(46, Term.id, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.leia, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.escreva, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.se, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.fimse, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.fim, ActionType.REDUCE, 3);
    _pda.addAction(46, Term.enquanto, ActionType.REDUCE, 3);

    _pda.addAction(47, Term.id, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.leia, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.escreva, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.se, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.fimse, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.fim, ActionType.REDUCE, 4);
    _pda.addAction(47, Term.enquanto, ActionType.REDUCE, 4);

    _pda.addAction(48, Term.ptv, ActionType.SHIFT, 69);
    _pda.addAction(49, Term.ptv, ActionType.REDUCE, 6);
    _pda.addAction(50, Term.ptv, ActionType.REDUCE, 7);
    _pda.addAction(51, Term.ptv, ActionType.REDUCE, 8);

    _pda.addAction(54, Term.ptv, ActionType.SHIFT, 70);

    _pda.addAction(55, Term.ptv, ActionType.REDUCE, 18);
    _pda.addAction(55, Term.opm, ActionType.SHIFT, 71);

    _pda.addAction(56, Term.ptv, ActionType.REDUCE, 19);
    _pda.addAction(56, Term.opm, ActionType.REDUCE, 19);
    _pda.addAction(56, Term.fcp, ActionType.REDUCE, 19);
    _pda.addAction(56, Term.opr, ActionType.REDUCE, 19);

    _pda.addAction(57, Term.ptv, ActionType.REDUCE, 20);
    _pda.addAction(57, Term.opm, ActionType.REDUCE, 20);
    _pda.addAction(57, Term.fcp, ActionType.REDUCE, 20);
    _pda.addAction(57, Term.opr, ActionType.REDUCE, 20);

    var m = {
      32: 22,
      36: 28,
      38: 31,
      43: 36,
      52: 10,
      53: 11,
      58: 25,
      59: 26,
      60: 27,
      61: 37,
      62: 32,
      63: 33,
      64: 34,
      65: 35,
      70: 16
    };
    m.forEach((st, red) {
      _pda.addAction(st, Term.id, ActionType.REDUCE, red);
      _pda.addAction(st, Term.leia, ActionType.REDUCE, red);
      _pda.addAction(st, Term.escreva, ActionType.REDUCE, red);
      _pda.addAction(st, Term.se, ActionType.REDUCE, red);
      _pda.addAction(st, Term.fimse, ActionType.REDUCE, red);
      _pda.addAction(st, Term.fim, ActionType.REDUCE, red);
      _pda.addAction(st, Term.fimenquanto, ActionType.REDUCE, red);
      _pda.addAction(st, Term.enquanto, ActionType.REDUCE, red);
    });

    _pda.addAction(66, Term.fcp, ActionType.SHIFT, 72);
    _pda.addAction(67, Term.opr, ActionType.SHIFT, 73);
    _pda.addAction(68, Term.fcp, ActionType.SHIFT, 74);
    _pda.addAction(69, Term.varfim, ActionType.REDUCE, 5);
    _pda.addAction(69, Term.id, ActionType.REDUCE, 5);
    _pda.addAction(72, Term.entao, ActionType.SHIFT, 76);
    _pda.addAction(74, Term.faca, ActionType.SHIFT, 78);
    _pda.addAction(75, Term.ptv, ActionType.REDUCE, 17);
    _pda.addAction(77, Term.fcp, ActionType.REDUCE, 24);

    m = {76: 23, 78: 38};
    m.forEach((st, red) {
      _pda.addAction(st, Term.id, ActionType.REDUCE, red);
      _pda.addAction(st, Term.leia, ActionType.REDUCE, red);
      _pda.addAction(st, Term.escreva, ActionType.REDUCE, red);
      _pda.addAction(st, Term.se, ActionType.REDUCE, red);
      _pda.addAction(st, Term.fim, ActionType.REDUCE, red);
      _pda.addAction(st, Term.enquanto, ActionType.REDUCE, red);
    });

    _pda.addAction(76, Term.fimse, ActionType.REDUCE, 23);
    _pda.addAction(78, Term.fimenquanto, ActionType.REDUCE, 38);

    _pda.addGoto(0, 'P', 1);
    _pda.addGoto(2, 'V', 3);
    _pda.addGoto(3, 'A', 5);
    _pda.addGoto(3, 'ES', 6);
    _pda.addGoto(3, 'CMD', 7);
    _pda.addGoto(3, 'COND', 8);
    _pda.addGoto(3, 'CAB', 14);
    _pda.addGoto(3, 'REP', 10);
    _pda.addGoto(3, 'REPCAB', 15);
    _pda.addGoto(4, 'LV', 18);
    _pda.addGoto(4, 'D', 19);
    _pda.addGoto(6, 'A', 22);
    _pda.addGoto(6, 'ES', 6);
    _pda.addGoto(6, 'CMD', 7);
    _pda.addGoto(6, 'COND', 8);
    _pda.addGoto(6, 'CAB', 14);
    _pda.addGoto(6, 'REP', 10);
    _pda.addGoto(6, 'REPCAB', 15);
    _pda.addGoto(7, 'A', 23);
    _pda.addGoto(7, 'ES', 6);
    _pda.addGoto(7, 'CMD', 7);
    _pda.addGoto(7, 'COND', 8);
    _pda.addGoto(7, 'CAB', 14);
    _pda.addGoto(7, 'REP', 10);
    _pda.addGoto(7, 'REPCAB', 15);
    _pda.addGoto(8, 'A', 24);
    _pda.addGoto(8, 'ES', 6);
    _pda.addGoto(8, 'CMD', 7);
    _pda.addGoto(8, 'COND', 8);
    _pda.addGoto(8, 'CAB', 14);
    _pda.addGoto(8, 'REP', 10);
    _pda.addGoto(8, 'REPCAB', 15);
    _pda.addGoto(10, 'A', 25);
    _pda.addGoto(10, 'ES', 6);
    _pda.addGoto(10, 'CMD', 7);
    _pda.addGoto(10, 'COND', 8);
    _pda.addGoto(10, 'CAB', 14);
    _pda.addGoto(10, 'REP', 10);
    _pda.addGoto(10, 'REPCAB', 15);
    _pda.addGoto(12, 'ARG', 27);
    _pda.addGoto(14, 'ES', 33);
    _pda.addGoto(14, 'CMD', 34);
    _pda.addGoto(14, 'COND', 35);
    _pda.addGoto(14, 'CAB', 14);
    _pda.addGoto(14, 'CORPO', 32);
    _pda.addGoto(14, 'REP', 37);
    _pda.addGoto(14, 'REPCAB', 15);
    _pda.addGoto(15, 'ES', 39);
    _pda.addGoto(15, 'CMD', 40);
    _pda.addGoto(15, 'COND', 41);
    _pda.addGoto(15, 'CAB', 14);
    _pda.addGoto(15, 'REP', 42);
    _pda.addGoto(15, 'REPCORPO', 38);
    _pda.addGoto(15, 'REPCAB', 15);
    _pda.addGoto(19, 'LV', 46);
    _pda.addGoto(19, 'D', 19);
    _pda.addGoto(21, 'TIPO', 48);
    _pda.addGoto(31, 'LD', 54);
    _pda.addGoto(31, 'OPRD', 55);
    _pda.addGoto(33, 'ES', 33);
    _pda.addGoto(33, 'CMD', 34);
    _pda.addGoto(33, 'COND', 35);
    _pda.addGoto(33, 'CAB', 14);
    _pda.addGoto(33, 'CORPO', 58);
    _pda.addGoto(33, 'REP', 37);
    _pda.addGoto(33, 'REPCAB', 15);
    _pda.addGoto(34, 'ES', 33);
    _pda.addGoto(34, 'CMD', 34);
    _pda.addGoto(34, 'COND', 35);
    _pda.addGoto(34, 'CAB', 14);
    _pda.addGoto(34, 'CORPO', 59);
    _pda.addGoto(34, 'REP', 37);
    _pda.addGoto(34, 'REPCAB', 15);
    _pda.addGoto(35, 'ES', 33);
    _pda.addGoto(35, 'CMD', 34);
    _pda.addGoto(35, 'COND', 35);
    _pda.addGoto(35, 'CAB', 14);
    _pda.addGoto(35, 'CORPO', 60);
    _pda.addGoto(35, 'REP', 37);
    _pda.addGoto(35, 'REPCAB', 15);
    _pda.addGoto(37, 'ES', 33);
    _pda.addGoto(37, 'CMD', 34);
    _pda.addGoto(37, 'COND', 35);
    _pda.addGoto(37, 'CAB', 14);
    _pda.addGoto(37, 'CORPO', 61);
    _pda.addGoto(37, 'REP', 37);
    _pda.addGoto(37, 'REPCAB', 15);

    _pda.addGoto(44, 'OPRD', 67);
    _pda.addGoto(44, 'EXP_R', 66);
    _pda.addGoto(45, 'OPRD', 67);
    _pda.addGoto(45, 'EXP_R', 68);
    _pda.addGoto(71, 'OPRD', 75);
    _pda.addGoto(73, 'OPRD', 77);

    for (var st in [39, 40, 41, 42]) {
      _pda.addGoto(st, 'ES', 39);
      _pda.addGoto(st, 'CMD', 40);
      _pda.addGoto(st, 'COND', 41);
      _pda.addGoto(st, 'CAB', 14);
      _pda.addGoto(st, 'REP', 42);
      _pda.addGoto(st, 'REPCAB', 15);
    }
    _pda.addGoto(39, 'REPCORPO', 62);
    _pda.addGoto(40, 'REPCORPO', 63);
    _pda.addGoto(41, 'REPCORPO', 64);
    _pda.addGoto(42, 'REPCORPO', 65);

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
    _pda.addReduction(17, 38, 1);
    _pda.addReduction(18, 2, 2);
    _pda.addReduction(19, 3, 1);
    _pda.addReduction(20, 4, 1);
    _pda.addReduction(21, 5, 1);
    _pda.addReduction(22, 9, 2);
    _pda.addReduction(23, 15, 2);
    _pda.addReduction(24, 21, 2);
    _pda.addReduction(25, 30, 2);
    _pda.addReduction(26, 10, 2);
    _pda.addReduction(27, 11, 2);
    _pda.addReduction(28, 12, 1);
    _pda.addReduction(29, 13, 1);
    _pda.addReduction(30, 14, 1);
    _pda.addReduction(31, 16, 2);
    _pda.addReduction(32, 22, 2);
    _pda.addReduction(33, 25, 1);
    _pda.addReduction(34, 26, 1);
    _pda.addReduction(35, 27, 1);
    _pda.addReduction(36, 28, 1);
    _pda.addReduction(37, 37, 1);
    _pda.addReduction(38, 31, 2);
    _pda.addReduction(39, 32, 1);
    _pda.addReduction(40, 33, 1);
    _pda.addReduction(41, 34, 1);
    _pda.addReduction(42, 35, 1);
    _pda.addReduction(43, 36, 1);
    _pda.addReduction(44, 23, 2);
    _pda.addReduction(45, 38, 2);
    _pda.addReduction(46, 3, 2);
    _pda.addReduction(47, 4, 2);
    _pda.addReduction(48, 5, 2);
    _pda.addReduction(49, 6, 1);
    _pda.addReduction(50, 7, 1);
    _pda.addReduction(51, 8, 1);
    _pda.addReduction(52, 10, 3);
    _pda.addReduction(53, 11, 3);
    _pda.addReduction(54, 16, 3);
    _pda.addReduction(55, 18, 1);
    _pda.addReduction(56, 19, 1);
    _pda.addReduction(57, 20, 1);
    _pda.addReduction(58, 25, 2);
    _pda.addReduction(59, 26, 2);
    _pda.addReduction(60, 27, 2);
    _pda.addReduction(61, 37, 2);
    _pda.addReduction(62, 32, 2);
    _pda.addReduction(63, 33, 2);
    _pda.addReduction(64, 34, 2);
    _pda.addReduction(65, 35, 2);
    _pda.addReduction(66, 23, 3);
    _pda.addReduction(67, 24, 1);
    _pda.addReduction(68, 38, 3);
    _pda.addReduction(69, 5, 3);
    _pda.addReduction(70, 16, 4);
    _pda.addReduction(71, 17, 2);
    _pda.addReduction(72, 23, 4);
    _pda.addReduction(73, 24, 2);
    _pda.addReduction(74, 38, 4);
    _pda.addReduction(75, 17, 3);
    _pda.addReduction(76, 23, 5);
    _pda.addReduction(77, 24, 3);
    _pda.addReduction(78, 38, 5);
  }
}
