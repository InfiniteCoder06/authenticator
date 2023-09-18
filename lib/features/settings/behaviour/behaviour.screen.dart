// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/switch_list_tile.dart';

class BehaviourSettingsPage extends StatelessWidget {
  const BehaviourSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Builder(builder: (context) {
                  final copyOnTap = context.ref.watch(
                      behaviorController.select((state) => state.copyOnTap));
                  return MaterialSwitchListTile(
                    title: const Text("Copy tokens when tapped"),
                    subtitle: const Text(
                      "Copy tokens to the clipboard by tapping them",
                    ),
                    value: copyOnTap,
                    onToggle: (value) async => context.ref
                        .notifier(behaviorController)
                        .toggleCopyOnTap(value),
                  );
                }),
                const ListTile(
                  title: Text("Font Size"),
                  subtitle: Text(
                    "Change the font size of OTP",
                  ),
                ),
                Builder(builder: (context) {
                  final fontSize = context.ref.watch(
                      behaviorController.select((state) => state.fontSize));
                  return Slider(
                    min: 20,
                    max: 30,
                    divisions: 10,
                    value: fontSize.toDouble(),
                    label: fontSize.toString(),
                    onChanged: (value) => context.ref
                        .notifier(behaviorController)
                        .setFontSize(value.toInt()),
                  );
                }),
                const ListTile(
                  title: Text("Code digit grouping"),
                  subtitle: Text(
                    "Select number of digits to group codes by",
                  ),
                ),
                Builder(builder: (context) {
                  final codeGroup = context.ref.watch(
                      behaviorController.select((state) => state.codeGroup));
                  return Slider(
                    min: 2,
                    max: 6,
                    divisions: 4,
                    value: codeGroup.toDouble(),
                    label: codeGroup.toString(),
                    onChanged: (value) => context.ref
                        .notifier(behaviorController)
                        .setCodeGroup(value.toInt()),
                  );
                }),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FakeEntry(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FakeEntry extends StatelessWidget {
  const FakeEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.ref.watch(behaviorController);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Card(
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: Shape.extraLarge,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    child: const Text('T'),
                  )),
              ConfigConstant.sizedBoxW1,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      clipBehavior: Clip.antiAlias,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            'Test',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            " (Issuer)",
                            overflow: TextOverflow.ellipsis,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'Poppins',
                            fontSize: state.fontSize.toDouble(),
                            fontWeight: FontWeight.w900,
                          ),
                      duration: Durations.short3,
                      child: Text(
                        StringUtils.addCharAtPosition(
                          "123456",
                          " ",
                          state.codeGroup,
                          repeat: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
