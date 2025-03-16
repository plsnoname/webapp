import 'package:flutter/material.dart';

class ReservationLoadingWidget extends StatelessWidget {
  const ReservationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
