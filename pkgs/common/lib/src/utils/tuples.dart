class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);

  Pair copyWith({
    A? first,
    B? second,
  }) {
    return Pair(
      first ?? this.first,
      second ?? this.second,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}

class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;

  Triple(this.first, this.second, this.third);

  Triple copyWith({
    A? first,
    B? second,
    C? third,
  }) {
    return Triple(
      first ?? this.first,
      second ?? this.second,
      third ?? this.third,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Triple &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;

  @override
  String toString() {
    return 'Triple{first: $first, second: $second, third: $third}';
  }
}
