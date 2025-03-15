import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/enhanced_image_section.dart'; // Updated import
import '../../../design_system/spacing.dart'; // Import spacing
import '../../../shared/widgets/unified_button.dart'; // Updated import

class RoomDetailsPage extends StatelessWidget {
  final List<String> imageUrls;
  final String roomDescription;
  final List<String> tags;

  RoomDetailsPage({
    required this.imageUrls,
    required this.roomDescription,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
      ),
      body: Padding(
        padding: AppSpacing.paddingMD, // Using design system spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EnhancedImageSection(
              imageUrls: imageUrls,
              fullScreenOnTap: true,
              borderRadius: BorderRadius.circular(12),
            ),
            AppSpacing.verticalSpaceMD, // Using design system spacing
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            AppSpacing.verticalSpaceSM, // Using design system spacing
            Text(roomDescription),
            AppSpacing.verticalSpaceMD, // Using design system spacing
            Text(
              'Facilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            AppSpacing.verticalSpaceSM, // Using design system spacing
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),
            AppSpacing.verticalSpaceMD, // Using design system spacing
            Center(
              child: UnifiedButton(
                text: 'Proceed to Reservation',
                onPressed: () {
                  context.go('/home/hotelDetails/animalForm',
                      extra: 'Unknown Hotel');
                },
                backgroundColor: Theme.of(context).primaryColor,
                width: 250,
                buttonStyle:
                    UnifiedButtonStyle.filled, // Updated enum reference
              ),
            ),
          ],
        ),
      ),
    );
  }
}
