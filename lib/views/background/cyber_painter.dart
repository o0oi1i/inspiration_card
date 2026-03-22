import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class CyberSpacePainter extends CustomPainter {
  final Offset offset;
  final Color activeColor;
  final double progress;
  
  CyberSpacePainter({
    required this.offset, 
    required this.activeColor, 
    required this.progress
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final center = size.center(Offset.zero) + offset * 0.1;

    final nebulaPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        size.height * 0.618,
        [activeColor.withValues(alpha: 0.15), Colors.transparent],
        [0.0, 1.0],
      );
    canvas.drawRect(rect, nebulaPaint);

    final math.Random random = math.Random(888); 
    for (int i = 0; i < 100; i++) {
      final depth = random.nextDouble(); 
      final speedFactor = 0.02 + depth * 0.2; 
      final starPos = Offset(
        (random.nextDouble() * size.width + offset.dx * speedFactor) % size.width,
        (random.nextDouble() * size.height + offset.dy * speedFactor) % size.height,
      );
      final starPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.1 + depth * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(starPos, 0.4 + depth * 1.5, starPaint);
    }

    final gridPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    const gridSize = 60.0;
    for (double i = (offset.dx * 0.05) % gridSize; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = (offset.dy * 0.05) % gridSize; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}