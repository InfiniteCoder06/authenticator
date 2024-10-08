// ignore_for_file: depend_on_referenced_packages

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:authenticator_core/firebase_options.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/router/app_router.config.dart';
import 'package:authenticator/core/utils/constants/theme.constant.dart';
import 'package:authenticator/core/utils/route_observer.util.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';
import 'package:authenticator/features/settings/theme/theme.controller.dart';
import 'package:authenticator/modules.dart';
import 'package:authenticator/provider.dart';
import 'package:authenticator/widgets/app_builder.widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var container = ProviderContainer();
  final appPathsOverride = container.read(appPathsProvider);
  final securityServiceOverride = container.read(securityServiceProvider);
  final entryRepositoryOverride = container.read(entryRepoProvider);
  final hiveStorageOverride = container.read(hiveStorageProvider);
  final securityStorageOverride = container.read(securityStorageProvider);

  await appPathsOverride.init();
  if (!kIsWeb) {
    await securityServiceOverride.initialize();
  }
  await entryRepositoryOverride.init();
  await hiveStorageOverride.init();
  await securityStorageOverride.init();

  container.read(behaviorControllerProvider);

  final (light, dark) = await getAccentColor();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(
      lightDynamicInit: light,
      darkDynamicInit: dark,
    ),
  ));
}

Future<(ColorScheme?, ColorScheme?)> getAccentColor() async {
  ColorScheme? light;
  ColorScheme? dark;
  try {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      light = corePalette.toColorScheme();
      dark = corePalette.toColorScheme(brightness: Brightness.dark);
      return (light, dark);
    }
  } finally {}

  try {
    final Color? accentColor = await DynamicColorPlugin.getAccentColor();

    if (accentColor != null) {
      light = ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.light,
      );
      dark = ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
      );
      return (light, dark);
    }
  } finally {}
  return (light, dark);
}

class MyApp extends HookConsumerWidget {
  MyApp({super.key, this.lightDynamicInit, this.darkDynamicInit});
  final ColorScheme? lightDynamicInit;
  final ColorScheme? darkDynamicInit;

  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);
    final useDynamic = controller.dynamicColor;

    final lightStaticScheme = ColorScheme.fromSeed(
      seedColor: Colors.primaries.elementAt(controller.themeAccent),
    );

    final darkStaticScheme = ColorScheme.fromSeed(
      seedColor: Colors.primaries.elementAt(controller.themeAccent),
      brightness: Brightness.dark,
    );
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final lightColorScheme = useDynamic
            ? lightDynamic ?? (lightDynamicInit ?? lightStaticScheme)
            : lightStaticScheme;
        final darkColorScheme = useDynamic
            ? darkDynamic ?? (darkDynamicInit ?? darkStaticScheme)
            : darkStaticScheme;
        return MaterialApp(
          title: 'Authenticator',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigator,
          theme: ThemeConstant.getLightThemeData(lightColorScheme),
          darkTheme: ThemeConstant.getDarkThemeData(darkColorScheme),
          themeMode: controller.themeMode,
          initialRoute: AppRouter.home.path,
          builder: (_, child) => Theme(
            data: ThemeConstant.getDarkMode(context, controller.themeMode)
                ? ThemeConstant.getDarkThemeData(darkColorScheme)
                : ThemeConstant.getLightThemeData(lightColorScheme),
            child: AppBuilder(
              navKey: _navigator,
              child: child!,
            ),
          ),
          onGenerateRoute: (settings) =>
              AppRouteConfig(context: context, settings: settings).generate(),
          navigatorObservers: [
            NavigationHistoryObserver(),
            CustomNavigatorObserver(ref: ref)
          ],
        );
      },
    );
  }
}
