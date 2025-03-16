import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String? query;
  final TextStyle? style;

  const HighlightedText({
    Key? key,
    required this.text,
    this.query,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (query == null ||
        query!.isEmpty ||
        !text.toLowerCase().contains(query!.toLowerCase())) {
      return Text(text, style: style, overflow: TextOverflow.ellipsis);
    }

    final List<TextSpan> spans = [];
    final String lowercaseText = text.toLowerCase();
    final String lowercaseQuery = query!.toLowerCase();
    int start = 0;

    while (true) {
      final int matchIndex = lowercaseText.indexOf(lowercaseQuery, start);
      if (matchIndex == -1) {
        // No more matches, add remaining text
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start)));
        }
        break;
      }

      // Add text before match
      if (matchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, matchIndex)));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query!.length),
        style: TextStyle(
          backgroundColor: Colors.yellow[100],
          fontWeight: FontWeight.bold,
        ),
      ));

      start = matchIndex + query!.length;
    }

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ?? const TextStyle(color: Colors.black, fontSize: 14),
        children: spans,
      ),
    );
  }
}
