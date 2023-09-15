part of 'home.controller.dart';

class HomeState extends Equatable {
  final List<Item> entries;
  final List<Item> selected;
  final String error;

  const HomeState({
    required this.entries,
    required this.selected,
    required this.error,
  });

  factory HomeState.initial() =>
      const HomeState(entries: [], selected: [], error: '');

  @override
  List<Object?> get props => [entries, error, selected];

  HomeState copyWith({
    List<Item>? entries,
    List<Item>? selected,
    String? error,
  }) {
    return HomeState(
      entries: entries ?? this.entries,
      selected: selected ?? this.selected,
      error: error ?? this.error,
    );
  }

  @override
  bool? get stringify => true;
}
