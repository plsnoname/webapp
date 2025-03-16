import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_header_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_basic_info_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_health_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_questions_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_payment_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_options_section.dart';
import 'package:fatcherappv2/features/history/widgets/reservation_review_section.dart';

class ReservationContentWidget extends StatelessWidget {
  final Map<String, dynamic> reservation;
  final String reservationId;

  const ReservationContentWidget({
    Key? key,
    required this.reservation,
    required this.reservationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReservationHeaderSection(reservation: reservation),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Reservation Code: ${reservation['reservation_code']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ReservationBasicInfoSection(reservation: reservation),
            const SizedBox(height: 16.0),
            ReservationHealthSection(healthInfo: reservation['health_info']),
            const SizedBox(height: 16.0),
            ReservationQuestionsSection(questions: reservation['questions']),
            const SizedBox(height: 16.0),
            ReservationPaymentSection(payment: reservation['payment']),
            const SizedBox(height: 16.0),
            ReservationOptionsSection(options: reservation['extra_options']),
            const SizedBox(height: 16.0),
            ReservationReviewSection(
              reservation: reservation,
              reservationId: reservationId,
            ),
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
