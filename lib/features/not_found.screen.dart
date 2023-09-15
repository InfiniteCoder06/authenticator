// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: AppPopButton.wrapper(context),
        title: const Text('404'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Not found"),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.home.path, (route) => false);
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text("Go Home"),
            ),
          ],
        ),
      ),
    );
  }
}
