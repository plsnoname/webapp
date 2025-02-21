import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String name;

  const TitleSection({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dummy_logo.png',
              width: 60, // Adjust the width as needed
              height: 60, // Adjust the height as needed
            ),
            const SizedBox(
                width: 8), // Add spacing between the logo and the text
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
