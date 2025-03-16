import 'package:flutter/material.dart';
import 'review_dialog_state.dart';

class ReviewDialog extends StatefulWidget {
  final String title;
  final Function(int rating, String review) onSubmit;
  final String? initialReview;
  final int? initialRating;
  final String? reservationId;

  const ReviewDialog({
    Key? key,
    required this.title,
    required this.onSubmit,
    this.initialReview,
    this.initialRating,
    this.reservationId,
  }) : super(key: key);

  /// Shows the review dialog and returns the result when submitted
  /// Returns null if cancelled
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required String title,
    String? initialReview,
    int? initialRating,
    String? reservationId,
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ReviewDialog(
            title: title,
            initialReview: initialReview,
            initialRating: initialRating,
            reservationId: reservationId,
            onSubmit: (rating, review) {
              Navigator.of(context).pop({
                'rating': rating,
                'review': review,
                'reservationId': reservationId,
                'submitted': true,
              });
            },
          ),
        );
      },
    );
  }

  @override
  ReviewDialogState createState() => ReviewDialogState();
}
