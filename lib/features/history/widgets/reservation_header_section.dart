import 'package:flutter/material.dart';

class ReservationHeaderSection extends StatelessWidget
    implements PreferredSizeWidget {
  final Map<String, dynamic> reservation;

  const ReservationHeaderSection({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(reservation['hotel_name']),
          Text(reservation['date']),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
