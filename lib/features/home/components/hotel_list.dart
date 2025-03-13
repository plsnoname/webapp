import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/custom_hotel_card.dart';
import 'package:fatcherappv2/design_system/spacing.dart';

class HotelList extends StatelessWidget {
  final List<Map<String, String>> items;

  const HotelList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine responsive padding based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 8.0 : AppSpacing.md;
    final verticalPadding = screenWidth < 360 ? 6.0 : AppSpacing.sm;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: GestureDetector(
              onTap: () {
                context.go('/home/hotelDetails', extra: item);
              },
              child: CustomHotelCard(
                title: item['title'] ?? 'Unknown Title',
                location: item['location'] ?? 'Unknown Location',
                price: item['price'] ?? 'Unknown Price',
                rating: item['rating'] ?? '0.0',
                reviews: item['reviews'] ?? '0',
                imageUrl: item['imageUrl'] ?? 'assets/images/hotel_dummy_photo',
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
