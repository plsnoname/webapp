import 'package:flutter/material.dart';

/// Helper for consistent responsive design across the app
class ResponsiveHelper {
  // Screen size breakpoints
  static const double mobileBreakpoint = 360.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  /// Determines if the current screen width is considered small
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Determines if the current screen is in mobile range
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  /// Determines if the current screen is in tablet range
  static bool isTabletScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  /// Determines if the current screen is in desktop range
  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Returns a value based on screen size
  static T valueBasedOnSize<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktopScreen(context) && desktop != null) {
      return desktop;
    }
    if (isTabletScreen(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Returns a font size based on the current screen size
  static double fontSize(BuildContext context, double baseFontSize) {
    if (isSmallScreen(context)) return baseFontSize - 2;
    if (isDesktopScreen(context)) return baseFontSize + 2;
    return baseFontSize;
  }

  /// Returns padding based on the current screen size
  static EdgeInsets padding(BuildContext context) {
    final double factor = isSmallScreen(context) ? 0.75 : 1.0;
    return EdgeInsets.all(16.0 * factor);
  }
}
