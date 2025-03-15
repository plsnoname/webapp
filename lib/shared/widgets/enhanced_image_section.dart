import 'package:flutter/material.dart';

/**
 * EnhancedImageSection - Unified image carousel/display component
 * 
 * This component replaces both:
 * - shared/widgets/image_section.dart
 * - features/hotel/components/image_section.dart
 * 
 * New features:
 * - Full screen view on tap
 * - Optional indicators
 * - Custom padding
 * - Custom tap handling
 * - Better loading states
 */

class EnhancedImageSection extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final String fallbackAssetPath;
  final bool showIndicator;
  final EdgeInsets? padding;
  final bool fullScreenOnTap;
  final VoidCallback? onTap;

  const EnhancedImageSection({
    Key? key,
    required this.imageUrls,
    this.height = 250,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallbackAssetPath = 'assets/images/hotel_dummy_photo.jpeg',
    this.showIndicator = true,
    this.padding,
    this.fullScreenOnTap = false,
    this.onTap,
  }) : super(key: key);

  @override
  _EnhancedImageSectionState createState() => _EnhancedImageSectionState();
}

class _EnhancedImageSectionState extends State<EnhancedImageSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // If only one image or empty list (use fallback), show simple image
    if (widget.imageUrls.isEmpty || widget.imageUrls.length <= 1) {
      return _buildSingleImage(
          widget.imageUrls.isNotEmpty ? widget.imageUrls[0] : "");
    }

    // If multiple images, show carousel
    return _buildImageCarousel();
  }

  Widget _buildSingleImage(String imageUrl) {
    Widget imageWidget = ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: widget.height,
        width: widget.width ?? double.infinity,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingIndicator();
        },
      ),
    );

    if (widget.fullScreenOnTap || widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap ??
            () {
              if (widget.fullScreenOnTap) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _FullScreenImage(
                      imageUrl: imageUrl,
                      fallbackAssetPath: widget.fallbackAssetPath,
                      fit: widget.fit,
                    ),
                  ),
                );
              }
            },
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildImageCarousel() {
    Widget carousel = Stack(
      alignment: Alignment.center,
      children: [
        // Slideshow using PageView
        Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          padding: widget.padding,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: widget.onTap ??
                    () {
                      if (widget.fullScreenOnTap) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => _FullScreenImage(
                              imageUrl: widget.imageUrls[index],
                              fallbackAssetPath: widget.fallbackAssetPath,
                              fit: widget.fit,
                            ),
                          ),
                        );
                      }
                    },
                child: ClipRRect(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: widget.fit,
                    height: widget.height,
                    width: widget.width ?? double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackImage();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoadingIndicator();
                    },
                  ),
                ),
              );
            },
          ),
        ),
        // Dots Indicator for Slideshow
        if (widget.showIndicator && widget.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 10 : 8,
                  height: _currentIndex == index ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return carousel;
  }

  Widget _buildFallbackImage() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      child: Image.asset(
        widget.fallbackAssetPath,
        height: widget.height,
        width: widget.width ?? double.infinity,
        fit: widget.fit,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackAssetPath;
  final BoxFit fit;

  const _FullScreenImage({
    Key? key,
    required this.imageUrl,
    required this.fallbackAssetPath,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                fallbackAssetPath,
                fit: fit,
              );
            },
          ),
        ),
      ),
    );
  }
}
