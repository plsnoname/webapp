import 'package:flutter/material.dart';

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
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  late int _rating;
  late TextEditingController _reviewController;
  bool _isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
    _reviewController = TextEditingController(text: widget.initialReview ?? '');
    _updateSubmitState();

    // Listen for changes in the text field
    _reviewController.addListener(_updateSubmitState);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _updateSubmitState() {
    setState(() {
      // Enable submit only when a rating is selected and review has some text
      _isSubmitEnabled =
          _rating > 0 && _reviewController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),

          // Star Rating
          Text(
            "Rate your experience",
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                    _updateSubmitState();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.amber : Colors.grey,
                    size: 36.0,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10.0),
          Text(
            _getRatingText(),
            style: TextStyle(
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 20.0),

          // Review Text Field
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.all(12.0),
              ),
              maxLines: null,
              minLines: 4,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(height: 20.0),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _isSubmitEnabled
                    ? () => widget.onSubmit(_rating, _reviewController.text)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text('SUBMIT'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap a star to rate';
    }
  }
}
