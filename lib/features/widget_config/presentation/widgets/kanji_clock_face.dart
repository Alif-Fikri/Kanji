import 'package:flutter/material.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/utils/kanji_clock.dart';

const Map<KanjiFont, String> kanjiFontFamilies = {
  KanjiFont.notoSansJp: 'NotoSansJP',
  KanjiFont.kosugi: 'Kosugi',
  KanjiFont.kosugiMaru: 'KosugiMaru',
  KanjiFont.shipporiMincho: 'ShipporiMincho',
};

const Map<KanjiFont, String> kanjiFontLabels = {
  KanjiFont.notoSansJp: 'Noto Sans JP',
  KanjiFont.kosugi: 'Kosugi',
  KanjiFont.kosugiMaru: 'Kosugi Maru',
  KanjiFont.shipporiMincho: 'Shippori Mincho',
};

const Map<WidgetSize, String> widgetSizeLabels = {
  WidgetSize.small: 'Small',
  WidgetSize.medium: 'Medium',
  WidgetSize.large: 'Large',
};

const String kanjiFontSampleText = '十時';

class KanjiClockMetrics {
  static const double cornerRadius = 24;

  static Size logicalSize(WidgetSize size) => switch (size) {
    WidgetSize.small => const Size(300, 120),
    WidgetSize.medium => const Size(320, 165),
    WidgetSize.large => const Size(340, 215),
  };

  static Size effectiveSize(WidgetConfig config) {
    final w = config.actualWidthDp;
    final h = config.actualHeightDp;
    if (w == null || h == null) return logicalSize(config.size);
    return Size(w, h);
  }

  static double timeFontSize(WidgetSize size) => switch (size) {
    WidgetSize.small => 30,
    WidgetSize.medium => 38,
    WidgetSize.large => 48,
  };

  static double dateFontSize(WidgetSize size) => switch (size) {
    WidgetSize.small => 15,
    WidgetSize.medium => 19,
    WidgetSize.large => 24,
  };
}

class KanjiClockFace extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const KanjiClockFace({super.key, required this.config, required this.now});

  @override
  Widget build(BuildContext context) {
    final size = KanjiClockMetrics.effectiveSize(config);
    final textColor = Color(config.textColor);

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

    final fontFamily = kanjiFontFamilies[config.font];
    final fontWeight = config.boldText ? FontWeight.w700 : FontWeight.w400;

    final timeText = formatKanjiTime(
      now,
      style: config.numeralStyle,
      use24HourFormat: config.use24HourFormat,
      showSeconds: config.showSeconds,
    );

    var timeFontSize = KanjiClockMetrics.timeFontSize(config.size);
    if (config.showSeconds) timeFontSize *= 0.82;
    if (!config.use24HourFormat) timeFontSize *= 0.88;

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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeText,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: timeFontSize,
                        fontWeight: fontWeight,
                        height: 1.1,
                        color: textColor,
                        shadows: shadows,
                      ),
                    ),
                    if (config.showDate) ...[
                      SizedBox(
                        height: config.size == WidgetSize.small ? 2 : 6,
                      ),
                      Text(
                        formatKanjiDate(
                          now,
                          style: config.numeralStyle,
                          showWeekday: config.showWeekday,
                        ),
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: KanjiClockMetrics.dateFontSize(config.size),
                          fontWeight: fontWeight,
                          height: 1.1,
                          color: textColor.withAlpha(210),
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
      ),
    );
  }
}
