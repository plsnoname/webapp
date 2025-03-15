import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart'; // Add this import

class ReservationItem extends StatelessWidget {
  final String reservationCode;
  final String hotelName;
  final String animalName;
  final String animalType;
  final String date;
  final String address;
  final String status;
  final VoidCallback onTap;
  final String? hotelImageUrl; // Add this parameter

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
    this.hotelImageUrl,
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add hotel image if available
            if (hotelImageUrl != null && hotelImageUrl!.isNotEmpty)
              EnhancedImageSection(
                imageUrls: [hotelImageUrl!],
                height: 120,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                showIndicator: false,
              ),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.2),
                borderRadius: hotelImageUrl != null && hotelImageUrl!.isNotEmpty
                    ? BorderRadius.vertical(bottom: Radius.circular(12))
                    : BorderRadius.circular(12),
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
          ],
        ),
      ),
    );
  }
}
