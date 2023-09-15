// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/shape.util.dart';

class AddField extends StatelessWidget {
  const AddField({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: Shape.small,
      ),
      title: const Text('Add new field'),
      leading: const Padding(
        padding: EdgeInsets.all(12),
        child: Icon(Icons.add_rounded),
      ),
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("To Be Implemented"))),
    );
  }
}
