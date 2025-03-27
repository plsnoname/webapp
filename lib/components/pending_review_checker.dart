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
    final auth = Provider.of<Auth>(context, listen: false);
    _checkAuthState(auth);
    auth.addListener(() {
      _checkAuthState(auth);
    });
  }

  Future<void> _checkAuthState(Auth auth) async {
    final isLoggedIn = await auth.isLoggedIn;
    if (isLoggedIn) {
      _hasCheckedReviews = false;
      _checkPendingReviews();
    }
  }

  Future<void> _checkPendingReviews() async {
    if (_hasCheckedReviews) {
      return;
    }

    final userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    if (userProvider.isLoading) {
      await userProvider.loadUserData();

      userProvider.addListener(() {
        if (!userProvider.isLoading && mounted && !_hasCheckedReviews) {
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

    if (userProvider.hasPendingReviews()) {
      final reservationId = userProvider.getFirstPendingReview();
      if (reservationId != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          _showPendingReviewDialog(reservationId);
        });
      }
    }
  }

  Future<void> _showPendingReviewDialog(String reservationId) async {
    try {
      String jsonPath = 'assets/data/$reservationId.json';
      final String response = await rootBundle.loadString(jsonPath);
      final data = json.decode(response);

      if (!mounted) {
        return;
      }

      final result = await ReviewDialog.show(
        context: context,
        title: 'Review ${data['hotel_name']}',
        reservationId: reservationId,
      );

      if (result != null && result['submitted'] == true) {
        final userProvider =
            Provider.of<UserProfileProvider>(context, listen: false);
        await userProvider.removePendingReview(reservationId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Thank you for your review!')));
        }
      }
    } catch (e) {
      // Silent error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
