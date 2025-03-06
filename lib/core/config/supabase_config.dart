// Supabase configuration settings 

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {

  // Database table names
  static const String usersTable = 'users';
  static const String eventsTable = 'events';
  static const String ticketsTable = 'tickets';
  static const String bookingsTable = 'bookings';
  static const String eventCategoriesTable = 'categories';

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://zhvkzdyvzmfrxdrtouqm.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpodmt6ZHl2em1mcnhkcnRvdXFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NjExNzgsImV4cCI6MjA1MjQzNzE3OH0.uZjYaRpsmsQY5YIuMaebbTc8VFYUMEqNjR5_NIZWp8g',
      debug: false,
    );
  }

  // Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  // Get current user
  static User? get currentUser => client.auth.currentUser;

  // Get current session
  static Session? get currentSession => client.auth.currentSession;
} 