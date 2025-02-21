import 'package:flutter/material.dart';

class ReservationItem extends StatelessWidget {
  final String reservationCode;
  final String hotelName;
  final String animalName;
  final String animalType;
  final String date;
  final String address;
  final String status;
  final VoidCallback onTap;

  const ReservationItem({
    Key? key,
    required this.reservationCode,
    required this.hotelName,
    required this.animalName,
    required this.animalType,
    required this.date,
    required this.address,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservation Code: $reservationCode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Hotel: $hotelName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Animal: $animalName ($animalType)'),
            Text('Date: $date'),
            Text('Address: $address'),
            SizedBox(height: 4.0),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.0),
                Text('Status: $status'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
