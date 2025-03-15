import 'package:flutter/material.dart';
import '../utils/button_styles.dart';

enum UnifiedButtonStyle {
  filled,
  outlined,
  text,
}

class UnifiedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final UnifiedButtonStyle buttonStyle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? iconSize;
  final Widget? customChild;
  final double? elevation;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final BorderSide? borderSide;

  const UnifiedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.padding,
    this.width,
    this.height,
    this.buttonStyle = UnifiedButtonStyle.filled,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSize = 18.0,
    this.customChild,
    this.elevation,
    this.disabledColor,
    this.disabledTextColor,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color defaultBgColor = theme.primaryColor;
    final Color effectiveBgColor = backgroundColor ?? defaultBgColor;
    final Color effectiveTextColor = textColor ?? Colors.white;

    final Color disabledBg = disabledColor ?? Colors.grey;
    final Color disabledText = disabledTextColor ?? Colors.grey.shade300;

    Widget buildButtonContent() {
      if (customChild != null) {
        return customChild!;
      }

      List<Widget> rowChildren = [];

      if (leadingIcon != null) {
        rowChildren.add(Icon(
          leadingIcon,
          size: iconSize,
          color: enabled ? effectiveTextColor : disabledText,
        ));
        rowChildren.add(SizedBox(width: 8));
      }

      rowChildren.add(Flexible(
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? effectiveTextColor : disabledText,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ));

      if (trailingIcon != null) {
        rowChildren.add(SizedBox(width: 8));
        rowChildren.add(Icon(
          trailingIcon,
          size: iconSize,
          color: enabled ? effectiveTextColor : disabledText,
        ));
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      );
    }

    Widget buttonWidget;
    final buttonContent = buildButtonContent();

    // Use ButtonStyleHelper to generate consistent styles
    switch (buttonStyle) {
      case UnifiedButtonStyle.filled:
        buttonWidget = ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ButtonStyleHelper.filledStyle(
            backgroundColor: effectiveBgColor,
            textColor: effectiveTextColor,
            borderRadius: borderRadius,
            padding: padding,
            disabledColor: disabledBg,
            borderSide: borderSide,
            elevation: elevation,
          ),
          child: buttonContent,
        );
        break;

      case UnifiedButtonStyle.outlined:
        buttonWidget = OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: ButtonStyleHelper.outlinedStyle(
            color: effectiveBgColor,
            borderRadius: borderRadius,
            padding: padding,
            disabledColor: disabledBg,
            borderSide: borderSide,
          ),
          child: buttonContent,
        );
        break;

      case UnifiedButtonStyle.text:
        buttonWidget = TextButton(
          onPressed: enabled ? onPressed : null,
          style: ButtonStyleHelper.textStyle(
            color: effectiveBgColor,
            borderRadius: borderRadius,
            padding: padding,
            disabledColor: disabledBg,
          ),
          child: buttonContent,
        );
        break;
    }

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
