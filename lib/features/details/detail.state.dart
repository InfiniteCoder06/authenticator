part of 'detail.controller.dart';

class DetailState extends Equatable {
  final Option<Item> originalItem;
  final List<Field> fields;

  const DetailState({
    required this.originalItem,
    required this.fields,
  });

  factory DetailState.initial() =>
      DetailState(originalItem: none(), fields: const []);

  DetailState copyWith({
    Option<Item>? originalItem,
    List<Field>? fields,
  }) {
    return DetailState(
      originalItem: originalItem ?? this.originalItem,
      fields: fields ?? this.fields,
    );
  }

  @override
  List<Object?> get props => [originalItem, fields];

  @override
  bool? get stringify => true;
}
