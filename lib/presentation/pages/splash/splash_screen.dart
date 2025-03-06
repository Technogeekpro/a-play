import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play_world/presentation/pages/auth/controller/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure proper initialization
    Timer(const Duration(seconds: 2), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final authState = ref.read(authControllerProvider);
    authState.whenData((user) {
      if (mounted) {
        if (user != null) {
          context.go('/');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Full Screen Splash Screen with centered image and background color
    return Container(
      color: const Color(0xFF050B17), // Background color
      child: Center(
        child: Image.asset('assets/images/splash.png', fit: BoxFit.contain), // Centered image
      ),
    );
  }
} 