// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

class ItemBody extends StatelessWidget {
  const ItemBody(this.item, {super.key});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: item.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          if (item.issuer.isNotEmpty)
            TextSpan(
              text: " ( ${item.issuer} )",
              style: DefaultTextStyle.of(context).style.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
        ],
      ),
    );
  }
}
