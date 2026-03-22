import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class GlassCard extends StatelessWidget {
  final String name; 
  final List<Color> colors;
  final double width;
  final double height;
  final bool isTop;

  const GlassCard({
    super.key,
    required this.name, 
    required this.colors, 
    required this.width, 
    required this.height, 
    required this.isTop
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), 
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0), // 关闭模糊效果
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors[0].withValues(alpha: 0.618), colors[1].withValues(alpha: 1)],
              ),
            ),
            child: Center(
              child: Text(
                name, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32, 
                  fontWeight: isTop ? FontWeight.bold : FontWeight.w200, 
                  fontStyle: FontStyle.italic,
                  letterSpacing: 7,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}