import 'package:fatcherappv2/features/home/components/custom_search_bar.dart';
import 'package:flutter/material.dart';
import '../components/app_bar_title.dart';
import '../components/hotel_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Map<String, String>> items;
  late List<Map<String, String>> filteredItems;

  @override
  void initState() {
    super.initState();
    items = _generateDummyItems(); // Generate the items here
    filteredItems = items;
  }

  List<Map<String, String>> _generateDummyItems() {
    return List.generate(10, (index) {
      return {
        'title': 'Hotel ${index + 1}',
        'location': 'Location ${index + 1} - ${5 + index}km away',
        'price': '\$${50 + (index * 10)}/night',
        'rating': '${4.0 + (index % 5) * 0.1}',
        'reviews': '${50 + (index * 20)}',
        'imageUrl': 'assets/images/hotel_dummy_photo.jpeg',
      };
    });
  }

  void filterByQuery(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
              (item['location']!.toLowerCase().contains(query.toLowerCase())) ||
              (item['title']!.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 380.0,
              pinned: false,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const AppBarTitle(),
                      CustomSearchBar(onSearch: filterByQuery),
                    ],
                  ),
                ),
              ),
            ),
            HotelList(items: filteredItems),
          ],
        ),
      ),
    );
  }
}
