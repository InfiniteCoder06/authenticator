// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ItemWidgetWrapper extends StatelessWidget {
  const ItemWidgetWrapper(this.body, {super.key, this.otp});
  final Widget body;
  final Widget? otp;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          body,
          otp ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
