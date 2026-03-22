import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TightGlowBackground extends StatelessWidget {
  final Offset glowOffset;
  final Color glowColor;
  final double progress;
  
  const TightGlowBackground({
    super.key, 
    required this.glowOffset, 
    required this.glowColor, 
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final center = constraints.biggest.center(Offset.zero) + glowOffset;
      final radius = ui.lerpDouble(
        constraints.biggest.shortestSide * 0.618, 
        constraints.biggest.shortestSide * 0.382, 
        progress
      )!;
      return CustomPaint(
        size: Size.infinite,
        painter: GlowPainter(
          center: center, 
          color: glowColor, 
          radius: radius, 
          progress: progress
        ),
      );
    });
  }
}

class GlowPainter extends CustomPainter {
  final Offset center;
  final Color color;
  final double radius;
  final double progress;
  
  GlowPainter({
    required this.center, 
    required this.color, 
    required this.radius, 
    required this.progress
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withValues(alpha: 0.05 + progress * 0.5), 
          color.withValues(alpha: 0.05),
          Colors.transparent
        ],
        const [0.0, 0.5, 1.0],
      );
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}