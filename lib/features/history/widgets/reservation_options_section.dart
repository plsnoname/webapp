import 'package:flutter/material.dart';

class ReservationOptionsSection extends StatelessWidget {
  final List<dynamic> options;

  const ReservationOptionsSection({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extra Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...options.map<Widget>((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
                '${option['name']} (\$${option['price']}): ${option['response']}'),
          );
        }).toList(),
      ],
    );
  }
}
