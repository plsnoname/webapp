import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth.dart';
import '../shared/widgets/review_dialog.dart';

class PendingReviewChecker extends StatefulWidget {
  final Widget child;

  const PendingReviewChecker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _PendingReviewCheckerState createState() => _PendingReviewCheckerState();
}

class _PendingReviewCheckerState extends State<PendingReviewChecker> {
  bool _hasCheckedReviews = false;
  bool _isSetupComplete = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isSetupComplete) {
      _setupAuthListener();
      _isSetupComplete = true;
    }
  }

  void _setupAuthListener() {
    // Get auth provider and add listener
    final auth = Provider.of<Auth>(context, listen: false);

    // Check immediately in case already logged in
    _checkAuthState(auth);

    // Listen for changes in auth state
    auth.addListener(() {
      debugPrint('🔐 Auth state changed. Checking for pending reviews...');
      _checkAuthState(auth);
    });
  }

  Future<void> _checkAuthState(Auth auth) async {
    final isLoggedIn = await auth.isLoggedIn;
    debugPrint('👤 Auth state check: isLoggedIn = $isLoggedIn');

    if (isLoggedIn) {
      // Reset check flag when logging in
      _hasCheckedReviews = false;
      _checkPendingReviews();
    }
  }

  Future<void> _checkPendingReviews() async {
    if (_hasCheckedReviews) {
      debugPrint('🔄 Already checked for pending reviews. Skipping.');
      return;
    }

    final userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    debugPrint(
        '📋 Checking pending reviews. Provider loading: ${userProvider.isLoading}');

    // Make sure user data is loaded first
    if (userProvider.isLoading) {
      // Reload user data to ensure we have the latest
      await userProvider.loadUserData();

      // We'll check again when provider notifies
      userProvider.addListener(() {
        if (!userProvider.isLoading && mounted && !_hasCheckedReviews) {
          debugPrint('🔄 UserProfile loaded. Processing reviews...');
          _processPendingReviews(userProvider);
        }
      });
    } else {
      _processPendingReviews(userProvider);
    }
  }

  void _processPendingReviews(UserProfileProvider userProvider) {
    if (_hasCheckedReviews) return;
    _hasCheckedReviews = true;

    debugPrint(
        '📝 Processing pending reviews. Has reviews: ${userProvider.hasPendingReviews()}');

    if (userProvider.hasPendingReviews()) {
      final reservationId = userProvider.getFirstPendingReview();
      debugPrint('🏨 Found pending review for reservation: $reservationId');

      if (reservationId != null) {
        // Show dialog with slight delay to ensure UI is ready
        Future.delayed(const Duration(milliseconds: 1500), () {
          _showPendingReviewDialog(reservationId);
        });
      }
    } else {
      debugPrint('📭 No pending reviews found.');
    }
  }

  Future<void> _showPendingReviewDialog(String reservationId) async {
    try {
      debugPrint('🔍 Attempting to load reservation data: $reservationId');

      // Load reservation details for the review
      String jsonPath = 'assets/data/$reservationId.json';
      final String response = await rootBundle.loadString(jsonPath);
      final data = json.decode(response);

      debugPrint('✅ Successfully loaded reservation data for: $reservationId');

      if (!mounted) {
        debugPrint('⚠️ Widget no longer mounted. Skipping review dialog.');
        return;
      }

      final result = await ReviewDialog.show(
        context: context,
        title: 'Review ${data['hotel_name']}',
        reservationId: reservationId,
      );

      debugPrint('📊 Review dialog result: $result');

      if (result != null && result['submitted'] == true) {
        // Remove this review from pending reviews
        final userProvider =
            Provider.of<UserProfileProvider>(context, listen: false);
        await userProvider.removePendingReview(reservationId);

        debugPrint('✂️ Removed review from pending: $reservationId');

        // Show confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Thank you for your review!')));
        }
      }
    } catch (e) {
      debugPrint('❌ Error showing pending review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
