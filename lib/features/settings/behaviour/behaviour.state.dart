part of 'behaviour.controller.dart';

class BehaviorState extends Equatable {
  const BehaviorState({
    required this.copyOnTap,
    required this.searchOnStart,
    required this.fontSize,
    required this.codeGroup,
  });

  factory BehaviorState.initial() => const BehaviorState(
      copyOnTap: true, searchOnStart: false, fontSize: 25, codeGroup: 3);

  final bool copyOnTap;
  final bool searchOnStart;
  final int fontSize;
  final int codeGroup;

  @override
  List<Object?> get props => [copyOnTap, searchOnStart, fontSize, codeGroup];

  BehaviorState copyWith({
    bool? copyOnTap,
    bool? searchOnStart,
    int? fontSize,
    int? codeGroup,
  }) {
    return BehaviorState(
      copyOnTap: copyOnTap ?? this.copyOnTap,
      searchOnStart: searchOnStart ?? this.searchOnStart,
      fontSize: fontSize ?? this.fontSize,
      codeGroup: codeGroup ?? this.codeGroup,
    );
  }

  @override
  bool get stringify => true;
}
