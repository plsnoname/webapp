import 'package:fatcherappv2/features/make_reservation/view/reservation_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/features/history/views/history_screen.dart';
import 'package:fatcherappv2/features/hotel/views/hotel_details_screen.dart';
import 'package:fatcherappv2/features/home/views/main_screen.dart';
import 'package:fatcherappv2/features/profile/views/profile_screen.dart';
import 'package:fatcherappv2/routes/scaffold_with_nested_navigation.dart';
import 'package:fatcherappv2/components/in_app_webview.dart';
import 'package:fatcherappv2/features/history/views/reservation_details_page.dart';
import 'package:fatcherappv2/features/room_details/view/room_details.dart';
import 'package:fatcherappv2/features/profile/views/account_settings_page.dart';
import 'package:fatcherappv2/features/profile/views/privacy_settings_page.dart';
import 'package:fatcherappv2/features/profile/views/notification_settings_page.dart';
import 'package:fatcherappv2/features/profile/views/help_support_page.dart';
import 'package:fatcherappv2/features/messaging/views/chat_list_screen.dart';
import 'package:fatcherappv2/features/messaging/views/chat_screen.dart';
import 'package:fatcherappv2/features/profile/views/add_animal_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHistoryKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    if (state.uri.toString() == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const MainScreen(),
              routes: [
                GoRoute(
                  path: 'hotelDetails',
                  builder: (context, state) {
                    final hotelDetails = state.extra as Map<String, String>?;
                    return HotelDetailsScreen(hotelDetails: hotelDetails);
                  },
                  routes: [
                    GoRoute(
                      path: 'roomDetails',
                      builder: (context, state) {
                        final roomDetails = state.extra as Map<String, dynamic>;
                        return RoomDetailsPage(
                          imageUrls: roomDetails['imageUrls'],
                          roomDescription: roomDetails['roomDescription'],
                          tags: roomDetails['tags'],
                        );
                      },
                    ),
                    GoRoute(
                      path: 'animalForm',
                      builder: (context, state) {
                        final hotelName =
                            state.extra as String? ?? 'Unknown Hotel';
                        return DynamicFormScreen(hotelName: hotelName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHistoryKey,
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => HistoryScreen(),
              routes: [
                GoRoute(
                  path: 'reservationDetails',
                  builder: (context, state) {
                    final reservationId = state.extra as String;
                    return ReservationDetailsPage(
                      reservationId: reservationId,
                    );
                  },
                  routes: [
                    GoRoute(
                        path: 'chat',
                        builder: (context, state) {
                          final chatId = state.extra as String;
                          return ChatScreen(chatId: chatId);
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'accountSettings',
                  builder: (context, state) => const AccountSettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'addAnimal',
                      builder: (context, state) {
                        final onAddAnimal =
                            state.extra as Function(Map<String, dynamic>);
                        return AddAnimalPage(onAddAnimal: onAddAnimal);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'privacySettings',
                  builder: (context, state) => const PrivacySettingsPage(),
                ),
                GoRoute(
                  path: 'notificationSettings',
                  builder: (context, state) => const NotificationSettingsPage(),
                ),
                GoRoute(
                  path: 'helpSupport',
                  builder: (context, state) => const HelpSupportPage(),
                ),
                GoRoute(
                  path: 'messages',
                  builder: (context, state) => ChatListScreen(),
                  routes: [
                    GoRoute(
                      path: 'chat',
                      builder: (context, state) {
                        final chatId = state.extra as String;
                        return ChatScreen(chatId: chatId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/in-app-webview',
      builder: (context, state) {
        final url = state.extra as String;
        return InAppWebViewPage(url: url);
      },
    ),
  ],
);
