// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

class ItemBody extends StatelessWidget {
  const ItemBody(this.item, {super.key});
  final Item item;

  @override
  Widget build(BuildContext context) {
    final isEmptyIssuer = item.issuer.isEmpty;
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (isEmptyIssuer) ...[
            TextSpan(
              text: item.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          if (!isEmptyIssuer) ...[
            TextSpan(
              text: item.issuer,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: " ( ${item.name} )",
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            )
          ],
        ],
      ),
    );
  }
}
