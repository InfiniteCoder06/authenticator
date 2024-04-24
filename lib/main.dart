// ignore_for_file: depend_on_referenced_packages

// 🐦 Flutter imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/router/app_router.config.dart';
import 'package:authenticator/core/utils/constants/theme.constant.dart';
import 'package:authenticator/features/settings/theme/theme.controller.dart';
import 'package:authenticator/firebase_options.dart';
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
  final entryRepositoryOverride = container.read(hiveEntryRepoProvider);
  final hiveStorageOverride = container.read(hiveStorageProvider);
  final securityStorageOverride = container.read(securityStorageProvider);

  await appPathsOverride.init();
  if (!kIsWeb) {
    await securityServiceOverride.initialize();
  }
  await entryRepositoryOverride.init();
  await hiveStorageOverride.init();
  await securityStorageOverride.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}

class MyApp extends HookConsumerWidget {
  MyApp({super.key});

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
        final lightColorScheme =
            useDynamic ? lightDynamic ?? lightStaticScheme : lightStaticScheme;
        final darkColorScheme =
            useDynamic ? darkDynamic ?? darkStaticScheme : darkStaticScheme;
        return MaterialApp(
          title: 'Authenticator',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigator,
          theme: ThemeConstant.getLightThemeData(lightColorScheme),
          darkTheme: ThemeConstant.getDarkThemeData(darkColorScheme),
          themeMode: controller.themeMode,
          initialRoute: AppRouter.home.path,
          builder: (_, child) => AppBuilder(
            navKey: _navigator,
            themeMode: controller.themeMode,
            lightColorScheme: lightColorScheme,
            darkColorScheme: darkColorScheme,
            child: child!,
          ),
          onGenerateRoute: (settings) =>
              AppRouteConfig(context: context, settings: settings).generate(),
          navigatorObservers: [NavigationHistoryObserver()],
        );
      },
    );
  }
}
