import 'package:flutter/material.dart';

/// Provides reusable form field validators
class FormValidators {
  /// Validates required fields
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates minimum string length
  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < minLength) {
      return 'Please enter at least $minLength characters';
    }

    return null;
  }

  /// Creates a custom validator with a specific error message
  static FormFieldValidator<String> custom(
      bool Function(String?) test, String errorMessage) {
    return (String? value) {
      if (!test(value)) {
        return errorMessage;
      }
      return null;
    };
  }
}
