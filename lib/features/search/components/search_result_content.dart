import 'package:flutter/material.dart';
import 'package:fatcherappv2/features/search/components/widgets/highlighted_text.dart';
import 'package:fatcherappv2/features/search/components/widgets/tag_chip.dart';

class SearchResultContent extends StatelessWidget {
  final String name;
  final String location;
  final String price;
  final double rating;
  final int reviews;
  final List<String> tags;
  final String? searchQuery;
  final bool isSmallScreen;

  const SearchResultContent({
    Key? key,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.tags,
    required this.isSmallScreen,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Name - with optional highlighting
          HighlightedText(
            text: name,
            query: searchQuery,
            style: TextStyle(
              fontSize: isSmallScreen ? 14.0 : 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          // Location
          HighlightedText(
            text: location,
            query: searchQuery,
            style: TextStyle(
              fontSize: isSmallScreen ? 12.0 : 14.0,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 4),

          // Rating
          _buildRatingRow(),

          const SizedBox(height: 4),

          // Tags
          if (tags.isNotEmpty) ...[
            _buildTagsRow(),
            const SizedBox(height: 4),
          ],

          // Price
          _buildPriceRow(context),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Icon(Icons.star,
            size: isSmallScreen ? 16.0 : 18.0, color: Colors.amber),
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
    );
  }

  Widget _buildTagsRow() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          tags.map((tag) => TagChip(tag: tag, isSmall: isSmallScreen)).toList(),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
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
    );
  }
}
