// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';

class ItemAvatar extends StatelessWidget {
  const ItemAvatar({
    super.key,
    required this.item,
    this.onAvatarPress,
    this.selected = true,
  });
  final Item item;
  final bool selected;
  final void Function()? onAvatarPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAvatarPress,
      borderRadius: ShapeConstant.full,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Stack(
          children: <Widget>[
            Builder(
              builder: (context) {
                final icon = item.getIcon();
                return icon.fold(() {
                  return CircleAvatar(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    child: Text(
                      item.name[0].toUpperCase(),
                    ),
                  );
                }, (icon) {
                  return CircleAvatar(
                    backgroundImage: Image.memory(icon).image,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  );
                });
              },
            ),
            AnimatedScale(
              scale: selected ? 1.01 : 0.0,
              duration: Durations.medium2,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
                child: Icon(
                  Icons.done_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
