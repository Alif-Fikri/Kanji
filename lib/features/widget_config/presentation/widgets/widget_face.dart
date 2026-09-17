import 'package:flutter/material.dart';

import '../../../daily_kanji/presentation/widgets/daily_kanji_face.dart';
import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';
import 'kanji_clock_face.dart';

Widget buildWidgetFace({
  required WidgetKind kind,
  required WidgetConfig config,
  required DateTime now,
}) {
  return switch (kind) {
    WidgetKind.clock => KanjiClockFace(config: config, now: now),
    WidgetKind.dailyKanji => DailyKanjiFace(config: config, now: now),
    _ => ComingSoonFace(kind: kind, config: config),
  };
}

class ComingSoonFace extends StatelessWidget {
  final WidgetKind kind;
  final WidgetConfig config;

  const ComingSoonFace({super.key, required this.kind, required this.config});

  @override
  Widget build(BuildContext context) {
    final size = KanjiClockMetrics.logicalSize(config.size);
    final textColor = Color(config.textColor);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KanjiClockMetrics.cornerRadius),
        child: ColoredBox(
          color: config.showBackground
              ? Color(config.backgroundColor)
              : Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty, size: 26, color: textColor.withAlpha(140)),
                const SizedBox(height: 10),
                Text(
                  kind.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor.withAlpha(190),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Coming soon',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: textColor.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
