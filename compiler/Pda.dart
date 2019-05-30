import '../misc/Pair.dart';
import 'Token.dart';
import 'dart:collection';

enum ActionType {
  SHIFT,
  REDUCE,
  ACCEPT,
}

class Action {
  ActionType type;
  int param; // state or reduction

  Action(this.type, this.param);

  String toString() => "${this.type}, ${this.param}";
}

class Production {
  String left;
  String right;

  Production(this.left, this.right);

  String toString() => '${this.left} -> ${this.right}';
}

class Reduction {
  int prodIndex; // index of production
  int count; // number of pops in stack

  Reduction(this.prodIndex, this.count);
}

class Pda {
  Map<Pair<int, String>, Action> _actions;
  Map<Pair<int, String>, int> _gotos;
  Map<int, Production> _productions;
  Map<int, Reduction> _reductions;
  Map<String, List<String>> _follow;
  List<String> _panicExpected;

  Queue<int> _stack;

  Pda() {
    _actions = HashMap<Pair<int, String>, Action>();
    _gotos = HashMap<Pair<int, String>, int>();
    _productions = HashMap<int, Production>();
    _reductions = HashMap<int, Reduction>();
    _stack = ListQueue();
    _stack.addLast(0);
    _follow = HashMap<String, List<String>>();
    _panicExpected = List<String>();
  }

  void addProduction(int index, String left, String right) {
    _productions[index] = Production(left, right);
  }

  void addAction(int state, String terminal, ActionType type, int param) {
    _actions[Pair(state, terminal)] = Action(type, param);
  }

  void addGoto(int state, String nonTerminal, int newState) {
    _gotos[Pair(state, nonTerminal)] = newState;
  }

  void addReduction(int index, int prodIndex, int count) {
    _reductions[index] = Reduction(prodIndex, count);
  }

  void addFollow(String nonterminal, List<String> follow) {
    _follow[nonterminal] = follow;
  }

  ActionType run(Token token) {
    if (!_panicExpected.isEmpty) {
      if (!_panicExpected.contains(token.token)) {
        // em modo panico
        // descarta simbolos que não estão no seguinte
        // da regra atual
        return ActionType.SHIFT;
      }

      // token pertence ao seguinte da regra, continuando...
      _panicExpected.clear();
    }

    assert(!this._stack.isEmpty);
    var state = this._stack.last;
    var action = _actions[Pair(state, token.token)];

    runAction(action);

    return action.type;
  }

  void runAction(Action action) {
    if (action == null) {
      this.error();
    } else if (action.type == ActionType.SHIFT) {
      this.shift(action.param);
    } else if (action.type == ActionType.REDUCE) {
      this.reduce();
    }
  }

  void shift(int state) {
    this._stack.addLast(state);
  }

  void reduce() {
    assert(!this._stack.isEmpty);

    var state = this._stack.last;
    Reduction reduction = _reductions[state];

    assert(reduction != null);

    for (var i = 0; i < reduction.count; i++) {
      assert(!this._stack.isEmpty);

      this._stack.removeLast();
    }

    state = this._stack.last;
    var prodIndex = reduction.prodIndex;
    var newState = _gotos[Pair(state, _productions[prodIndex].left)];

    assert(newState != null);

    this._stack.addLast(newState);

    print(_productions[prodIndex]);
  }

  void error() {
    assert(!this._stack.isEmpty);
    var currState = this._stack.last;

    List<String> terminals = [];
    for (var x in _actions.keys) {
      if (x.first == currState) {
        terminals.add(x.second);
      }
    }

    if (terminals.length == 1) {
      var action = _actions[Pair(currState, terminals[0])];
      assert(action != null);

      this.runAction(action);
    } else {
      var prodIndex = _reductions[currState].prodIndex;
      var prodLeft = _productions[prodIndex].left;
      this._panicExpected.addAll(_follow[prodLeft] ?? []);

      this.reduce();
    }

    var output = terminals.join(', ');
    throw 'Erro sintático: token não esperado. Esperado ($output)';
  }
}
