import 'package:flutter/material.dart';

class ReservationQuestionsSection extends StatelessWidget {
  final List<dynamic> questions;

  const ReservationQuestionsSection({
    Key? key,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...questions.map<Widget>((question) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('${question['question']}: ${question['answer']}'),
          );
        }).toList(),
      ],
    );
  }
}
