import 'package:flutter/material.dart';

import '../../../widget_config/domain/entities/widget_config.dart';
import '../../../widget_config/presentation/widgets/kanji_clock_face.dart';
import '../../data/daily_kanji_cache.dart';

class DailyKanjiFace extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const DailyKanjiFace({super.key, required this.config, required this.now});

  @override
  Widget build(BuildContext context) {
    final entry = DailyKanjiCache.entryFor(now);
    final size = KanjiClockMetrics.logicalSize(config.size);
    final textColor = Color(config.textColor);
    final fontFamily = kanjiFontFamilies[config.font];
    final fontWeight = config.boldText ? FontWeight.w700 : FontWeight.w400;

    final shadows = config.showBackground
        ? null
        : [
            Shadow(
              blurRadius: 10,
              color:
                  (textColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white)
                      .withAlpha(160),
            ),
          ];

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KanjiClockMetrics.cornerRadius),
        child: ColoredBox(
          color: config.showBackground
              ? Color(config.backgroundColor)
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: entry == null
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor.withAlpha(140),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.kanji,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: KanjiClockMetrics.timeFontSize(config.size),
                            fontWeight: fontWeight,
                            height: 1,
                            color: textColor,
                            shadows: shadows,
                          ),
                        ),
                        SizedBox(width: config.size == WidgetSize.small ? 10 : 16),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ReadingLine(
                                label: entry.onyomi,
                                config: config,
                                textColor: textColor,
                                shadows: shadows,
                              ),
                              const SizedBox(height: 2),
                              _ReadingLine(
                                label: entry.kunyomi,
                                config: config,
                                textColor: textColor,
                                shadows: shadows,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                entry.meaning,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      KanjiClockMetrics.dateFontSize(config.size),
                                  height: 1.1,
                                  color: textColor.withAlpha(210),
                                  shadows: shadows,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadingLine extends StatelessWidget {
  final String label;
  final WidgetConfig config;
  final Color textColor;
  final List<Shadow>? shadows;

  const _ReadingLine({
    required this.label,
    required this.config,
    required this.textColor,
    required this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: kanjiFontFamilies[config.font],
        fontSize: KanjiClockMetrics.dateFontSize(config.size) * 0.86,
        height: 1.1,
        color: textColor.withAlpha(230),
        shadows: shadows,
      ),
    );
  }
}
