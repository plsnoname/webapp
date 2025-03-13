import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/image_section.dart'; // Updated import path
import '../../../design_system/spacing.dart'; // Import spacing
import '../../../shared/widgets/custom_button.dart'; // Import shared button

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
            ImageSection(imageUrls: imageUrls), // Using shared ImageSection
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
              child: CustomButton(
                // Using shared button component
                text: 'Proceed to Reservation',
                onPressed: () {
                  context.go('/home/hotelDetails/animalForm',
                      extra: 'Unknown Hotel');
                },
                backgroundColor: Theme.of(context).primaryColor,
                width: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
