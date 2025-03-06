import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RouteGuard {
  static String? redirectIfNotAuthenticated(BuildContext context, GoRouterState state) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login';

    // If not authenticated and not on an auth route, redirect to login
    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }

    // If authenticated and on an auth route, redirect to home
    if (isAuthenticated && isAuthRoute) {
      return '/';
    }

    // No redirection needed
    return null;
  }
} 