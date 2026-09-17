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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFCF6),
                    Color(0xFFFDF4E6),
                    Color(0xFFF7E6D6),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _WashiPainter())),
          child,
        ],
      ),
    );
  }
}

class _WashiPainter extends CustomPainter {
  static const double _waveRadius = 52;
  static const int _waveRings = 3;

  @override
  void paint(Canvas canvas, Size size) {
    _paintAura(canvas, size);
    _paintSeigaiha(canvas, size);
    _paintEnso(canvas, size);
    _paintSunRays(canvas, size);
  }

  void _paintAura(Canvas canvas, Size size) {
    void aura(Offset centre, double radius, Color color) {
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [color, color.withAlpha(0)],
          ).createShader(Rect.fromCircle(center: centre, radius: radius)),
      );
    }

    aura(
      Offset(size.width * 0.88, size.height * 0.06),
      size.width * 0.62,
      const Color(KanjiPalette.shu).withAlpha(40),
    );
    aura(
      Offset(size.width * 0.04, size.height * 0.34),
      size.width * 0.58,
      const Color(KanjiPalette.ai).withAlpha(26),
    );
    aura(
      Offset(size.width * 0.72, size.height * 0.92),
      size.width * 0.7,
      const Color(KanjiPalette.sakura).withAlpha(34),
    );
  }

  void _paintSeigaiha(Canvas canvas, Size size) {
    final stepX = _waveRadius;
    final stepY = _waveRadius * 0.58;
    final rows = (size.height / stepY).ceil() + 1;
    final cols = (size.width / stepX).ceil() + 2;

    for (var row = 0; row < rows; row++) {
      final y = row * stepY;
      final depth = (y / size.height).clamp(0.0, 1.0);
      final alpha = (8 + depth * 16).round();
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = const Color(0xFF7A5C46).withAlpha(alpha);

      final offsetX = row.isEven ? 0.0 : stepX / 2;
      for (var col = -1; col < cols; col++) {
        final centre = Offset(col * stepX + offsetX, y);
        for (var ring = 1; ring <= _waveRings; ring++) {
          canvas.drawArc(
            Rect.fromCircle(
              center: centre,
              radius: _waveRadius * ring / _waveRings,
            ),
            math.pi,
            math.pi,
            false,
            paint,
          );
        }
      }
    }
  }

  void _paintEnso(Canvas canvas, Size size) {
    final centre = Offset(size.width * 0.84, size.height * 0.26);
    final radius = size.width * 0.3;

    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi * 0.7,
      math.pi * 1.72,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 13
        ..color = const Color(KanjiPalette.sumi).withAlpha(16),
    );
  }

  void _paintSunRays(Canvas canvas, Size size) {
    final centre = Offset(size.width * 0.12, size.height * 0.88);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(KanjiPalette.shu).withAlpha(22);

    for (var i = 0; i < 9; i++) {
      final angle = -math.pi / 2 + (i - 4) * 0.13;
      canvas.drawLine(
        centre,
        centre + Offset(math.cos(angle), math.sin(angle)) * size.height * 0.55,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WashiPainter oldDelegate) => false;
}
