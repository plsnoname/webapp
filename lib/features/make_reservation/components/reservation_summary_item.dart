import 'package:flutter/material.dart';

class ReservationSummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const ReservationSummaryItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  String _formatLabel(String label) {
    return label
        .replaceFirst('reservation_', '')
        .replaceAll('_', ' ')
        .replaceAll('#', ': ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatLabel(label),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
