part of 'detail.controller.dart';

class DetailState extends Equatable {
  final Option<Item> originalItem;

  const DetailState({
    required this.originalItem,
  });

  factory DetailState.initial() =>
      DetailState(originalItem: none());

  DetailState copyWith({
    Option<Item>? originalItem,
  }) {
    return DetailState(
      originalItem: originalItem ?? this.originalItem,
    );
  }

  @override
  List<Object?> get props => [originalItem];

  @override
  bool? get stringify => true;
}
