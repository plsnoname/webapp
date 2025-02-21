import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../components/reservation_summary_item.dart';

class ReservationSummary extends StatelessWidget {
  final Map<String, dynamic> reservationData;

  const ReservationSummary({Key? key, required this.reservationData})
      : super(key: key);

  Future<Map<String, String>> _loadReservationData() async {
    final storage = FlutterSecureStorage();
    final allData = await storage.readAll();
    final filteredData = allData
      ..removeWhere((key, value) => !_isReservationData(key));
    return filteredData;
  }

  bool _isReservationData(String key) {
    return key.contains('reservation');
  }

  Future<void> _clearReservationData() async {
    final storage = FlutterSecureStorage();
    final allData = await storage.readAll();
    for (var key in allData.keys) {
      if (_isReservationData(key)) {
        await storage.delete(key: key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Summary'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _loadReservationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final data = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Reservation Summary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  ...data.entries.map((entry) {
                    return ReservationSummaryItem(
                      label: entry.key,
                      value: entry.value,
                    );
                  }).toList(),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _clearReservationData();
                        // Perform final submission or navigation
                        print('Final submission');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.0),
                        ),
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Confirm Reservation',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
