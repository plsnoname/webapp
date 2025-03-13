import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/providers/auth.dart';
import 'package:fatcherappv2/shared/widgets/custom_button.dart';
import 'package:fatcherappv2/design_system/spacing.dart';

class LoginGuard extends StatefulWidget {
  final Widget child;

  const LoginGuard({Key? key, required this.child}) : super(key: key);

  @override
  _LoginGuardState createState() => _LoginGuardState();
}

class _LoginGuardState extends State<LoginGuard> {
  late Future<bool> _isLoggedInFuture;

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = _checkLoginStatus();
    final auth = Provider.of<Auth>(context, listen: false);
    auth.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    final auth = Provider.of<Auth>(context, listen: false);
    auth.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    setState(() {
      _isLoggedInFuture = _checkLoginStatus();
    });
  }

  Future<bool> _checkLoginStatus() async {
    final auth = Provider.of<Auth>(context, listen: false);
    return await auth.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return widget.child;
        } else {
          return Stack(
            children: [
              widget.child,
              Center(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: AlertDialog(
                    title: const Text("Login Required"),
                    content: const Text("Please log in to continue."),
                    actions: [
                      CustomButton(
                        text: "Log in",
                        onPressed: () async {
                          final auth =
                              Provider.of<Auth>(context, listen: false);
                          await auth.login(context);
                          setState(() {
                            _isLoggedInFuture = _checkLoginStatus();
                          });
                        },
                      ),
                      AppSpacing.horizontalSpaceSM,
                      CustomButton(
                        text: "Go Back",
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
