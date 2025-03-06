class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({required this.message, required this.code});

  @override
  String toString() => message;

  static AuthException handleError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    // Invalid credentials
    if (errorMessage.contains('invalid login credentials') ||
        errorMessage.contains('invalid credentials')) {
      return AuthException(
        message: 'Incorrect email or password. Please check and try again.',
        code: 'invalid_credentials',
      );
    }

    // User not found
    if (errorMessage.contains('user not found') ||
        errorMessage.contains('no user found')) {
      return AuthException(
        message: 'No account found with this email. Please sign up first.',
        code: 'user_not_found',
      );
    }

    // Rate limiting
    if (errorMessage.contains('too many requests') ||
        errorMessage.contains('rate limit')) {
      return AuthException(
        message: 'Too many attempts. Please wait a moment before trying again.',
        code: 'too_many_requests',
      );
    }

    // Network errors
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout')) {
      return AuthException(
        message: 'Unable to connect. Please check your internet connection.',
        code: 'network_error',
      );
    }

    // Email verification
    if (errorMessage.contains('email not confirmed') ||
        errorMessage.contains('not verified')) {
      return AuthException(
        message: 'Please verify your email before logging in.',
        code: 'email_not_verified',
      );
    }

    // Password requirements
    if (errorMessage.contains('password')) {
      if (errorMessage.contains('too short')) {
        return AuthException(
          message: 'Password must be at least 6 characters long.',
          code: 'password_too_short',
        );
      }
      if (errorMessage.contains('too weak')) {
        return AuthException(
          message: 'Password is too weak. Please include numbers and special characters.',
          code: 'password_too_weak',
        );
      }
    }

    // Email format
    if (errorMessage.contains('invalid email')) {
      return AuthException(
        message: 'Please enter a valid email address.',
        code: 'invalid_email',
      );
    }

    // Server errors
    if (errorMessage.contains('server') || errorMessage.contains('500')) {
      return AuthException(
        message: 'Server error. Please try again later.',
        code: 'server_error',
      );
    }

    // Default error
    return AuthException(
      message: 'Something went wrong. Please try again.',
      code: 'unknown_error',
    );
  }
} 