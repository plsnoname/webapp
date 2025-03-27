import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Added for web
import 'routes/route_generator.dart';
import 'providers/auth.dart';
import 'providers/user_profile_provider.dart';
import 'components/auto_login_checker.dart';
import 'components/pending_review_checker.dart';
import 'design_system/index.dart';

// Configure storage with web compatibility
final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
  webOptions: WebOptions(
    dbName: 'fetcher_auth',
    publicKey: 'fetcher_public_key',
  ),
);
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
final Auth0 auth0 =
    Auth0('dev-fetcher.eu.auth0.com', 'i6dbl8SB0sjWf4oAf0K9NzNTHB1rRWyL');

Future<void> checkStoredCredentials() async {
  final String? accessToken = await secureStorage.read(key: 'accessToken');
  isLoggedIn.value = accessToken != null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await checkStoredCredentials();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, UserProfileProvider>(
          create: (context) => UserProfileProvider(),
          update: (context, auth, previous) {
            // Reload user profile when auth changes
            Future.microtask(() async {
              if (await auth.isLoggedIn && previous != null) {
                previous.loadUserData();
              } else if (previous != null && !(await auth.isLoggedIn)) {
                previous.clearData();
              }
            });
            return previous ?? UserProfileProvider();
          },
        ),
      ],
      child: AutoLoginChecker(
        child: PendingReviewChecker(
          child: MaterialApp.router(
            title: 'Booking App',
            theme: AppTheme.lightTheme,
            routerDelegate: goRouter.routerDelegate,
            routeInformationParser: goRouter.routeInformationParser,
            routeInformationProvider: goRouter.routeInformationProvider,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

// Remove MyHomePage class as it's mobile-specific with AppLinks
// We'll handle auth callbacks through the router instead
