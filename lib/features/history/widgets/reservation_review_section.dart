import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fatcherappv2/shared/widgets/review_dialog.dart';
import 'package:fatcherappv2/providers/user_profile_provider.dart';
import 'package:fatcherappv2/features/history/services/reservation_service.dart';

class ReservationReviewSection extends StatelessWidget {
  final Map<String, dynamic> reservation;
  final String reservationId;

  const ReservationReviewSection({
    Key? key,
    required this.reservation,
    required this.reservationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showReviewButton =
        ReservationService.isRecentlyCompleted(reservation);

    if (!showReviewButton) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => _handleReviewTap(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text(
            'Add Review',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _handleReviewTap(BuildContext context) async {
    final result = await ReviewDialog.show(
      context: context,
      title: 'Review ${reservation['hotel_name']}',
      reservationId: reservationId,
    );

    if (result != null && result['submitted'] == true) {
      // Process the review submission
      print('Rating: ${result['rating']}, Review: ${result['review']}');

      // Remove from pending reviews if it's there
      final userProvider =
          Provider.of<UserProfileProvider>(context, listen: false);
      await userProvider.removePendingReview(reservationId);

      // Show a confirmation
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your review!')),
        );
      }
    }
  }
}
