// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/provider.dart';

class AppDialogs {
  static Future<bool> showDeletionDialog(
      BuildContext context, List<Item> items, WidgetRef ref) async {
    return await showDialog(
          context: context,
          routeSettings: const RouteSettings(name: 'DeletionDialog'),
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.delete_rounded),
              title: const Text('Delete'),
              content: Container(
                constraints:
                    const BoxConstraints(maxHeight: 560, maxWidth: 560),
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
                            "\u2022 ${issuer.isNone() ? item.name : "${issuer.toNullable()} ( ${item.name} )"}",
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
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await ref.read(entryRepoProvider).fakeDeleteAll(items);
                    if (!context.mounted) return;
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<void> showErrorDialog(BuildContext context, String errorMessage,
      {String? title}) async {
    return showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'ErrorDialog'),
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error_rounded),
          title: title == null ? const Text("Error") : Text(title),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Ok"),
            )
          ],
        );
      },
    );
  }

  static Future<String> showSelectIssuerDialog(
      BuildContext context, List<String?> issuers) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: 'SelectIssuerDialog'),
      builder: (context) {
        return SimpleDialog(
          title: const Text("Select Issuer"),
          children: issuers
              .map((issuer) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop(issuer);
                    },
                    child: Text(issuer ?? ""),
                  ))
              .toList(),
        );
      },
    );
  }

  static Future<String> showManualURIDialog(BuildContext context) async {
    var text = '';
    await showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'ManualURIDialog'),
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
