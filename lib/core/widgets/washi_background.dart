import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/kanji_palette.dart';

class WashiBackground extends StatelessWidget {
  final Widget child;

  const WashiBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFBF4),
                    Color(KanjiPalette.kinari),
                    Color(0xFFF6EADA),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _SeigaihaPainter())),
          child,
        ],
      ),
    );
  }
}

class _SeigaihaPainter extends CustomPainter {
  static const double _radius = 46;
  static const int _rings = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(KanjiPalette.sumi).withAlpha(12);

    final stepX = _radius;
    final stepY = _radius * 0.62;
    final rows = (size.height / stepY).ceil() + 1;
    final cols = (size.width / stepX).ceil() + 2;

    for (var row = 0; row < rows; row++) {
      final offsetX = row.isEven ? 0.0 : stepX / 2;
      for (var col = -1; col < cols; col++) {
        final centre = Offset(col * stepX + offsetX, row * stepY);
        for (var ring = 1; ring <= _rings; ring++) {
          canvas.drawArc(
            Rect.fromCircle(center: centre, radius: _radius * ring / _rings),
            math.pi,
            math.pi,
            false,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SeigaihaPainter oldDelegate) => false;
}
