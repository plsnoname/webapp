import 'package:flutter/material.dart';

/// Base class for all image components to reduce code duplication
abstract class BaseImageWidget extends StatelessWidget {
  final List<String> imageUrls;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final String fallbackAssetPath;
  final bool fullScreenOnTap;
  final VoidCallback? onTap;

  const BaseImageWidget({
    Key? key,
    required this.imageUrls,
    required this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    required this.fallbackAssetPath,
    this.fullScreenOnTap = false,
    this.onTap,
  }) : super(key: key);

  // Common method to build a fallback image
  Widget buildFallbackImage() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Image.asset(
        fallbackAssetPath,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
      ),
    );
  }

  // Common method to build a loading indicator
  Widget buildLoadingIndicator(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(12),
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

  // Common method to handle image taps
  void handleImageTap(BuildContext context, String imageUrl) {
    if (onTap != null) {
      onTap!();
    } else if (fullScreenOnTap) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _FullScreenImage(
            imageUrl: imageUrl,
            fallbackAssetPath: fallbackAssetPath,
            fit: fit,
          ),
        ),
      );
    }
  }
}

// Full screen image viewer implementation
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
        iconTheme: const IconThemeData(color: Colors.white),
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
