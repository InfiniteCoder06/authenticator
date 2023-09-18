// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/provider.dart';

class AppDialogs {
  static Future<void> showDeletionDialog(
      BuildContext context, List<Item> items) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_rounded),
          title: const Text('Delete'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 560, maxWidth: 560),
            width: MediaQuery.of(context).size.width - 96,
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Are you sure you want to delete this entry?"),
                const Text("This action does not disable 2FA for"),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Item item = items.elementAt(index);
                      final issuer = item.getIssuer();
                      return Text(
                        "\u2022 ${issuer.isNone() ? item.name : "${issuer.toNullable()} (${item.name})"}",
                      );
                    },
                  ),
                ),
                const Text(
                  "To prevent losing access, make sure that you have disabled 2FA or that you have an alternative way to generate codes for this service.",
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                context.ref.read(hiveEntryRepoProvider).fakeDeleteAll(items);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showErrorDialog(
      BuildContext context, String errorMessage) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error_rounded),
          title: const Text("Error"),
          content: Text(errorMessage),
        );
      },
    );
  }

  static Future<String> showManualURIDialog(BuildContext context) async {
    var text = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.info_rounded),
          title: const Text("Manual URI"),
          content: StatefulBuilder(builder: (state, setValue) {
            return TextField(
              onChanged: (value) => setValue(() => text = value),
              decoration: const InputDecoration(
                isDense: true,
                labelText: "Enter URI",
                border: OutlineInputBorder(),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                text = 'skip';
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
    return text;
  }
}
