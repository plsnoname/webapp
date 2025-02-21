import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/custom_list_item/custom_list_item.dart';

class HotelList extends StatelessWidget {
  final List<Map<String, String>> items;

  const HotelList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = items[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                context.go('/hotel/hotelDetails', extra: item);
              },
              child: CustomListItem(
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
