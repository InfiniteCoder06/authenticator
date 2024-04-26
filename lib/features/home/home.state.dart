part of 'home.controller.dart';

class HomeState extends Equatable {
  final List<Item> entries;
  final List<Item> filteredEntries;
  final List<Item> selected;
  final bool showSearch;
  final String searchText;
  final String error;

  const HomeState({
    required this.entries,
    required this.filteredEntries,
    required this.selected,
    required this.showSearch,
    required this.searchText,
    required this.error,
  });

  factory HomeState.initial() => const HomeState(
      entries: [],
      filteredEntries: [],
      selected: [],
      showSearch: false,
      searchText: '',
      error: '');

  @override
  List<Object?> get props =>
      [entries, filteredEntries, error, showSearch, searchText, selected];

  HomeState copyWith({
    List<Item>? entries,
    List<Item>? filteredEntries,
    List<Item>? selected,
    bool? showSearch,
    String? searchText,
    String? error,
  }) {
    return HomeState(
      entries: entries ?? this.entries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selected: selected ?? this.selected,
      showSearch: showSearch ?? this.showSearch,
      searchText: searchText ?? this.searchText,
      error: error ?? this.error,
    );
  }

  @override
  bool? get stringify => true;
}
