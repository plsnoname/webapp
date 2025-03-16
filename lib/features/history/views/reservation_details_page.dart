import 'package:flutter/material.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_loading_widget.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_error_widget.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_content_widget.dart';
import 'package:fatcherappv2/features/history/services/reservation_service.dart';

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
      final result =
          await ReservationService.loadReservation(widget.reservationId);
      setState(() {
        reservation = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        loadError = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ReservationLoadingWidget();
    }

    if (loadError != null) {
      return ReservationErrorWidget(error: loadError!);
    }

    if (reservation == null) {
      return const ReservationErrorWidget(
          error: 'No reservation details found');
    }

    return ReservationContentWidget(
      reservation: reservation!,
      reservationId: widget.reservationId,
    );
  }
}
