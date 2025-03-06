import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFFFF4707);
  static const Color primaryLight = Color(0xFFFF6B38);
  static const Color primaryDark = Color(0xFFD13500);
  
  // Background colors
  static const Color background = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFF2C2C2C);
  static const Color surface = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF808080);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Other common colors
  static Color cardBackgroundDark = Colors.grey[900]!;
  static Color divider = Colors.white.withOpacity(0.1);
  
  // Gradient color lists
  static List<Color> primaryGradient = [
    primaryLight,
    primaryColor,
    primaryDark,
  ];
  
  static List<Color> overlayGradient = [
    Colors.transparent,
    Colors.black.withOpacity(0.3),
    Colors.black.withOpacity(0.5),
  ];
}
