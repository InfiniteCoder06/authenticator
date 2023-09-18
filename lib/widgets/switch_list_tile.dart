// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class MaterialSwitchListTile extends StatelessWidget {
  const MaterialSwitchListTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
    super.key,
    this.shape,
    this.isThreeLine = false,
  });
  final Widget title;
  final Widget subtitle;
  final ValueChanged<bool> onToggle;
  final bool value;
  final ShapeBorder? shape;
  final bool isThreeLine;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onToggle(!value),
      isThreeLine: isThreeLine,
      shape: Theme.of(context).listTileTheme.shape,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onToggle,
      ),
    );
  }
}
