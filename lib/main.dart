// ignore_for_file: depend_on_referenced_packages

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/router/app_router.config.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/settings/theme/theme.controller.dart';
import 'package:authenticator/provider.dart';
import 'package:authenticator/widgets/app_builder.widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }
  var container = RiverpieContainer();
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

  runApp(RiverpieScope(
    overrides: [
      appPathsProvider.overrideWithValue(appPathsOverride),
      hiveEntryRepoProvider.overrideWithValue(entryRepositoryOverride),
      hiveStorageProvider.overrideWithValue(hiveStorageOverride),
      securityStorageProvider.overrideWithValue(securityStorageOverride),
      securityServiceProvider.overrideWithValue(securityServiceOverride),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ref.watch(themeController);

    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.primaries.elementAt(controller.themeAccent),
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.primaries.elementAt(controller.themeAccent),
      brightness: Brightness.dark,
    );
    return MaterialApp(
      title: 'Authenticator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.background,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: Shape.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: Shape.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: lightColorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: lightColorScheme.background,
        splashColor: lightColorScheme.onSurface.withOpacity(0.18),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.background,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: Shape.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: Shape.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: darkColorScheme.onPrimaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: darkColorScheme.background,
        splashColor: darkColorScheme.onSurface.withOpacity(0.18),
      ),
      themeMode: controller.themeMode,
      initialRoute: AppRouter.home.path,
      builder: (context, child) => AppBuilder(child: child!),
      onGenerateRoute: (settings) =>
          AppRouteConfig(context: context, settings: settings).generate(),
      navigatorObservers: [NavigationHistoryObserver()],
    );
  }
}
