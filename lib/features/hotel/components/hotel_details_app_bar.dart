import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart';
import 'package:fatcherappv2/shared/widgets/unified_info_section.dart'; // Add this import
import 'title_section.dart';

class HotelDetailsAppBar extends StatelessWidget {
  final Map<String, dynamic> hotelDetails;

  const HotelDetailsAppBar({Key? key, required this.hotelDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EnhancedImageSection(
                imageUrls: hotelDetails['imageUrls'] ?? [''],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TitleSection(
                name: hotelDetails['name'] ?? 'Unknown Hotel',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UnifiedInfoSection(
                infoItems: [
                  InfoItemData(
                    label: 'Pay Method',
                    value: hotelDetails['paymentMethods'] ?? 'N/A',
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    valueStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InfoItemData(
                    label: '⭐ ${hotelDetails['rating'] ?? '0.0'}',
                    value: '(${hotelDetails['reviews'] ?? '0'} reviews)',
                    labelStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    valueStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  InfoItemData(
                    label: 'Check-in',
                    value: hotelDetails['checkInTime'] ?? 'N/A',
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    valueStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
