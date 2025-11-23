import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import './dependencies.dart';
import './shell_scaffold.dart';

import './core/screens/not_found_screen.dart';

import './features/splash/presentation/screens/splash_screen.dart';
import './features/auth/presentation/screens/enter_number_screen.dart';
import './features/auth/presentation/screens/verify_otp_screen.dart';
import './features/auth/presentation/screens/new_user_screen.dart';

import './features/home/presentation/screens/home_screen.dart';

import './features/settings/presentation/screens/settings_screen.dart';

/// Central router configuration for the application.
///
/// This class defines all routes and navigation logic using GoRouter.
/// It handles authentication-based route guards and navigation flow.
class AppRouter {
  /// The main GoRouter instance for the application.
  ///
  /// Features:
  /// - **Authentication guards**: Redirects unauthenticated users to login
  /// - **Public routes**: `/enter-number`, `/verify-otp`, `/new-user`
  /// - **Protected routes**: All other routes require authentication
  /// - **Shell routes**: Authenticated screens with bottom navigation
  /// - **Initial route**: `/splash` for app initialization
  ///
  /// Route structure:
  /// ```
  /// /splash              - Initial splash screen
  /// /enter-number        - Phone number entry (public)
  /// /verify-otp          - OTP verification (public)
  /// /new-user            - New user profile setup (public)
  /// /                    - Home screen (protected, with shell)
  /// /calls               - Calls screen (protected, with shell)
  /// /people              - People/contacts screen (protected, with shell)
  /// /settings            - Settings screen (protected, with shell)
  /// ```
  ///
  /// The router automatically:
  /// - Redirects unauthenticated users to `/enter-number`
  /// - Prevents authenticated users from accessing auth screens
  /// - Shows a 404 screen for unknown routes
  static final router = GoRouter(
    /// Global redirect logic for authentication-based navigation.
    ///
    /// Handles route guards to protect authenticated routes and prevent
    /// authenticated users from accessing public auth screens.
    ///
    /// Returns:
    /// - `null` to allow navigation to the requested route
    /// - A redirect path to navigate to a different route
    redirect: (context, state) {
      if (state.fullPath == '/splash') {
        return null;
      }

      final isLoggedIn = getIt<FirebaseAuth>().currentUser != null;
      final currentUser = getIt<FirebaseAuth>().currentUser;

      // Allow these paths when not logged in
      const publicPaths = ['/enter-number', '/verify-otp', '/new-user'];

      // If not logged in and trying to access protected route
      if (!isLoggedIn && !publicPaths.contains(state.matchedLocation)) {
        return '/enter-number';
      }

      // If logged in with display name set, prevent access to auth screens
      if (isLoggedIn &&
          currentUser?.displayName != null &&
          publicPaths.contains(state.matchedLocation)) {
        return '/';
      }

      return null;
    },
    initialLocation: '/splash',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/enter-number',
        builder: (context, state) => const EnterNumberScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final phoneAuthCredential = state.extra;
          final verificationId = state.uri.queryParameters['verificationId'];
          final resendToken = state.uri.queryParameters['resendToken'];

          if (phoneAuthCredential is! PhoneAuthCredential?) {
            return const NotFoundScreen(
              title: 'Error',
              message: 'Invalid phone authentication credential.',
            );
          }

          return VerifyOtpScreen(
            phoneAuthCredential: phoneAuthCredential,
            verificationId: verificationId,
            resendCode: int.tryParse(resendToken ?? ''),
          );
        },
      ),
      GoRoute(
        path: '/new-user',
        builder: (context, state) => const NewUserScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(state: state, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          // GoRoute(
          //   path: '/calls',
          //   builder: (context, state) =>
          //       const PlaceholderScreen(title: 'Calls'),
          // ),
          // GoRoute(
          //   path: '/people',
          //   builder: (context, state) =>
          //       const PlaceholderScreen(title: 'People'),
          // ),
          GoRoute(
            path: '/settings',
            builder: (context, state) {
              return const SettingsScreen();
            },
          ),
        ],
      ),
    ],
  );
}
