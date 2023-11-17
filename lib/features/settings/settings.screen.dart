// 🐦 Flutter imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';

class SettingsOverviewPage extends StatelessWidget {
  const SettingsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  key: const Key("settings.list.account"),
                  leading: const Icon(Icons.account_circle_rounded),
                  title: const Text("Accounts"),
                  subtitle: const Text(
                    "Sync App",
                  ),
                  onTap: () {
                    if (!Platform.isAndroid && !kIsWeb) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                            const SnackBar(content: Text("To Be Implemented")));
                    } else {
                      Navigator.of(context).pushNamed(AppRouter.account.path);
                    }
                  },
                ),
                ListTile(
                  key: const Key("settings.list.theme"),
                  leading: const Icon(Icons.brush_rounded),
                  title: const Text("Appearance"),
                  subtitle: const Text(
                    "Adjust the theme, language and other settings that affect the appearance of the app.",
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.theme.path),
                ),
                ListTile(
                  key: const Key("settings.list.behaviour"),
                  leading: const Icon(Icons.touch_app_rounded),
                  title: const Text("Behaviour"),
                  subtitle: const Text(
                    "Customize the behavior when interacting with the entry list",
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.behavior.path),
                ),
                ListTile(
                  key: const Key("settings.list.security"),
                  leading: const Icon(Icons.security_rounded),
                  title: const Text("Security"),
                  subtitle: const Text("Password, Biometric, etc."),
                  onTap: () {
                    if (!Platform.isAndroid) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                            const SnackBar(content: Text("To Be Implemented")));
                    } else {
                      Navigator.of(context).pushNamed(AppRouter.security.path);
                    }
                  },
                ),
                ListTile(
                  key: const Key("settings.list.time"),
                  leading: const Icon(Icons.access_time_filled_rounded),
                  title: const Text("Time"),
                  subtitle: const Text("Correction of time"),
                  onTap: () => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("To Be Implemented"))),
                ),
                ListTile(
                  key: const Key("settings.list.logger"),
                  leading: const Icon(Icons.bug_report_rounded),
                  title: const Text("Logger"),
                  subtitle: const Text("Access Logs"),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.logger.path),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
