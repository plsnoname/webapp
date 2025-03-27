import 'package:flutter/material.dart';
import 'package:fatcherappv2/routes/side_navigation_bar.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double aspectRatio = screenSize.width / screenSize.height;
    final bool isLandscape = aspectRatio > 3/4;

    if (isLandscape) {
      return Scaffold(
        body: Row(
          children: [
            SideNavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.history_sharp),
              label: 'History',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
          ],
          onDestinationSelected: onDestinationSelected,
        ),
      );
    }
  }
}
