import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'review_card.dart';
import 'package:fatcherappv2/shared/widgets/unified_button.dart';
import 'package:fatcherappv2/design_system/index.dart';

class ReviewsSection extends StatefulWidget {
  const ReviewsSection({Key? key}) : super(key: key);

  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _showAllReviews = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final reviews =
          await ReviewService.loadReviews('assets/data/reviews01.json');
      setState(() {
        // Sort reviews by date (most recent first)
        _reviews = reviews..sort((a, b) => b.date.compareTo(a.date));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
        ),
      );
    }

    if (_reviews.isEmpty) {
      return Center(
        child: Text(
          'No reviews available.',
          style: AppTypography.bodyMedium,
        ),
      );
    }

    // Determine which reviews to display
    List<Review> displayedReviews =
        _showAllReviews ? _reviews : _reviews.take(3).toList();

    bool hasMoreReviews = _reviews.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...displayedReviews.map((review) => ReviewCard(review: review)),
        if (hasMoreReviews && !_showAllReviews)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: UnifiedButton(
              text: 'See All Reviews',
              onPressed: () {
                setState(() {
                  _showAllReviews = true;
                });
              },
              // For outlined style, use primary color for the text and border
              textColor: AppColors.primary,
              // Remove backgroundColor for outline style
              buttonStyle: UnifiedButtonStyle.outlined,
            ),
          ),
        if (_showAllReviews)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: UnifiedButton(
              text: 'Show Less',
              onPressed: () {
                setState(() {
                  _showAllReviews = false;
                });
              },
              // For text style, ensure contrast with background
              textColor: AppColors.primary,
              backgroundColor: Colors.transparent,
              buttonStyle: UnifiedButtonStyle.text,
            ),
          ),
      ],
    );
  }
}
