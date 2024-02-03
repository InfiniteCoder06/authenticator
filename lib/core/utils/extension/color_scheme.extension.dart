// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/theme/m3_elevation.dart';

extension ColorSchemeExtension on ColorScheme {
  M3Elevation get elevation => M3Elevation(this, brightness == Brightness.dark);
}
