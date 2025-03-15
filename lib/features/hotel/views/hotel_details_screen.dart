import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/hotel_details_app_bar.dart';
import '../components/custom_tab_bar.dart';
import '../components/tab_bar_content.dart';
import 'package:fatcherappv2/shared/widgets/unified_button.dart'; // Updated import
import 'package:fatcherappv2/design_system/spacing.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Map<String, String>? hotelDetails;

  const HotelDetailsScreen({Key? key, this.hotelDetails}) : super(key: key);

  @override
  _HotelDetailsScreenState createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  int _selectedTabIndex = 1; // Default to the "Rooms" tab
  final List<String> _tabs = ['Description', 'Rooms', 'Reviews & FAQ'];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hotelDetails = widget.hotelDetails;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hotel details SliverAppBar
          HotelDetailsAppBar(
            hotelDetails: {
              'name': hotelDetails?['title'] ?? 'Unknown Hotel',
              'rating': hotelDetails?['rating'] ?? '0.0',
              'reviews': hotelDetails?['reviews'] ?? '0',
              'imageUrls': [hotelDetails?['imageUrl'] ?? ''],
            },
          ),
          // CustomTabBar wrapped in SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppSpacing.verticalSpaceMD,
                CustomTabBar(
                  tabs: _tabs,
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: _onTabSelected,
                ),
              ],
            ),
          ),
          // TabBarContent wrapped in SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabBarContent(
                selectedIndex: _selectedTabIndex,
                hotelDetails: {
                  'rooms': [
                    {
                      'name': 'Standard Room',
                      'description': 'A simple, affordable option.',
                      'price': hotelDetails?['price'] ?? 'Unknown Price',
                    },
                    {
                      'name': 'Deluxe Room',
                      'description': 'A luxurious option for a premium stay.',
                      'price': '\$200/night',
                    },
                  ],
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingMD,
              child: UnifiedButton(
                // Replaced CustomButton with UnifiedButton
                text: 'Make a Reservation',
                onPressed: () {
                  context.go('/home/hotelDetails/roomDetails', extra: {
                    'imageUrls': [hotelDetails?['imageUrl'] ?? ''],
                    'roomDescription': 'A beautiful room with all amenities.',
                    'tags': ['WiFi', 'Air Conditioning', 'Breakfast Included'],
                  });
                },
                buttonStyle:
                    UnifiedButtonStyle.filled, // Updated enum reference
              ),
            ),
          ),
        ],
      ),
    );
  }
}
