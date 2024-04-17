// ignore_for_file: depend_on_referenced_packages

// 🐦 Flutter imports:
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
import 'package:authenticator/core/utils/constants/shape.constant.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);

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
          backgroundColor: lightColorScheme.surface,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: lightColorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: lightColorScheme.surface,
        splashColor: lightColorScheme.onSurface.withOpacity(0.18),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: darkColorScheme.onPrimaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: darkColorScheme.surface,
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
