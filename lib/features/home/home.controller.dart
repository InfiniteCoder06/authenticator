// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/provider.dart';

part 'home.controller.g.dart';

final entriesProvider = StateProvider((_) => <Item>[]);
final errorProvider = StateProvider((_) => '');
final showSearchProvider = StateProvider((_) => false);

@riverpod
Future<void> getAllItem(GetAllItemRef ref) async {
  try {
    final items = await ref.read(hiveEntryRepoProvider).getFiltered();
    ref.read(entriesProvider.notifier).state = items;
  } catch (error) {
    ref.read(errorProvider.notifier).state = error.toString();
  }
}

@riverpod
List<Item> filteredItems(FilteredItemsRef ref, String searchText) {
  final items = ref.watch(entriesProvider);

  if (searchText.isEmpty) {
    return items;
  }

  return items
      .where((item) =>
          item.issuer.toLowerCase().contains(searchText.toLowerCase()) ||
          item.name.toLowerCase().contains(searchText.toLowerCase()))
      .toList();
}

@riverpod
class SelectedEntries extends _$SelectedEntries {
  @override
  List<Item> build() {
    return [];
  }

  void addSelected(Item item) => state = List.from(state)..add(item);

  void removeSelected(Item item) => state = List.from(state)..remove(item);

  void clearSelected() => state = List.empty();
}
