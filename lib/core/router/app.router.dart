// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

part 'app_router.gr.dart';

enum AppRouter {
  home(
    path: '/',
    title: 'Authenticator',
    subtitle: '',
    icon: Icons.home_rounded,
  ),
  details(
    path: '/details',
    title: 'Details',
    subtitle: '',
    icon: Icons.edit_rounded,
  ),
  scan(
    path: '/scan',
    title: 'QR Code Scanner',
    subtitle: '',
    icon: Icons.settings_rounded,
  ),
  transfer(
    path: '/transfer',
    title: 'Transfer',
    subtitle: '',
    icon: Icons.share_rounded,
  ),
  settings(
    path: '/settings',
    title: 'Settings',
    subtitle: '',
    icon: Icons.settings_rounded,
  ),
  theme(
    path: '/settings/theme',
    title: 'Theme',
    subtitle: 'Adjust the theme, language of the app',
    icon: Icons.brush_rounded,
  ),
  behavior(
    path: '/settings/behaviour',
    title: 'Behaviour',
    subtitle: 'Customize the behavior when interacting with the entries',
    icon: Icons.brush_rounded,
  ),
  logger(
    path: '/settings/logger',
    title: 'Log Console',
    subtitle: '',
    icon: Icons.bug_report_rounded,
  ),
  security(
    path: '/settings/security',
    title: 'Security',
    subtitle: 'Password, Biometric, etc.',
    icon: Icons.settings_rounded,
  ),
  lock(
    path: '/lock',
    title: 'App Lock',
    subtitle: '',
    icon: Icons.security_rounded,
  ),
  notFound(
    path: '/not-found',
    title: '404 Page',
    subtitle: 'The Route is not found',
    icon: Icons.close_rounded,
  );

  const AppRouter({
    required this.path,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  final String path;
  final String title;
  final String subtitle;
  final IconData? icon;
}
