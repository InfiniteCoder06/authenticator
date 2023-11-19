// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/shape.util.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
    this.onAddQrPressed,
    this.onAddImagePressed,
    this.onAddManualPressed,
  });
  final void Function()? onAddQrPressed;
  final void Function()? onAddImagePressed;
  final void Function()? onAddManualPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Add an Account",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ConfigConstant.sizedBoxH2,
          ListTile(
            key: const Key("home.fab.add.qr"),
            onTap: onAddQrPressed,
            leading: const Icon(Icons.qr_code_scanner_rounded),
            title: const Text("Scan QR Code"),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(height: 2.0),
          ListTile(
            key: const Key("home.fab.add.image"),
            onTap: onAddImagePressed,
            leading: const Icon(Icons.add_photo_alternate_rounded),
            title: const Text("Scan Image"),
            tileColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          const SizedBox(height: 2.0),
          ListTile(
            key: const Key("home.fab.add.manual"),
            onTap: onAddManualPressed,
            leading: const Icon(Icons.edit_rounded),
            title: const Text("Enter Manually"),
            tileColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          Container(
            decoration: BoxDecoration(borderRadius: Shape.extraLarge),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                // const SizedBox(height: 2.0),
                // ColoredBox(
                //   color:
                //       Theme.of(context).colorScheme.secondaryContainer,
                //   child: ListTile(
                //     key: const Key("home.fab.add.url"),
                //     onTap: () async {
                //       Navigator.of(context).pop();
                //       await ref
                //           .read(homeControllerProvider.notifier)
                //           .showManualUri(context);
                //     },
                //     leading: const Icon(Icons.edit_rounded),
                //     title: const Text("Using URL (Advanced)"),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: Shape.full),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
