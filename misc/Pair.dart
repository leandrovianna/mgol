class Pair<F, S> {
  F first;
  S second;

  Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is! Pair<F, S>) return false;

    return other.first == this.first && other.second == this.second;
  }
}
