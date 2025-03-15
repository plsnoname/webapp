import 'package:flutter/material.dart';

/// Helper class to generate consistent button styles across the app
class ButtonStyleHelper {
  /// Creates a filled button style
  static ButtonStyle filledStyle({
    required Color backgroundColor,
    required Color textColor,
    double borderRadius = 8.0,
    EdgeInsets? padding,
    Color? disabledColor,
    BorderSide? borderSide,
    double? elevation,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide ?? BorderSide.none,
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      elevation: elevation,
      disabledBackgroundColor: disabledColor ?? Colors.grey,
      disabledForegroundColor: Colors.grey.shade300,
    );
  }

  /// Creates an outlined button style
  static ButtonStyle outlinedStyle({
    required Color color,
    double borderRadius = 8.0,
    EdgeInsets? padding,
    Color? disabledColor,
    BorderSide? borderSide,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      side: borderSide ?? BorderSide(color: color),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  /// Creates a text button style
  static ButtonStyle textStyle({
    required Color color,
    double borderRadius = 8.0,
    EdgeInsets? padding,
    Color? disabledColor,
  }) {
    return TextButton.styleFrom(
      foregroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
