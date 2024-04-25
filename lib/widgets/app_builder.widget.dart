// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/theme.constant.dart';
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/widgets/loader.overlay.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({
    super.key,
    this.child,
    this.navKey,
    required this.themeMode,
    required this.lightColorScheme,
    required this.darkColorScheme,
  });

  final Widget? child;
  final GlobalKey<NavigatorState>? navKey;
  final ThemeMode themeMode;
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  @override
  Widget build(BuildContext context) {
    final useDark = ThemeConstant.getDarkMode(context, themeMode);
    final surfaceColor =
        useDark ? darkColorScheme.surface : lightColorScheme.surface;
    SystemUiOverlayStyle overlay = SystemUiOverlayStyle(
      systemNavigationBarColor: surfaceColor,
      statusBarColor: surfaceColor,
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

  Widget buildWrapper(SystemUiOverlayStyle overlay) {
    final widget = LoadingOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    return kIsWeb
        ? widget
        : Builder(builder: (context) {
            return Theme(
              data: ThemeConstant.getDarkMode(context, themeMode)
                  ? ThemeConstant.getDarkThemeData(darkColorScheme)
                  : ThemeConstant.getLightThemeData(lightColorScheme),
              child: AppLocalAuth(navKey: navKey!, child: widget),
            );
          });
  }
}
