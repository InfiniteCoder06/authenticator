// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class M3Elevation {
  final ColorScheme _color;
  final bool _isDark;
  M3Elevation(this._color, this._isDark);

  Color get getSurface {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 6 : 98));
  }

  Color get getSurfaceDim {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 6 : 87));
  }

  Color get getSurfaceBright {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 24 : 98));
  }

  Color get getSurfaceContainerLowest {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 4 : 100));
  }

  Color get getSurfaceContainerLow {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 10 : 96));
  }

  Color get getSurfaceContainer {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 12 : 94));
  }

  Color get getSurfaceContainerHigh {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 17 : 92));
  }

  Color get getSurfaceContainerHighest {
    CorePalette p = CorePalette.of(_color.primary.value);
    return Color(p.neutral.get(_isDark ? 22 : 90));
  }

  /// ```dart
  /// Elevation Primary Suface 1 - 1px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface1 {
    return _applyOverlay(_color.surface, _color.primary, 1);
  }

  /// ```dart
  /// Elevation Primary Suface 2 - 3px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface2 {
    return _applyOverlay(_color.surface, _color.primary, 3);
  }

  /// ```dart
  /// Elevation Primary Suface 3 - 6px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface3 {
    return _applyOverlay(_color.surface, _color.primary, 6);
  }

  /// ```dart
  /// Elevation Primary Suface 4 - 8px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface4 {
    return _applyOverlay(_color.surface, _color.primary, 8);
  }

  /// ```dart
  /// Elevation Primary Suface 5 - 12px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface5 {
    return _applyOverlay(_color.surface, _color.primary, 12);
  }

  /// ```dart
  /// Elevation Primary Suface 6 - 16px
  /// ```
  @Deprecated('Use updated colorScheme roles')
  Color? get surface6 {
    return _applyOverlay(_color.surface, _color.primary, 16);
  }

  Color? get black => const Color(0xFF000000);
  Color? get white => const Color(0xFFFFFFFF);

  Color _applyOverlay(Color surface, Color primary, double elevation) {
    if (elevation != 0) {
      return _colorWithOverlay(surface, primary, elevation);
    }
    return surface;
  }

  Color _colorWithOverlay(Color surface, Color overlay, double elevation) =>
      Color.alphaBlend(_overlayColor(overlay, elevation), surface);

  Color _overlayColor(Color color, double elevation) {
    final double opacity = (4.5 * math.log(elevation + 1) + 2) / 100.0;
    return color.withOpacity(opacity);
  }
}
