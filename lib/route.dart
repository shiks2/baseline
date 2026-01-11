import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/Auth/screen/login_view.dart';
import 'package:sentio/Auth/screen/signup_view.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/splash_screen.dart';
import 'package:sentio/dashboard/dashboard_view.dart';
import 'package:sentio/profile/profile_view.dart';
import 'package:sentio/profile/profile_settings_view.dart';
import 'package:sentio/main_shell.dart';
import 'package:sentio/indexer/indexer_view.dart';
import 'package:sentio/library/library_view.dart';

class AppGlobalRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  final routes = GoRouter(
    initialLocation: SPLASH,
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[
      // Splash screen - standalone
      GoRoute(
        path: SPLASH,
        name: SPLASH,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      // Login route - standalone (not wrapped in MainShell)
      GoRoute(
        path: LOGIN,
        name: LOGIN,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginView(),
      ),
      // Sign-up route - standalone (not wrapped in MainShell)
      GoRoute(
        path: SIGNUP,
        name: SIGNUP,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignupView(),
      ),
      // Shell route for authenticated/app routes (Dashboard and other authenticated pages)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        navigatorKey: shellNavigatorKey,
        routes: [
          GoRoute(
            path: DASHBOARD,
            name: DASHBOARD,
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) => const DashboardView(),
          ),
          // Profile routes
          GoRoute(
            path: PROFILE_ROUTE,
            name: PROFILE_ROUTE,
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: PROFILE_SETTINGS_ROUTE,
            name: PROFILE_SETTINGS_ROUTE,
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) => const ProfileSettingsView(),
          ),
          // Indexer route
          GoRoute(
            path: INDEXER_ROUTE,
            name: INDEXER_ROUTE,
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) => const IndexerView(),
          ),
          // Library route
          GoRoute(
            path: LIBRARY_ROUTE,
            name: LIBRARY_ROUTE,
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) => const LibraryView(),
          ),
          // Add more authenticated routes here
        ],
      ),
    ],
  );
}
