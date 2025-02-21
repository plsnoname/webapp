import 'package:flutter/material.dart';
import 'title_section.dart';
import 'price_and_rating_section.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String reviews;

  const InfoSection({
    Key? key,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(title: title, location: location),
          const SizedBox(height: 8),
          PriceAndRatingSection(
            price: price,
            rating: rating,
            reviews: reviews,
          ),
        ],
      ),
    );
  }
}
