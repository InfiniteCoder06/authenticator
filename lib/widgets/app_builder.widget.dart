// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/widgets/loader.overlay.dart';

class AppBuilder extends StatefulWidget {
  const AppBuilder({
    super.key,
    this.child,
    this.navKey,
  });

  final Widget? child;
  final GlobalKey<NavigatorState>? navKey;

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlay = const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    );
    if (kReleaseMode) {
      return buildWrapper(overlay);
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
        buildWrapper(overlay),
        buildBanner(context),
      ],
    );
  }

  Widget buildBanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 0,
      right: 0,
      child: CustomPaint(
        painter: BannerPainter(
          message: 'Debug',
          color: colorScheme.errorContainer,
          textStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: colorScheme.error),
          location: BannerLocation.bottomEnd,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
        ),
      ),
    );
  }

  Widget buildWrapper(SystemUiOverlayStyle overlay) {
    final wrapper = LoadingOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: widget.child ?? const SizedBox.shrink(),
        ),
      ),
    );
    return kIsWeb
        ? wrapper
        : AppLocalAuth(navKey: widget.navKey!, child: wrapper);
  }
}
