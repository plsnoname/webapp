import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final bool isSmall;

  const TagChip({
    Key? key,
    required this.tag,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: isSmall ? 10 : 12,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
