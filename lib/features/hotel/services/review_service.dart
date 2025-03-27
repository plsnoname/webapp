import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/review.dart';

class ReviewService {
  /// Loads reviews from a JSON file
  static Future<List<Review>> loadReviews(String filePath) async {
    try {
      final jsonString = await rootBundle.loadString(filePath);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final reviewsJson = data['reviews'] as List;

      return reviewsJson
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
