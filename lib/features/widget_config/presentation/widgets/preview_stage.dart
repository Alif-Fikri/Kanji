import 'package:flutter/material.dart';

import '../../domain/entities/widget_config.dart';
import 'kanji_clock_face.dart';

class PreviewStage extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const PreviewStage({super.key, required this.config, required this.now});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 280,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2B3A52),
              Color(0xFF14181F),
              Color(0xFF3A2630),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 18,
              left: 22,
              child: Text(
                'Home screen',
                style: TextStyle(
                  color: Colors.white.withAlpha(110),
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Center(
              child: FittedBox(
                child: KanjiClockFace(config: config, now: now),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (_) => Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(36),
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
