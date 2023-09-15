part of 'theme.controller.dart';

class ThemeState extends Equatable {
  final bool dynamicColor;
  final ThemeMode themeMode;
  final int themeAccent;

  const ThemeState({
    required this.dynamicColor,
    required this.themeAccent,
    required this.themeMode,
  });

  factory ThemeState.initial() => const ThemeState(
      dynamicColor: false, themeAccent: 3, themeMode: ThemeMode.light);

  @override
  List<Object?> get props => [dynamicColor, themeAccent, themeMode];

  ThemeState copyWith({
    bool? dynamicColor,
    ThemeMode? themeMode,
    int? themeAccent,
  }) {
    return ThemeState(
      dynamicColor: dynamicColor ?? this.dynamicColor,
      themeMode: themeMode ?? this.themeMode,
      themeAccent: themeAccent ?? this.themeAccent,
    );
  }

  @override
  bool? get stringify => true;
}
