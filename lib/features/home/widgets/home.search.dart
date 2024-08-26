// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';

class HomeSearchBar extends HookConsumerWidget {
  const HomeSearchBar({
    super.key,
    this.focusNode,
    required this.searchController,
  });

  final FocusNode? focusNode;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSearch = ref.watch(showSearchProvider);

    return AppCrossFade(
      duration: Durations.medium2,
      showFirst: !showSearch,
      curve: Curves.fastOutSlowIn,
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
        child: SearchBar(
          hintText: 'Search',
          controller: searchController,
          autoFocus: true,
          focusNode: focusNode,
          elevation: const WidgetStatePropertyAll(1),
          trailing: [
            IconButton(
              onPressed: () {
                ref.read(showSearchProvider.notifier).state = false;
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
