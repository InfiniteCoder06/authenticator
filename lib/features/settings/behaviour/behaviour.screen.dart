// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';

class BehaviourSettingsPage extends HookConsumerWidget {
  const BehaviourSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverPadding(
            padding: ConfigConstant.layoutPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Builder(builder: (context) {
                    final copyOnTap = ref.watch(behaviorControllerProvider
                        .select((state) => state.copyOnTap));
                    return SwitchListTile(
                      title: const Text("Copy tokens when tapped"),
                      subtitle: const Text(
                        "Copy tokens to the clipboard by tapping them",
                      ),
                      value: copyOnTap,
                      onChanged: (value) async => ref
                          .read(behaviorControllerProvider.notifier)
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
                    final fontSize = ref.watch(behaviorControllerProvider
                        .select((state) => state.fontSize));
                    return Slider(
                      min: 20,
                      max: 30,
                      divisions: 10,
                      value: fontSize.toDouble(),
                      label: fontSize.toString(),
                      onChanged: (value) => ref
                          .read(behaviorControllerProvider.notifier)
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
                    final codeGroup = ref.watch(behaviorControllerProvider
                        .select((state) => state.codeGroup));
                    return Slider(
                      min: 2,
                      max: 6,
                      divisions: 4,
                      value: codeGroup.toDouble(),
                      label: codeGroup.toString(),
                      onChanged: (value) => ref
                          .read(behaviorControllerProvider.notifier)
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
          ),
        ],
      ),
    );
  }
}

class FakeEntry extends HookConsumerWidget {
  const FakeEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(behaviorControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Card(
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: ShapeConstant.extraLarge,
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
