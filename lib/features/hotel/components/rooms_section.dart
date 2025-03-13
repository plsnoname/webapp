import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_button.dart';

class RoomsSection extends StatelessWidget {
  final List<Map<String, String>> rooms;

  const RoomsSection({Key? key, required this.rooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rooms',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: rooms.map((room) => RoomTile(room: room)).toList(),
        ),
      ],
    );
  }
}

class RoomTile extends StatelessWidget {
  final Map<String, String> room;

  const RoomTile({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room['name'] ?? 'Room Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room['description'] ?? 'Room description',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  room['price'] ?? '\$0/day',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Schedule',
                  onPressed: () {
                    GoRouter.of(context)
                        .go('/home/hotelDetails/roomDetails', extra: {
                      'imageUrls': [room['imageUrl'] ?? ''],
                      'roomDescription': room['description'] ?? '',
                      'tags': [
                        'WiFi',
                        'Air Conditioning',
                        'Breakfast Included'
                      ],
                    });
                  },
                  backgroundColor: Colors.purple,
                  textColor: Colors.white,
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
