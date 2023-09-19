// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/widgets/loader.overlay.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlay = const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    );
    if (kReleaseMode) {
      return buildWrapper(overlay, context);
    } else {
      return buildWrapperWithBanner(overlay, context);
    }
  }

  Widget buildWrapperWithBanner(
    SystemUiOverlayStyle overlay,
    BuildContext context,
  ) {
    return Stack(
      children: [
        buildWrapper(overlay, context),
        buildBanner(context),
      ],
    );
  }

  Widget buildBanner(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: CustomPaint(
        painter: BannerPainter(
          message: 'Debug',
          color: Theme.of(context).colorScheme.errorContainer,
          textStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.error),
          location: BannerLocation.bottomEnd,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
        ),
      ),
    );
  }

  Widget buildWrapper(SystemUiOverlayStyle overlay, BuildContext context) {
    final widget = LoadingOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    return kIsWeb ? widget : AppLocalAuth(child: widget);
  }
}
