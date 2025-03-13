import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final MainAxisAlignment alignment;
  final CrossAxisAlignment crossAlignment;
  final int? maxLines;

  const TitleSection({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.titleStyle,
    this.subtitleStyle,
    this.alignment = MainAxisAlignment.start,
    this.crossAlignment = CrossAxisAlignment.start,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget titleWidget = Text(
      title,
      style: titleStyle ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );

    final List<Widget> children = [];

    // If there's a leading widget (like an icon or image), add it
    if (leading != null) {
      children.add(leading!);
      children.add(const SizedBox(width: 8));
    }

    // Add a column with title and optional subtitle
    children.add(
      Flexible(
        child: Column(
          crossAxisAlignment: crossAlignment,
          children: [
            titleWidget,
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: subtitleStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                maxLines: maxLines,
                overflow: maxLines != null ? TextOverflow.ellipsis : null,
              ),
            ],
          ],
        ),
      ),
    );

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
