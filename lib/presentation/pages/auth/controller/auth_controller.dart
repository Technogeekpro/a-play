import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:a_play_world/core/config/supabase_config.dart';
import 'package:a_play_world/core/errors/auth_exceptions.dart' as app_auth;

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(SupabaseConfig.client);
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final SupabaseClient _client;
  String? _otpEmail;

  AuthController(this._client) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser != null) {
        state = AsyncValue.data(currentUser);
      } else {
        state = const AsyncValue.data(null);
      }

      _client.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        switch (event) {
          case AuthChangeEvent.signedIn:
            if (session?.user != null) {
              state = AsyncValue.data(session!.user);
            }
            break;
          case AuthChangeEvent.signedOut:
            state = const AsyncValue.data(null);
            break;
          default:
            break;
        }
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        state = AsyncValue.data(response.user);
        return response.user;
      } else {
        throw app_auth.AuthException(
          message: 'Login failed. Please try again.',
          code: 'login_failed',
        );
      }
    } catch (e) {
      state = AsyncValue.error(app_auth.AuthException.handleError(e), StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(
        app_auth.AuthException(
          message: 'Failed to sign out. Please try again.',
          code: 'signout_failed',
        ),
        StackTrace.current,
      );
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // First step: Sign up and request OTP
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.user != null) {
        _otpEmail = email; // Store email for OTP verification
        state = const AsyncValue.data(null); // Keep state as logged out until OTP verification
      } else {
        state = const AsyncValue.error('Signup failed', StackTrace.empty);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (_otpEmail == null) {
      throw Exception('No signup in progress');
    }

    try {
      state = const AsyncValue.loading();
      
      // Verify OTP
      final response = await _client.auth.verifyOTP(
        email: _otpEmail!,
        token: otp,
        type: OtpType.signup,
      );

      if (response.user != null) {
        // Create user record in users table
        await _client.from('users').insert({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'],
          'phone_number': response.user!.userMetadata?['phone_number'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        state = AsyncValue.data(response.user);
        _otpEmail = null; // Clear stored email
      } else {
        state = const AsyncValue.error('OTP verification failed', StackTrace.empty);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
