import 'package:flutter/material.dart';
import '../star_rating_widget.dart';
import '../rating_utils.dart';

class ReviewRatingSection extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const ReviewRatingSection({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Rate your experience", style: TextStyle(fontSize: 16.0)),
        SizedBox(height: 10.0),
        StarRatingWidget(
          rating: rating,
          onRatingChanged: onRatingChanged,
        ),
        SizedBox(height: 10.0),
        Text(
          getRatingText(rating),
          style: TextStyle(
            fontSize: 14.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
