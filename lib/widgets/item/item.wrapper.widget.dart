// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ItemWidgetWrapper extends StatelessWidget {
  const ItemWidgetWrapper(this.body, {super.key, this.otp, this.trailing});
  final Widget body;
  final Widget? otp;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          body,
          otp ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
