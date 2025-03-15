import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart'; // Updated import

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EnhancedImageSection(
              imageUrls: imageUrls,
              fullScreenOnTap: true, // Add this enhancement
              borderRadius: BorderRadius.circular(12),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(roomDescription),
            SizedBox(height: 16.0),
            Text(
              'Facilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home/hotelDetails/animalForm',
                      extra: 'Unknown Hotel');
                },
                child: Text('Proceed to Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
