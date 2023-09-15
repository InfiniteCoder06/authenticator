// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';

class ItemBody extends StatelessWidget {
  const ItemBody(this.item, {super.key});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      scrollDirection: Axis.horizontal,
      child: Builder(
        builder: (context) {
          final issuer = item.getIssuer();
          return Row(
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (issuer.isSome())
                Text(
                  " (${issuer.toNullable()})",
                  overflow: TextOverflow.ellipsis,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                )
            ],
          );
        },
      ),
    );
  }
}
