import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'routes/route_generator.dart';
import 'providers/auth.dart';
import 'providers/user_profile_provider.dart';
import 'components/auto_login_checker.dart';
import 'components/pending_review_checker.dart';
import 'design_system/index.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
final Auth0 auth0 =
    Auth0('dev-fetcher.eu.auth0.com', 'i6dbl8SB0sjWf4oAf0K9NzNTHB1rRWyL');

Future<void> checkStoredCredentials() async {
  final String? accessToken = await secureStorage.read(key: 'accessToken');
  debugPrint('🔑 Main: Initial login state: ${accessToken != null}');
  isLoggedIn.value = accessToken != null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initAppLinks();
  }

  Future<void> _initAppLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        Provider.of<Auth>(context, listen: false)
            .handleAuthCallback(Uri.parse(initialLink.toString()));
      }

      _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          Provider.of<Auth>(context, listen: false).handleAuthCallback(uri);
        }
      });
    } catch (e) {
      debugPrint('Failed to handle deep link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fatcher App'),
      ),
      body: Center(
        child: Text('Welcome to Fatcher App'),
      ),
    );
  }
}
