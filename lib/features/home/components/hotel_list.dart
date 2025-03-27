import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/custom_hotel_card.dart';
import 'package:fatcherappv2/design_system/spacing.dart';
import 'package:fatcherappv2/shared/utils/responsive_helper.dart';

class HotelList extends StatelessWidget {
  final List<Map<String, String>> items;

  const HotelList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive calculations
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Define breakpoints for responsive column counts
    const double smallScreenBreakpoint = 600.0;  // 1 column below this width
    const double mediumScreenBreakpoint = 900.0; // 2 columns between small and medium
    
    // Determine column count based on screen width
    int columns = 1; // Default for small screens
    if (screenWidth >= smallScreenBreakpoint) {
      columns = 2; // Medium screens
      if (screenWidth >= mediumScreenBreakpoint) {
        columns = 3; // Large screens
      }
    }
    
    // Determine responsive padding based on screen width
    final horizontalPadding = screenWidth < ResponsiveHelper.mobileBreakpoint ? 8.0 : AppSpacing.md;
    final verticalPadding = screenWidth < ResponsiveHelper.mobileBreakpoint ? 6.0 : AppSpacing.sm;
    
    // Calculate appropriate card aspect ratio
    const double cardAspectRatio = 16 / 5;
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: cardAspectRatio,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final item = items[index];
            return GestureDetector(
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
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
