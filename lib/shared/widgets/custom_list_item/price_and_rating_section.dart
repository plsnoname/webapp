import 'package:flutter/material.dart';

class PriceAndRatingSection extends StatelessWidget {
  final String price;
  final String rating;
  final String reviews;

  const PriceAndRatingSection({
    Key? key,
    required this.price,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '$rating ($reviews reviews)',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
