import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final String fallbackAssetPath;

  const ImageSection({
    Key? key,
    required this.imageUrls,
    this.height = 250,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallbackAssetPath = 'assets/images/hotel_dummy_photo.jpeg',
  }) : super(key: key);

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // If only one image or empty list (use fallback), show simple image
    if (widget.imageUrls.length <= 1) {
      return _buildSingleImage(
          widget.imageUrls.isNotEmpty ? widget.imageUrls[0] : "");
    }

    // If multiple images, show carousel
    return _buildImageCarousel();
  }

  Widget _buildSingleImage(String imageUrl) {
    return ClipRRect(
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
  }

  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Slideshow using PageView
        SizedBox(
          height: widget.height,
          width: widget.width ?? double.infinity,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: widget.borderRadius ??
                    const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
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
              );
            },
          ),
        ),
        // Dots Indicator for Slideshow
        if (widget.imageUrls.length > 1)
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
    return SizedBox(
      height: widget.height,
      width: widget.width ?? double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
