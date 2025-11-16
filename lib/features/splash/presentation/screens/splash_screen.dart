import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../dependencies.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final firebaseAuth = getIt<FirebaseAuth>();
      await firebaseAuth.currentUser?.reload();

      if (firebaseAuth.currentUser == null) {
        if (mounted) {
          context.go('/enter-number');
        }

        return;
      }

      if (firebaseAuth.currentUser != null &&
          firebaseAuth.currentUser!.displayName == null) {
        if (mounted) {
          context.go('/new-user');
        }

        return;
      }

      if (firebaseAuth.currentUser != null &&
          firebaseAuth.currentUser!.displayName != null) {
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Something went wrong. Please try again later'),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
