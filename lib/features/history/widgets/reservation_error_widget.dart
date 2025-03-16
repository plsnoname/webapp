import 'package:flutter/material.dart';

class ReservationErrorWidget extends StatelessWidget {
  final String error;

  const ReservationErrorWidget({Key? key, required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(error)),
    );
  }
}
