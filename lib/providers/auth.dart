import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class Auth with ChangeNotifier {
  static const String domain = 'dev-fetcher.eu.auth0.com';
  static const String clientId = 'i6dbl8SB0sjWf4oAf0K9NzNTHB1rRWyL';
  static const String redirectUri =
      'com.example.fatcherappv2://dev-fetcher.eu.auth0.com/android/com.example.fatcherappv2/callback';
  static const String logoutUri =
      'com.example.fatcherappv2://dev-fetcher.eu.auth0.com/android/com.example.fatcherappv2/logout';

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isLoggedIn = false;

  Auth() {
    // Check login status on initialization
    _checkLoginStatus();
  }

  // Public getter to access login state
  Future<bool> get isLoggedIn async {
    await _checkLoginStatus();
    return _isLoggedIn;
  }

  // Check if user is logged in by looking for an access token
  Future<void> _checkLoginStatus() async {
    final String? accessToken = await secureStorage.read(key: 'accessToken');
    final bool wasLoggedIn = _isLoggedIn;
    _isLoggedIn = accessToken != null;

    // Only notify if state actually changed
    if (wasLoggedIn != _isLoggedIn) {
      debugPrint('🔐 Auth: Login state changed to: $_isLoggedIn');
      notifyListeners();
    }
  }

  Future<void> login(BuildContext context) async {
    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      await secureStorage.write(key: 'code_verifier', value: codeVerifier);

      final url = Uri.parse('https://$domain/authorize'
          '?response_type=code'
          '&client_id=$clientId'
          '&code_challenge=$codeChallenge'
          '&code_challenge_method=S256'
          '&redirect_uri=$redirectUri'
          '&scope=openid email');

      final result =
          await context.push<String>('/in-app-webview', extra: url.toString());

      if (result != null) {
        final uri = Uri.parse(result);
        final queryParams = uri.queryParameters;
        final code = queryParams['code'];
        if (code == null) {
          throw Exception('Authorization code not found in callback URL');
        }

        final storedVerifier = await secureStorage.read(key: 'code_verifier');
        if (storedVerifier == null) {
          throw Exception('Code verifier not found in secure storage');
        }

        final response = await http.post(
          Uri.parse('https://$domain/oauth/token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'grant_type': 'authorization_code',
            'client_id': clientId,
            'code': code,
            'code_verifier': storedVerifier,
            'redirect_uri': redirectUri,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          await secureStorage.write(
              key: 'accessToken', value: data['access_token']);
          await secureStorage.write(
              key: 'refreshToken', value: data['refresh_token']);
          await secureStorage.write(
            key: 'expiresAt',
            value: (DateTime.now().millisecondsSinceEpoch +
                    (data['expires_in'] * 1000))
                .toString(),
          );

          debugPrint('Access Token: ${data['access_token']}');
          debugPrint('Refresh Token: ${data['refresh_token']}');
          _isLoggedIn = true;
          notifyListeners();
        } else {
          debugPrint('Token exchange failed: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }

  Future<void> handleAuthCallback(Uri uri) async {
    try {
      final queryParams = uri.queryParameters;
      final code = queryParams['code'];
      if (code == null) {
        throw Exception('Authorization code not found in callback URL');
      }

      final codeVerifier = await secureStorage.read(key: 'code_verifier');
      if (codeVerifier == null) {
        throw Exception('Code verifier not found in secure storage');
      }

      final response = await http.post(
        Uri.parse('https://$domain/oauth/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'grant_type': 'authorization_code',
          'client_id': clientId,
          'code': code,
          'code_verifier': codeVerifier,
          'redirect_uri': redirectUri,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        await secureStorage.write(
            key: 'accessToken', value: data['access_token']);
        await secureStorage.write(
            key: 'refreshToken', value: data['refresh_token']);
        await secureStorage.write(
          key: 'expiresAt',
          value: (DateTime.now().millisecondsSinceEpoch +
                  (data['expires_in'] * 1000))
              .toString(),
        );
        _isLoggedIn = true;
        notifyListeners();
      } else {
        debugPrint('Token exchange failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Auth callback error: $e');
    }
  }

  Future<void> refreshAccessToken() async {
    try {
      final refreshToken = await secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await http.post(
        Uri.parse('https://$domain/oauth/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'grant_type': 'refresh_token',
          'client_id': clientId,
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        await secureStorage.write(
            key: 'accessToken', value: data['access_token']);
        await secureStorage.write(
          key: 'expiresAt',
          value: (DateTime.now().millisecondsSinceEpoch +
                  (data['expires_in'] * 1000))
              .toString(),
        );
        _isLoggedIn = true;
        notifyListeners();
      } else {
        debugPrint('Token refresh failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await secureStorage.deleteAll();
      final url = Uri.https(domain, '/v2/logout', {
        'client_id': clientId,
        'returnTo': logoutUri,
      });
      await context.push<String>('/in-app-webview', extra: url.toString());
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final codeVerifierBytes =
        List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(codeVerifierBytes).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}
