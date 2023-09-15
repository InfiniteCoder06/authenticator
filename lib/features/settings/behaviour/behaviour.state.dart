part of 'behaviour.controller.dart';

class BehaviorState extends Equatable {
  final bool copyOnTap;
  final int fontSize;
  final int codeGroup;

  const BehaviorState({
    required this.copyOnTap,
    required this.fontSize,
    required this.codeGroup,
  });

  factory BehaviorState.initial() =>
      const BehaviorState(copyOnTap: true, fontSize: 25, codeGroup: 3);

  @override
  List<Object?> get props => [copyOnTap, fontSize, codeGroup];

  BehaviorState copyWith({
    bool? copyOnTap,
    int? fontSize,
    int? codeGroup,
  }) {
    return BehaviorState(
      copyOnTap: copyOnTap ?? this.copyOnTap,
      fontSize: fontSize ?? this.fontSize,
      codeGroup: codeGroup ?? this.codeGroup,
    );
  }

  @override
  bool get stringify => true;
}
