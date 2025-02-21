import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AutoLoginChecker extends StatefulWidget {
  final Widget child;

  const AutoLoginChecker({Key? key, required this.child}) : super(key: key);

  @override
  _AutoLoginCheckerState createState() => _AutoLoginCheckerState();
}

class _AutoLoginCheckerState extends State<AutoLoginChecker> {
  late Future<void> _autoLoginFuture;

  @override
  void initState() {
    super.initState();
    _autoLoginFuture = _checkAndAutoLogin();
  }

  Future<void> _checkAndAutoLogin() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (await auth.isLoggedIn) {
      await auth.refreshAccessToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _autoLoginFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return widget.child;
        }
      },
    );
  }
}
