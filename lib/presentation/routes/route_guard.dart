import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play/core/config/supabase_config.dart';

class RouteGuard extends GoRouteData {
  static String? redirectIfNotAuthenticated(BuildContext context, GoRouterState state) {
    // Allow access to splash screen
    if (state.matchedLocation == '/splash') {
      return null;
    }

    final isAuthenticated = SupabaseConfig.client.auth.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    // If user is not authenticated
    if (!isAuthenticated) {
      // Allow access to auth routes (login/signup)
      if (isAuthRoute) {
        return null;
      }
      // Redirect to login for all other routes
      return '/login';
    }

    // If user is authenticated
    if (isAuthRoute) {
      // Redirect to home if trying to access auth routes
      return '/';
    }

    // Allow access to the requested route
    return null;
  }
} 