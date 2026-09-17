import 'package:flutter/material.dart';

import '../../../widget_config/domain/entities/widget_config.dart';
import '../../../widget_config/presentation/widgets/kanji_clock_face.dart';
import '../../data/quote_cache.dart';

class QuoteFace extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const QuoteFace({super.key, required this.config, required this.now});

  @override
  Widget build(BuildContext context) {
    final entry = QuoteCache.entryFor(now);
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.japanese,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize:
                                KanjiClockMetrics.timeFontSize(config.size) *
                                0.62,
                            fontWeight: fontWeight,
                            height: 1.25,
                            color: textColor,
                            shadows: shadows,
                          ),
                        ),
                        if (config.showTranslation) ...[
                          const SizedBox(height: 8),
                          Text(
                            entry.english,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: KanjiClockMetrics.dateFontSize(
                                config.size,
                              ),
                              height: 1.2,
                              color: textColor.withAlpha(200),
                              shadows: shadows,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
