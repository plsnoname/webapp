import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart';
import 'package:fatcherappv2/shared/widgets/title_section.dart';

class CustomHotelCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String reviews;
  final String imageUrl;

  const CustomHotelCard({
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    // Calculate card dimensions to maintain 9:16 ratio
    final Size screenSize = MediaQuery.of(context).size;
    final double aspectRatio = screenSize.width / screenSize.height;
    
    // Determine if we're in grid layout based on aspect ratio
    final bool isGrid = aspectRatio >= 1.0;
    
    // Card with aspect ratio based on layout
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias, 
      child: isGrid 
        ? AspectRatio(
            aspectRatio: 16 / 5, 
            child: _buildCard(isSmallScreen),
          )
        : _buildCard(isSmallScreen),
    );
  }
  
  Widget _buildCard(bool isSmallScreen) {
    // Keep original horizontal card layout for all views
    final imageWidth = isSmallScreen ? 100.0 : 120.0;
    final imageHeight = isSmallScreen ? 100.0 : 120.0;
    
    return Row(
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
              borderRadius: const BorderRadius.only(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title Section
                TitleSection(
                  title: title,
                  subtitle: location,
                  titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),

                // Info Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Price: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 12.0 : 14.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12.0 : 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Rating: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 12.0 : 14.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$rating ⭐ ($reviews)',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12.0 : 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
