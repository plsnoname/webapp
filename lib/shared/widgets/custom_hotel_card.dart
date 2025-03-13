import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/image_section.dart';
import 'package:fatcherappv2/shared/widgets/title_section.dart';
import 'package:fatcherappv2/shared/widgets/info_section.dart';
import 'package:fatcherappv2/design_system/spacing.dart';

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

    // Calculate responsive image size
    final imageWidth = isSmallScreen ? 100.0 : 120.0;
    final imageHeight = isSmallScreen ? 100.0 : 120.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
              child: ImageSection(imageUrls: [imageUrl]),
            ),
          ),

          // Content Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  TitleSection(
                    title: title,
                    subtitle: location,
                    maxLines: 1, // Limit title to one line
                  ),

                  SizedBox(height: isSmallScreen ? 4.0 : 8.0),

                  // Info Section - using a column with row for better layout
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
      ),
    );
  }
}
