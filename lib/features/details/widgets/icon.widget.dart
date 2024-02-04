// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/core/utils/extension/color_scheme.extension.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/features/details/detail.controller.dart';

class ItemIcon extends HookConsumerWidget {
  const ItemIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(detailController);
    final icon = controller.originalItem.toNullable()!.getIcon();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: ShapeConstant.medium,
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
              decoration: BoxDecoration(borderRadius: ShapeConstant.medium),
              child: Material(
                borderRadius: ShapeConstant.medium,
                color: Theme.of(context).colorScheme.elevation.surface3,
                child: InkWell(
                  borderRadius: ShapeConstant.medium,
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
            borderRadius: ShapeConstant.medium,
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
