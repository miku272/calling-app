import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import './core/screens/not_found_screen.dart';

import './features/auth/presentation/screens/signup_screen.dart';
import './features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      if (!isLoggedIn && state.fullPath != '/signup') {
        return '/signup';
      }

      return null;
    },
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
}
