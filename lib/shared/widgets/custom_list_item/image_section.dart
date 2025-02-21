import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final String imageUrl;

  const ImageSection({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Image.network(
        imageUrl,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to placeholder image
          return Image.asset(
            'assets/images/hotel_dummy_photo.jpeg',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 120,
            width: 120,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
