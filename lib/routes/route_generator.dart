import 'package:fatcherappv2/features/make_reservation/view/animal_form.dart';
import 'package:fatcherappv2/features/make_reservation/view/animal_form_stage_two.dart';
import 'package:fatcherappv2/features/make_reservation/view/reservation_summary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fatcherappv2/features/history/views/history_screen.dart';
import 'package:fatcherappv2/features/hotel/views/hotel_details_screen.dart';
import 'package:fatcherappv2/features/home/views/main_screen.dart';
import 'package:fatcherappv2/features/profile/views/profile_screen.dart';
import 'package:fatcherappv2/routes/scaffold_with_nested_navigation.dart';
import 'package:fatcherappv2/components/in_app_webview.dart';
import 'package:fatcherappv2/features/history/components/reservation_details_page.dart';
import 'package:fatcherappv2/features/make_reservation/view/extras_selector.dart';

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
                      path: 'animalForm',
                      builder: (context, state) {
                        final hotelName =
                            state.extra as String? ?? 'Unknown Hotel';
                        return AnimalFormPage(
                          hotelName: hotelName,
                          onNext: () {
                            GoRouter.of(context).go(
                                '/home/hotelDetails/animalForm/animalFormStageTwo');
                          },
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'animalFormStageTwo',
                          builder: (context, state) => AnimalFormStageTwo(),
                          routes: [
                            GoRoute(
                              path: 'extrasSelector',
                              builder: (context, state) => ExtrasSelector(),
                              routes: [
                                GoRoute(
                                  path: 'summary',
                                  builder: (context, state) {
                                    final reservationData =
                                        state.extra as Map<String, dynamic>;
                                    return ReservationSummary(
                                        reservationData: reservationData);
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
                    final reservation = state.extra as Map<String, dynamic>;
                    return ReservationDetailsPage(reservation: reservation);
                  },
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
