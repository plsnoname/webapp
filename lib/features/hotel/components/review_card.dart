import 'package:flutter/material.dart';
import '../models/review.dart';
import 'package:fatcherappv2/design_system/index.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    review.author,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${review.rating}',
                      style: AppTypography.bodyMedium,
                    ),
                    AppSpacing.horizontalSpaceXS,
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.verticalSpaceXS,
            Text(
              review.date,
              style: AppTypography.bodySmall,
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              review.message,
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
