import 'Pair.dart';
import 'Token.dart';
import 'dart:collection';

enum ActionType {
  SHIFT,
  REDUCE,
  ACCEPT,
}

class Pda {
  Map<Pair<int, String>, Action> _action;
  Map<Pair<int, String>, int> _goto;
  int _state;
  Queue<int> _stack;

  Pda() {
    _action = HashMap<Pair<int, String>, Action>();
    _goto = HashMap<Pair<int, String>, int>();
    _state = 0;
    _stack = ListQueue();
  }

  Action getAction(Token token) {
    return _action[Pair(_state, token.token)];
  }

  void shift(int state) {
    this._stack.addLast(state);
  }

  void reduce(int reduction) {}
}

class Action {
  ActionType type;
  int param; // state or reduction
}
