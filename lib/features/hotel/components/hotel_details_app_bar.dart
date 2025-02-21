import 'package:flutter/material.dart';
import 'image_section.dart';
import 'info_section.dart';
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
              child: ImageSection(
                imageUrls: hotelDetails['imageUrls'] ?? [''],
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
              child: InfoSection(
                paymentMethods: hotelDetails['paymentMethods'] ?? 'N/A',
                checkInTime: hotelDetails['checkInTime'] ?? 'N/A',
                rating: hotelDetails['rating'] ?? '0.0',
                reviews: hotelDetails['reviews'] ?? '0',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
