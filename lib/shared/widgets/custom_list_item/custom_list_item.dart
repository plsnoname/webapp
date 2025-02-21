import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomListItem extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String reviews;
  final String imageUrl;

  const CustomListItem({
    Key? key,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> item = {
      'title': title,
      'location': location,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'imageUrl': imageUrl,
    };

    return GestureDetector(
      onTap: () {
        context.push(
          '/home/hotelDetails', // Ensure this route is configured in your GoRouter setup
          extra: item, // Pass item as the extra data
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.startsWith('http')) // Check if it's a network image
              Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/hotel_dummy_photo.jpeg', // Fallback asset
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                },
              )
            else // Use Image.asset for local asset images
              Image.asset(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '⭐ $rating ($reviews reviews)',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
