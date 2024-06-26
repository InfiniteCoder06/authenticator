// 📦 Package imports:
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/enums/sort.enum.dart';
import 'package:authenticator/provider.dart';

part 'home.controller.g.dart';

final entriesProvider = StateProvider((_) => <Item>[]);
final sortProvider = StateProvider((_) => Sort.date);
final errorProvider = StateProvider((_) => '');
final showSearchProvider = StateProvider.autoDispose(
    (ref) => ref.watch(behaviorControllerProvider).searchOnStart);

@riverpod
Future<void> getAllItem(GetAllItemRef ref) async {
  try {
    final items = await ref.read(entryRepoProvider).getFiltered();

    final sortOrder = ref.watch(sortProvider);
    switch (sortOrder) {
      case Sort.name:
        items.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case Sort.date:
        items.sort();
      case Sort.issuer:
        items.sort((a, b) {
          // Handle null issuers by placing them at the end
          if (a.issuer.isEmpty && b.issuer.isNotEmpty) {
            return 1;
          } else if (a.issuer.isNotEmpty && b.issuer.isEmpty) {
            return -1;
          }

          // If both have issuers (or neither do), sort by issuer first
          if (a.issuer.isNotEmpty) {
            int issuerComparison = a.issuer.compareTo(b.issuer);
            if (issuerComparison != 0) return issuerComparison;
          }

          // Finally, sort by name
          return a.name.compareTo(b.name);
        });
    }
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
