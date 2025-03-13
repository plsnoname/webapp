import 'package:flutter/material.dart';

class InfoItem {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? customContent;

  InfoItem({
    required this.label,
    required this.value,
    this.icon,
    this.customContent,
  });
}

class InfoSection extends StatelessWidget {
  final List<InfoItem> infoItems;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;
  final EdgeInsets? itemPadding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const InfoSection({
    Key? key,
    required this.infoItems,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.itemPadding,
    this.labelStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey,
    );

    final defaultValueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    Widget buildInfoItem(InfoItem item) {
      return Padding(
        padding: itemPadding ?? EdgeInsets.zero,
        child: item.customContent ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 18, color: Colors.grey),
                  SizedBox(height: 4),
                ],
                Text(
                  item.label,
                  style: labelStyle ?? defaultLabelStyle,
                ),
                SizedBox(height: 4),
                Text(
                  item.value,
                  style: valueStyle ?? defaultValueStyle,
                ),
              ],
            ),
      );
    }

    return Padding(
      padding: padding,
      child: direction == Axis.horizontal
          ? Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: infoItems.map(buildInfoItem).toList(),
            )
          : Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: infoItems.map(buildInfoItem).toList(),
            ),
    );
  }
}
