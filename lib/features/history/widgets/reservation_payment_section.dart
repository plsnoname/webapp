import 'package:flutter/material.dart';

class ReservationPaymentSection extends StatelessWidget {
  final String payment;

  const ReservationPaymentSection({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('Payment: $payment'),
      ],
    );
  }
}
