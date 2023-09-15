// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/settings/theme/theme.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/material_list_tile.widget.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  padding: ConfigConstant.layoutPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "App Color Theme",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ConfigConstant.sizedBoxH0,
                      Text(
                        "Try another look",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                            ),
                      ),
                      ConfigConstant.sizedBoxH0,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: Colors.primaries
                              .mapWithIndex(
                                (color, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 2.5,
                                  ),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: Shape.large,
                                    ),
                                    shadowColor: Colors.transparent,
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: InkWell(
                                        borderRadius: Shape.large,
                                        onTap: () => context.ref
                                            .notifier(themeController)
                                            .setAccent(index),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: CircleAvatar(
                                            backgroundColor: color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final themeMode = context.ref.watch(themeController
                              .select((state) => state.themeMode));
                          return Column(
                            children: [
                              SegmentedButton<ThemeMode>(
                                segments: const [
                                  ButtonSegment(
                                    icon: Icon(Icons.laptop_rounded),
                                    value: ThemeMode.system,
                                    label: Text("System"),
                                  ),
                                  ButtonSegment(
                                    icon: Icon(Icons.light_mode_rounded),
                                    value: ThemeMode.light,
                                    label: Text("Light"),
                                  ),
                                  ButtonSegment(
                                    icon: Icon(Icons.dark_mode_rounded),
                                    value: ThemeMode.dark,
                                    label: Text("Dark"),
                                  ),
                                ],
                                onSelectionChanged: (themeMode) => context.ref
                                    .notifier(themeController)
                                    .toggleThemeMode(themeMode.first),
                                selected: {themeMode},
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final dynamicColor = context.ref.watch(
                        themeController.select((state) => state.dynamicColor));
                    return MaterialSwitchListTile(
                      title: const Text("Dynamic Color"),
                      subtitle:
                          const Text("Use Accent Color from System/ Wallpaper"),
                      value: dynamicColor,
                      onToggle: (bool value) => context.ref
                          .notifier(themeController)
                          .setDynamicColor(value),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
