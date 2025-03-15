import 'package:flutter/material.dart';
import 'rooms_section.dart';
import 'reviews_section.dart';
import 'package:fatcherappv2/design_system/index.dart';

class TabBarContent extends StatelessWidget {
  final int selectedIndex;
  final Map<String, dynamic> hotelDetails;

  const TabBarContent({
    Key? key,
    required this.selectedIndex,
    required this.hotelDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use different height approach based on tab
    if (selectedIndex == 2) {
      // Reviews & FAQ tab
      return SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: AppTypography.heading3,
              ),
              AppSpacing.verticalSpaceMD,
              const ReviewsSection(),
              AppSpacing.verticalSpaceLG,
              Text(
                "FAQ",
                style: AppTypography.heading3,
              ),
              AppSpacing.verticalSpaceSM,
              Text(
                "1. What are the payment methods?",
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.verticalSpaceXS,
              Text(
                "- We accept card and cash.",
                style: AppTypography.bodyMedium,
              ),
              AppSpacing.verticalSpaceSM,
              Text(
                "2. What are the check-in hours?",
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.verticalSpaceXS,
              Text(
                "- Check-in is available from 9:00-11:00.",
                style: AppTypography.bodyMedium,
              ),
              AppSpacing.verticalSpaceMD,
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 500, // Keep fixed height for other tabs
        child: IndexedStack(
          index: selectedIndex,
          children: [
            // Description content
            Padding(
              padding: AppSpacing.paddingMD,
              child: Text(
                "Welcome to Lotus Food Salon, your one-stop destination for pampering your pets! "
                "Our services include trimming, grooming, and all the care your furry friends deserve.",
                style: AppTypography.bodyLarge,
              ),
            ),
            // Rooms content
            RoomsSection(rooms: hotelDetails['rooms']),
            // This is a placeholder for the Reviews tab (never shown due to our condition above)
            Container(),
          ],
        ),
      );
    }
  }
}
