import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import '../components/reservation_item.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  Future<void> loadReservations() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/reservations.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        reservations = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      // Silent error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: const Text('Reservations'),
              centerTitle: true,
              floating: true,
              snap: true,
            ),
            reservations.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No reservations found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final reservation = reservations[index];

                        return ReservationItem(
                          reservationCode:
                              reservation['reservation_code'] ?? 'N/A',
                          hotelName: reservation['hotel_name'] ?? 'N/A',
                          animalName: reservation['animal_name'] ?? 'N/A',
                          animalType: reservation['animal_type'] ?? 'N/A',
                          date: reservation['date'] ?? 'N/A',
                          address: reservation['address'] ?? 'N/A',
                          status: reservation['status'] ?? 'N/A',
                          onTap: () {
                            final reservationCode =
                                reservation['reservation_code'];
                            GoRouter.of(context).push(
                              '/history/reservationDetails',
                              extra: reservationCode,
                            );
                          },
                        );
                      },
                      childCount: reservations.length,
                    ),
                  ),
          ],
        ),
      
    );
  }
}
