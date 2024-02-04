// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/shape.constant.dart';

class MaterialDropDownListTile extends StatelessWidget {
  const MaterialDropDownListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
    this.isThreeLine = false,
  });
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final void Function(String?)? onChanged;
  final String value;
  final bool isThreeLine;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: isThreeLine,
      shape: Theme.of(context).listTileTheme.shape,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: DropdownButton<String>(
        value: value,
        borderRadius: ShapeConstant.small,
        padding: const EdgeInsets.all(8.0),
        underline: Container(),
        items: const [
          DropdownMenuItem(
            value: "Praveen",
            child: Text("Praveen"),
          ),
          DropdownMenuItem(
            value: "Ravindra",
            child: Text("Ravindra"),
          ),
          DropdownMenuItem(
            value: "Anonymous",
            child: Text("Anonymous"),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
