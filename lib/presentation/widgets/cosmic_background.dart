import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:a_play/presentation/theme/app_theme.dart';

class CosmicBackground extends StatelessWidget {
  final Widget child;
  final bool withStars;
  final double blurStrength;
  final double backgroundOpacity;
  
  const CosmicBackground({
    super.key, 
    required this.child,
    this.withStars = true,
    this.blurStrength = 15.0,
    this.backgroundOpacity = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.backgroundStart,
                AppTheme.backgroundMiddle,
                AppTheme.backgroundEnd,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Stars effect
        if (withStars) 
          CustomPaint(
            painter: StarsPainter(),
            size: Size.infinite,
          ),
        
        // Blur overlay
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurStrength,
              sigmaY: blurStrength,
            ),
            child: Container(
              color: AppTheme.backgroundMiddle.withOpacity(0.3),
            ),
          ),
        ),
        
        // Subtle gradient overlay for depth
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.5),
              radius: 1.2,
              colors: [
                AppTheme.primaryPurple.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        
        // Child content
        child,
      ],
    );
  }
}

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final smallStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    final mediumStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    final largeStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
      
    final glowStarPaint = Paint()
      ..color = AppTheme.primaryPurple.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Create about 100 stars of different sizes
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble();
      
      if (starSize < 0.3) {
        // Small star
        canvas.drawCircle(Offset(x, y), 1, smallStarPaint);
      } else if (starSize < 0.8) {
        // Medium star
        canvas.drawCircle(Offset(x, y), 1.5, mediumStarPaint);
      } else {
        // Large star with glow
        canvas.drawCircle(Offset(x, y), 3, glowStarPaint);
        canvas.drawCircle(Offset(x, y), 1.5, largeStarPaint);
      }
    }
    
    // Add a few larger glowing stars
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final glowSize = 3 + random.nextDouble() * 2;
      
      final paint = Paint()
        ..color = (random.nextBool() 
          ? AppTheme.primaryPurple 
          : AppTheme.secondaryPink).withOpacity(0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      
      canvas.drawCircle(Offset(x, y), glowSize * 3, paint);
      canvas.drawCircle(Offset(x, y), glowSize, largeStarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 