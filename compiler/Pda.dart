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

  int _state;
  Queue<int> _stack;

  Pda() {
    _actions = HashMap<Pair<int, String>, Action>();
    _gotos = HashMap<Pair<int, String>, int>();
    _productions = HashMap<int, Production>();
    _reductions = HashMap<int, Reduction>();
    _state = 0;
    _stack = ListQueue();
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

  Action getAction(Token token) {
    return _actions[Pair(_state, token.token)];
  }

  void shift(int state) {
    this._stack.addLast(state);
  }

  void reduce(int reductionIndex) {
    Reduction reduction = _reductions[reductionIndex];
    assert(reduction != null);

    for (var i = 0; i < reduction.count; i++) {
      assert(!this._stack.isEmpty);
      this._stack.removeLast();
    }

    var top = this._stack.last;
    var prodIndex = reduction.prodIndex;
    var newState = _gotos[Pair(top, _productions[prodIndex].left)];
    assert(newState != null);
    this._stack.addLast(newState);

    print(_productions[prodIndex]);
  }
}
