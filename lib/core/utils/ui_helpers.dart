import 'package:flutter/material.dart';

/// UI helper class to simplify common UI operations and improve code reusability
class UIHelpers {
  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context, {double multiplier = 1.0}) {
    final width = getScreenWidth(context);
    final basePadding = width * 0.04 * multiplier;
    return EdgeInsets.symmetric(horizontal: basePadding);
  }
  
  /// Get safe area dimensions
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  /// Get the device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }
  
  /// Check if the device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
  
  /// Add gradient overlay to widgets
  static Widget addGradientOverlay({
    required Widget child,
    List<Color>? colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    BorderRadius? borderRadius,
  }) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: colors ?? [
                  Colors.transparent,
                  Colors.black.withAlpha(77),
                  Colors.black.withAlpha(128),
                ],
                stops: stops ?? const [0.7, 0.85, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
