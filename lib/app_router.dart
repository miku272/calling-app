import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import './core/screens/not_found_screen.dart';

import './features/auth/presentation/screens/login_screen.dart';
import './features/auth/presentation/screens/signup_screen.dart';
import './features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      // If not logged in and trying to access protected routes, redirect to login
      if (!isLoggedIn &&
          state.fullPath != '/login' &&
          state.fullPath != '/signup') {
        return '/login';
      }

      // If logged in and trying to access auth screens, redirect to home
      if (isLoggedIn &&
          (state.fullPath == '/login' || state.fullPath == '/signup')) {
        return '/';
      }

      return null;
    },
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
}
