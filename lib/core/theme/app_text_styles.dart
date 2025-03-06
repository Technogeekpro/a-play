import 'package:flutter/material.dart';

/// Class holding all text styles used in the app
class AppTextStyles {
  // Font family constants
  static const String poppins = 'Poppins';
  
  // Heading styles
  static TextStyle headingLarge({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? Colors.white,
  );
  
  static TextStyle headingMedium({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );
  
  static TextStyle headingSmall({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
    letterSpacing: 0.5,
  );
  
  // Body text styles
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.white,
  );
  
  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? Colors.white,
  );
  
  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? Colors.white,
  );
  
  // Caption styles
  static TextStyle caption({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color ?? Colors.grey[400],
  );
  
  // Label styles
  static TextStyle labelLarge({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );
  
  static TextStyle labelMedium({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.white,
  );
  
  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontFamily: poppins,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.white,
  );
}
