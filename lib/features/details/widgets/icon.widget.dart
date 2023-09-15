// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/extension/color_scheme.extension.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/details/detail.controller.dart';

class ItemIcon extends StatelessWidget {
  const ItemIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ref.watch(detailController);
    final icon = controller.originalItem.toNullable()!.getIcon();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: Shape.medium,
        child: icon.fold(() {
          return DottedBorder(
            radius: const Radius.circular(12),
            borderType: BorderType.RRect,
            strokeWidth: 3,
            color: Theme.of(context).colorScheme.primaryContainer,
            dashPattern: const [10, 5],
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: Shape.medium),
              child: Material(
                borderRadius: Shape.medium,
                color: Theme.of(context).colorScheme.elevation.surface3,
                child: InkWell(
                  borderRadius: Shape.medium,
                  onTap: () {
                    //TODO: Implement Icon
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text("To Be Implemented")));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      const Text("Upload your icon here"),
                      const Text("Browse"),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, (icon) {
          return ClipRRect(
            borderRadius: Shape.medium,
            child: Image.memory(
              icon,
              width: 200,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
          );
        }),
      ),
    );
  }
}
