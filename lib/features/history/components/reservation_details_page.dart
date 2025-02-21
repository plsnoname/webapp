import 'package:flutter/material.dart';

class ReservationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetailsPage({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(reservation['hotel_name']),
              Text(reservation['date']),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reservation Code: ${reservation['reservation_code']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Hotel: ${reservation['hotel_name']}'),
              Text(
                  'Animal: ${reservation['animal_name']} (${reservation['animal_type']})'),
              Text('Date: ${reservation['date']}'),
              Text('Address: ${reservation['address']}'),
              SizedBox(height: 4.0),
              Text('Status: ${reservation['status']}',
                  style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0, // Removes the shadow/line
          color: Colors.transparent, // Ensures no background color is added
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.message_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
