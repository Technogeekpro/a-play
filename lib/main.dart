import 'package:a_play/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play/core/config/supabase_config.dart';
import 'package:a_play/core/routes/app_routes.dart';
import 'package:a_play/core/services/location_service.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SupabaseConfig.initialize();
    
    // Initialize location service only on mobile platforms
    if (!kIsWeb && !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
      final locationService = LocationService();
      await locationService.handleLocationPermission();
    }
    
    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    debugPrint('Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Error initializing app: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'A Play World',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
