import 'package:flutter/material.dart';
import '../widgets/enhanced_image_section.dart';

/// Helper to create common image section configurations
class ImageSectionFactory {
  /// Creates a standard card header image
  static EnhancedImageSection cardHeader({
    required List<String> urls,
    double height = 180,
  }) {
    return EnhancedImageSection(
      imageUrls: urls,
      height: height,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      showIndicator: urls.length > 1,
    );
  }

  /// Creates a detail view image with full-screen capability
  static EnhancedImageSection detailView({
    required List<String> urls,
    double height = 250,
  }) {
    return EnhancedImageSection(
      imageUrls: urls,
      height: height,
      fullScreenOnTap: true,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
