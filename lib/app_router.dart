import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import './dependencies.dart';

import './core/screens/not_found_screen.dart';

import './features/splash/presentation/screens/splash_screen.dart';
import './features/auth/presentation/screens/enter_number_screen.dart';
import './features/auth/presentation/screens/verify_otp_screen.dart';
import './features/auth/presentation/screens/new_user_screen.dart';
import './features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
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
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
}
