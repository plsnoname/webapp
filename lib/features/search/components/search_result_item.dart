import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/features/search/components/search_result_image.dart';
import 'package:fatcherappv2/features/search/components/search_result_content.dart';

class SearchResultItem extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String price;
  final double rating;
  final int reviews;
  final List<String> imageUrls;
  final List<String> tags;
  final String? searchQuery;

  const SearchResultItem({
    Key? key,
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrls,
    this.tags = const [],
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Get image URL or use fallback
    final String imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

    // Calculate responsive image size
    final imageWidth = isSmallScreen ? 90.0 : 110.0;
    final imageHeight = isSmallScreen ? 90.0 : 110.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToHotelDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            SearchResultImage(
              imageUrl: imageUrl,
              width: imageWidth,
              height: imageHeight,
            ),

            // Content Section
            Expanded(
              child: SearchResultContent(
                name: name,
                location: location,
                price: price,
                rating: rating,
                reviews: reviews,
                tags: tags,
                searchQuery: searchQuery,
                isSmallScreen: isSmallScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHotelDetails(BuildContext context) {
    context.go('/home/hotelDetails', extra: {
      'id': id,
      'name': name,
      'location': location,
      'price': price,
      'rating': rating.toString(),
      'reviews': reviews.toString(),
      'imageUrls': imageUrls,
    });
  }
}
