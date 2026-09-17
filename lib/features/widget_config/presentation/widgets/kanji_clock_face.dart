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

const String kanjiFontSampleText = '十時';

const Map<WidgetSize, String> widgetSizeLabels = {
  WidgetSize.small: 'Small',
  WidgetSize.medium: 'Medium',
  WidgetSize.large: 'Large',
};

class KanjiClockMetrics {
  static const double cornerRadius = 24;

  static Size logicalSize(WidgetSize size) => switch (size) {
        WidgetSize.small => const Size(300, 120),
        WidgetSize.medium => const Size(320, 165),
        WidgetSize.large => const Size(340, 215),
      };

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
    final size = KanjiClockMetrics.logicalSize(config.size);
    final textColor = Color(config.textColor);

    final shadows = config.showBackground
        ? null
        : [
            Shadow(
              blurRadius: 10,
              color: (textColor.computeLuminance() > 0.5
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatKanjiTime(now),
                  style: TextStyle(
                    fontFamily: kanjiFontFamilies[config.font],
                    fontSize: KanjiClockMetrics.timeFontSize(config.size),
                    height: 1.1,
                    color: textColor,
                    shadows: shadows,
                  ),
                ),
                SizedBox(height: config.size == WidgetSize.small ? 2 : 6),
                Text(
                  formatKanjiDate(now),
                  style: TextStyle(
                    fontFamily: kanjiFontFamilies[config.font],
                    fontSize: KanjiClockMetrics.dateFontSize(config.size),
                    height: 1.1,
                    color: textColor.withAlpha(210),
                    shadows: shadows,
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
