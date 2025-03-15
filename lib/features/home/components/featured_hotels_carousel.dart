import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart';
import 'package:fatcherappv2/shared/utils/ui_helpers.dart';

class FeaturedHotelsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> featuredHotels;
  final String title;
  final double imageHeight;
  final EdgeInsets padding;

  const FeaturedHotelsCarousel({
    Key? key,
    required this.featuredHotels,
    this.title = 'Featured Places',
    this.imageHeight = 180,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (featuredHotels.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: imageHeight + 70, // Height for image + text below
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: featuredHotels.length,
            itemBuilder: (context, index) {
              final hotel = featuredHotels[index];
              return _buildFeaturedHotelCard(context, hotel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedHotelCard(
      BuildContext context, Map<String, dynamic> hotel) {
    final List<String> imageUrls = hotel['imageUrls'] ?? [];

    return GestureDetector(
      onTap: () {
        context.go('/home/hotelDetails', extra: hotel);
      },
      child: Container(
        width: 230,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the factory helper to create consistent image displays
            ImageSectionFactory.cardHeader(
              urls: imageUrls.isNotEmpty ? imageUrls : [''],
              height: imageHeight,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'] ?? 'Unknown Hotel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    hotel['location'] ?? 'Unknown Location',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        hotel['rating']?.toString() ?? '0.0',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' (${hotel['reviews'] ?? '0'})',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
