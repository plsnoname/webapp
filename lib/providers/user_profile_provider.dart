import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  List<String> _pendingReviews = [];
  bool _isLoading = true;
  String? _error;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserProfileProvider() {
    loadUserData();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;
  List<String> get pendingReviews => _pendingReviews;

  // Load user data from local storage
  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      // Don't notify here - we'll notify after data is loaded

      final String? accessToken = await _secureStorage.read(key: 'accessToken');
      if (accessToken == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load user data from json file
      final String response =
          await rootBundle.loadString('assets/data/usr01.json');
      _userData = json.decode(response);

      // Extract pending reviews
      if (_userData != null && _userData!.containsKey('pendingReviews')) {
        _pendingReviews = List<String>.from(_userData!['pendingReviews']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load user data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove a reservation ID from pending reviews
  Future<void> removePendingReview(String reservationId) async {
    if (_userData == null) return;

    _pendingReviews.remove(reservationId);

    // Update the user data structure
    if (_userData!.containsKey('pendingReviews')) {
      _userData!['pendingReviews'] = _pendingReviews;
    }

    // In a real app, this would send an API request to update the backend
    notifyListeners();

    // For demo purposes, save to secure storage to persist the change
    await _secureStorage.write(
      key: 'pendingReviews',
      value: json.encode(_pendingReviews),
    );
  }

  // Check if there are any pending reviews
  bool hasPendingReviews() {
    return _pendingReviews.isNotEmpty;
  }

  // Get the first pending review
  String? getFirstPendingReview() {
    return _pendingReviews.isNotEmpty ? _pendingReviews.first : null;
  }

  // Clear data when logging out
  void clearData() {
    _userData = null;
    _pendingReviews = [];
    _error = null;
    notifyListeners();
  }
}
