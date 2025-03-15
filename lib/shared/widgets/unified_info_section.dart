import 'package:flutter/material.dart';

class InfoItemData {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? customContent;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final CrossAxisAlignment crossAlignment;
  final MainAxisAlignment mainAlignment;

  InfoItemData({
    required this.label,
    required this.value,
    this.icon,
    this.customContent,
    this.prefixWidget,
    this.suffixWidget,
    this.labelStyle,
    this.valueStyle,
    this.crossAlignment = CrossAxisAlignment.center,
    this.mainAlignment = MainAxisAlignment.center,
  });
}

class UnifiedInfoSection extends StatelessWidget {
  final List<InfoItemData> infoItems;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;
  final EdgeInsets? itemPadding;
  final TextStyle? defaultLabelStyle;
  final TextStyle? defaultValueStyle;
  final BoxDecoration? decoration;
  final int? itemsPerRow; // For grid-like layout
  final double? spacing;
  final double? runSpacing;

  const UnifiedInfoSection({
    Key? key,
    required this.infoItems,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.itemPadding,
    this.defaultLabelStyle,
    this.defaultValueStyle,
    this.decoration,
    this.itemsPerRow,
    this.spacing = 8.0,
    this.runSpacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalLabelStyle =
        defaultLabelStyle ?? TextStyle(fontSize: 14, color: Colors.grey);

    final finalValueStyle = defaultValueStyle ??
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    Widget buildInfoItem(InfoItemData item) {
      if (item.customContent != null) {
        return Padding(
          padding: itemPadding ?? EdgeInsets.zero,
          child: item.customContent!,
        );
      }

      Widget itemContent = Column(
        mainAxisAlignment: item.mainAlignment,
        crossAxisAlignment: item.crossAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.prefixWidget != null) ...[
            item.prefixWidget!,
            SizedBox(height: 4),
          ],
          if (item.icon != null) ...[
            Icon(item.icon, size: 18, color: Colors.grey),
            SizedBox(height: 4),
          ],
          Text(
            item.label,
            style: item.labelStyle ?? finalLabelStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            item.value,
            style: item.valueStyle ?? finalValueStyle,
            textAlign: TextAlign.center,
          ),
          if (item.suffixWidget != null) ...[
            SizedBox(height: 4),
            item.suffixWidget!,
          ],
        ],
      );

      return Padding(
        padding: itemPadding ?? EdgeInsets.zero,
        child: itemContent,
      );
    }

    Widget content;

    if (itemsPerRow != null && itemsPerRow! > 0) {
      // Grid layout
      content = Wrap(
        spacing: spacing!,
        runSpacing: runSpacing!,
        children: infoItems.map((item) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width -
                    padding.horizontal -
                    (spacing! * (itemsPerRow! - 1))) /
                itemsPerRow!,
            child: buildInfoItem(item),
          );
        }).toList(),
      );
    } else if (direction == Axis.horizontal) {
      // Row layout
      content = Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: infoItems.map(buildInfoItem).toList(),
      );
    } else {
      // Column layout
      content = Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: infoItems.map(buildInfoItem).toList(),
      );
    }

    return Container(
      padding: padding,
      decoration: decoration,
      child: content,
    );
  }
}
