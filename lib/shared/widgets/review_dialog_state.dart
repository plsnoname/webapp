import 'package:flutter/material.dart';
import 'review_dialog.dart';
import 'components/review_rating_section.dart';
import 'components/review_text_field.dart';
import 'components/review_action_buttons.dart';

class ReviewDialogState extends State<ReviewDialog> {
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

  void _onRatingChanged(int newRating) {
    setState(() {
      _rating = newRating;
      _updateSubmitState();
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
          Text(
            widget.title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          ReviewRatingSection(
            rating: _rating,
            onRatingChanged: _onRatingChanged,
          ),
          SizedBox(height: 20.0),
          ReviewTextField(
            controller: _reviewController,
            context: context,
          ),
          SizedBox(height: 20.0),
          ReviewActionButtons(
            isSubmitEnabled: _isSubmitEnabled,
            onCancel: () => Navigator.of(context).pop(),
            onSubmit: () => widget.onSubmit(_rating, _reviewController.text),
            context: context,
          ),
        ],
      ),
    );
  }
}
