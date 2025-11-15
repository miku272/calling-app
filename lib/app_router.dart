import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import './dependencies.dart';

import './core/screens/not_found_screen.dart';

import './features/auth/presentation/screens/enter_number_screen.dart';
import './features/auth/presentation/screens/verify_otp_screen.dart';
import './features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = getIt<FirebaseAuth>().currentUser != null;

      if (!isLoggedIn &&
          state.fullPath != '/enter-number' &&
          state.fullPath != '/verify-otp') {
        return '/enter-number';
      }

      if (isLoggedIn &&
          (state.fullPath == '/enter-number' ||
              state.fullPath == '/verify-otp')) {
        return '/';
      }

      return null;
    },
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
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
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
}
