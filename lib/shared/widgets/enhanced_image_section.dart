import 'package:flutter/material.dart';
import 'base_image.dart';

/**
 * EnhancedImageSection - Unified image carousel/display component
 * 
 * This component extends BaseImageWidget to reduce code duplication
 */

class EnhancedImageSection extends BaseImageWidget {
  final bool showIndicator;
  final EdgeInsets? padding;

  const EnhancedImageSection({
    Key? key,
    required List<String> imageUrls,
    double height = 250,
    double? width,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
    String fallbackAssetPath = 'assets/images/hotel_dummy_photo.jpeg',
    this.showIndicator = true,
    this.padding,
    bool fullScreenOnTap = false,
    VoidCallback? onTap,
  }) : super(
          key: key,
          imageUrls: imageUrls,
          height: height,
          width: width,
          borderRadius: borderRadius,
          fit: fit,
          fallbackAssetPath: fallbackAssetPath,
          fullScreenOnTap: fullScreenOnTap,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    // If only one image or empty list (use fallback), show simple image
    if (imageUrls.isEmpty || imageUrls.length <= 1) {
      return _buildSingleImage(
          context, imageUrls.isNotEmpty ? imageUrls[0] : "");
    }

    // If multiple images, show carousel
    return _buildImageCarousel(context);
  }

  Widget _buildSingleImage(BuildContext context, String imageUrl) {
    Widget imageWidget = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return buildFallbackImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return buildLoadingIndicator(context);
        },
      ),
    );

    if (fullScreenOnTap || onTap != null) {
      return GestureDetector(
        onTap: () => handleImageTap(context, imageUrl),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildImageCarousel(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        int currentIndex = 0;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Slideshow using PageView
            Container(
              height: height,
              width: width ?? double.infinity,
              padding: padding,
              child: PageView.builder(
                itemCount: imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleImageTap(context, imageUrls[index]),
                    child: ClipRRect(
                      borderRadius: borderRadius ?? BorderRadius.circular(12),
                      child: Image.network(
                        imageUrls[index],
                        fit: fit,
                        height: height,
                        width: width ?? double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return buildFallbackImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return buildLoadingIndicator(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator for Slideshow
            if (showIndicator && imageUrls.length > 1)
              Positioned(
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentIndex == index ? 10 : 8,
                      height: currentIndex == index ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
