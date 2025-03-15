import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart';

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
        onTap: () {
          // Navigate to hotel details page
          context.go('/home/hotelDetails', extra: {
            'id': id,
            'name': name,
            'location': location,
            'price': price,
            'rating': rating.toString(),
            'reviews': reviews.toString(),
            'imageUrls': imageUrls,
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: EnhancedImageSection(
                  imageUrls: [imageUrl],
                  height: imageHeight,
                  width: imageWidth,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  showIndicator: false,
                ),
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name - with optional highlighting
                    _buildHighlightedText(
                      name,
                      searchQuery,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Location
                    _buildHighlightedText(
                      location,
                      searchQuery,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12.0 : 14.0,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: isSmallScreen ? 16.0 : 18.0,
                            color: Colors.amber),
                        SizedBox(width: 2),
                        Text(
                          '$rating',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12.0 : 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ($reviews)',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Tags
                    if (tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: tags
                            .map((tag) => _buildTagChip(tag, isSmallScreen))
                            .toList(),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Starting from:',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 15.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build tags
  Widget _buildTagChip(String tag, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: isSmall ? 10 : 12,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Helper to highlight text matching search query
  Widget _buildHighlightedText(String text, String? query, {TextStyle? style}) {
    if (query == null ||
        query.isEmpty ||
        !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: style, overflow: TextOverflow.ellipsis);
    }

    final List<TextSpan> spans = [];
    final String lowercaseText = text.toLowerCase();
    final String lowercaseQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final int matchIndex = lowercaseText.indexOf(lowercaseQuery, start);
      if (matchIndex == -1) {
        // No more matches, add remaining text
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start)));
        }
        break;
      }

      // Add text before match
      if (matchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, matchIndex)));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: TextStyle(
          backgroundColor: Colors.yellow[100],
          fontWeight: FontWeight.bold,
        ),
      ));

      start = matchIndex + query.length;
    }

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ??
            const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
        children: spans,
      ),
    );
  }
}
