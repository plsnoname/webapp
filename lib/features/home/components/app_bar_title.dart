import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal font size to save space
    return Padding(
      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        'Hotels',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
