import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_image_section.dart';

class SearchResultImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const SearchResultImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: EnhancedImageSection(
          imageUrls: [imageUrl],
          height: height,
          width: width,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          showIndicator: false,
        ),
      ),
    );
  }
}
