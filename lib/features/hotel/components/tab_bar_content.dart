import 'package:flutter/material.dart';
import 'rooms_section.dart';

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
    return SizedBox(
      height: 500, // Adjust this height based on content
      child: IndexedStack(
        index: selectedIndex,
        children: [
          // Description content
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Welcome to Lotus Food Salon, your one-stop destination for pampering your pets! "
              "Our services include trimming, grooming, and all the care your furry friends deserve.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Rooms content
          RoomsSection(rooms: hotelDetails['rooms']),
          // Reviews & FAQ content
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "FAQ: \n\n1. What are the payment methods?\n- We accept card and cash.\n\n"
              "2. What are the check-in hours?\n- Check-in is available from 9:00-11:00.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
