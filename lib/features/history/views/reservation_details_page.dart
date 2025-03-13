import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fatcherappv2/shared/widgets/custom_button.dart';
import 'package:fatcherappv2/design_system/spacing.dart';
import 'package:fatcherappv2/design_system/typography.dart';

class ReservationDetailsPage extends StatefulWidget {
  const ReservationDetailsPage({Key? key}) : super(key: key);

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  Map<String, dynamic>? reservation;

  @override
  void initState() {
    super.initState();
    loadReservationData();
  }

  Future<void> loadReservationData() async {
    final String response =
        await rootBundle.loadString('assets/data/reservation_details.json');
    final data = json.decode(response);
    setState(() {
      reservation = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reservation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(reservation!['hotel_name']),
            Text(reservation!['date']),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Reservation Code: ${reservation!['reservation_code']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Hotel: ${reservation!['hotel_name']}'),
            Text(
                'Animal: ${reservation!['animal']['name']} (${reservation!['animal']['type']})'),
            Text('Breed: ${reservation!['animal']['breed']}'),
            Text('Age: ${reservation!['animal']['age']}'),
            Text('Date: ${reservation!['date']}'),
            Text('Address: ${reservation!['address']}'),
            const SizedBox(height: 4.0),
            Text('Status: ${reservation!['status']}',
                style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16.0),
            const Text(
              'Health Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Allergies: ${reservation!['health_info']['allergies']}'),
            Text('Medications: ${reservation!['health_info']['medications']}'),
            Text(
                'Feeding Schedule: ${reservation!['health_info']['feeding_schedule']}'),
            const SizedBox(height: 16.0),
            const Text(
              'Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...reservation!['questions'].map<Widget>((question) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${question['question']}: ${question['answer']}'),
              );
            }).toList(),
            const SizedBox(height: 16.0),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Payment: ${reservation!['payment']}'),
            const SizedBox(height: 16.0),
            const Text(
              'Extra Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...reservation!['extra_options'].map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                    '${option['name']} (\$${option['price']}): ${option['response']}'),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.message_outlined),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
