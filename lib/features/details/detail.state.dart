part of 'detail.controller.dart';

class DetailState extends Equatable {
  const DetailState({
    required this.originalItem,
  });

  factory DetailState.initial() => DetailState(originalItem: none());

  final Option<Item> originalItem;

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
