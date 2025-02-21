import 'package:flutter/material.dart';
import 'package:fatcherappv2/features/authentication/login_guard.dart';
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

      print("Loaded Reservations: ${reservations.length}");
    } catch (e) {
      print("Error loading reservations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginGuard(
      child: SafeArea(
        child: Scaffold(
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
                                reservation['reservationCode'] ?? 'N/A',
                            hotelName: reservation['hotelName'] ?? 'N/A',
                            animalName: reservation['animalName'] ?? 'N/A',
                            animalType: reservation['animalType'] ?? 'N/A',
                            date: reservation['date'] ?? 'N/A',
                            address: reservation['address'] ?? 'N/A',
                            status: reservation['status'] ?? 'N/A',
                            onTap: () {
                              GoRouter.of(context).push(
                                '/history/reservationDetails',
                                extra: reservation,
                              );
                            },
                          );
                        },
                        childCount: reservations.length,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
