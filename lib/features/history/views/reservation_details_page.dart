import 'dart:convert';
import 'package:fatcherappv2/shared/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/shared/widgets/unified_info_section.dart';
import 'package:intl/intl.dart';

class ReservationDetailsPage extends StatefulWidget {
  final String reservationId;

  const ReservationDetailsPage({
    Key? key,
    required this.reservationId,
  }) : super(key: key);

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  Map<String, dynamic>? reservation;
  bool isLoading = true;
  String? loadError;

  @override
  void initState() {
    super.initState();
    loadReservationData();
  }

  Future<void> loadReservationData() async {
    try {
      print(
          "Attempting to load data for reservation ID: ${widget.reservationId}");

      // List of known reservation IDs with their exact filename
      final Map<String, String> knownReservations = {
        'E5F6G7H8': 'assets/data/E5F6G7H8.json',
        'I9J1K2L3': 'assets/data/I9J1K2L3.json',
        'Q8R9S1T2': 'assets/data/Q8R9S1T2.json',
      };

      // First try loading specific file if it's a known ID
      if (knownReservations.containsKey(widget.reservationId)) {
        final String filePath = knownReservations[widget.reservationId]!;
        print("Reservation ID matched with known file: $filePath");

        try {
          final String response = await rootBundle.loadString(filePath);
          print("Successfully loaded file content");

          final data = json.decode(response);
          print("Successfully parsed JSON");

          setState(() {
            reservation = data;
            isLoading = false;
          });
          print("State updated with specific reservation data");
          return;
        } catch (e) {
          print("Failed to load specific reservation file: $e");
          // Continue to default file
        }
      }

      // If we reach here, either the ID wasn't known or the file couldn't be loaded
      print("Loading default reservation file");
      final String defaultPath = 'assets/data/reservation_details.json';

      try {
        final String response = await rootBundle.loadString(defaultPath);
        final data = json.decode(response);
        setState(() {
          reservation = data;
          isLoading = false;
        });
        print("Successfully loaded default reservation data");
      } catch (e) {
        print("Error loading default reservation file: $e");
        setState(() {
          loadError =
              "Could not load reservation details. Please try again later.";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Unhandled error in loadReservationData: $e");
      setState(() {
        loadError = "An unexpected error occurred. Please try again later.";
        isLoading = false;
      });
    }
  }

  // Fixed method to check if reservation was completed in last 7 days
  bool _isRecentlyCompleted() {
    if (reservation == null ||
        !reservation!.containsKey('date') ||
        !reservation!.containsKey('status')) {
      return false;
    }

    // Check if status is 'completed' or similar - using lowercase consistently
    final status = reservation!['status'].toString().toLowerCase();
    if (status != "completed" && status != "finished") {
      // Add debugging to see what status we actually have
      print("Reservation status: $status - not showing review button");
      return false;
    }

    try {
      // Parse the reservation date - try multiple formats
      DateTime reservationDate;
      try {
        reservationDate = DateFormat("MM/dd/yyyy").parse(reservation!['date']);
      } catch (e) {
        try {
          reservationDate =
              DateFormat("yyyy-MM-dd").parse(reservation!['date']);
        } catch (e) {
          reservationDate =
              DateFormat("dd/MM/yyyy").parse(reservation!['date']);
        }
      }

      final now = DateTime.now();
      final difference = now.difference(reservationDate).inDays;

      // Debug info
      print("Reservation date: $reservationDate, days since: $difference");

      // Check if completed within last 7 days
      return difference >= 0 && difference <= 7;
    } catch (e) {
      print("Error parsing reservation date: ${reservation!['date']} - $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (loadError != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text(loadError!)),
      );
    }

    if (reservation == null) {
      return Scaffold(
        appBar: AppBar(title: Text('No Data')),
        body: Center(child: Text('No reservation details found')),
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
            UnifiedInfoSection(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              itemPadding: EdgeInsets.symmetric(vertical: 4.0),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              infoItems: [
                InfoItemData(
                  label: 'Hotel',
                  value: reservation!['hotel_name'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Animal',
                  value:
                      '${reservation!['animal']['name']} (${reservation!['animal']['type']})',
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Breed',
                  value: reservation!['animal']['breed'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Age',
                  value: reservation!['animal']['age'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Date',
                  value: reservation!['date'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Address',
                  value: reservation!['address'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Status',
                  value: reservation!['status'],
                  valueStyle: TextStyle(color: Colors.redAccent),
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Health Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            UnifiedInfoSection(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              itemPadding: EdgeInsets.symmetric(vertical: 4.0),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              infoItems: [
                InfoItemData(
                  label: 'Allergies',
                  value: reservation!['health_info']['allergies'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Medications',
                  value: reservation!['health_info']['medications'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                InfoItemData(
                  label: 'Feeding Schedule',
                  value: reservation!['health_info']['feeding_schedule'],
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ],
            ),
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

            // Add Review button if reservation was completed recently
            if (_isRecentlyCompleted()) ...[
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  final result = await ReviewDialog.show(
                    context: context,
                    title: 'Review ${reservation!['hotel_name']}',
                  );

                  if (result != null) {
                    // Process the review submission
                    print(
                        'Rating: ${result['rating']}, Review: ${result['review']}');

                    // Here you would typically send this to your backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thank you for your review!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Add Review',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context)
              .push('/history/reservationDetails/chat', extra: 'chat01');
        },
        child: const Icon(Icons.message_outlined),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
