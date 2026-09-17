import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../domain/entities/widget_config.dart';
import '../domain/utils/kanji_clock.dart';
import '../presentation/pages/widget_preview_page.dart';

const String kanjiClockImageKey = 'kanji_clock_image';
const String kanjiClockAndroidProvider =
    'id.co.alchemist.kanjiwidget.KanjiClockWidgetProvider';

Future<void> updateKanjiClockWidget(WidgetConfig config) async {
  final now = DateTime.now();

  await HomeWidget.renderFlutterWidget(
    _KanjiClockWidgetImage(config: config, now: now),
    key: kanjiClockImageKey,
    logicalSize: const Size(320, 160),
  );

  await HomeWidget.updateWidget(qualifiedAndroidName: kanjiClockAndroidProvider);
}

class _KanjiClockWidgetImage extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const _KanjiClockWidgetImage({required this.config, required this.now});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(config.backgroundColor),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatKanjiTime(now),
            style: TextStyle(
              fontFamily: kanjiFontFamilies[config.font],
              fontSize: 36,
              color: Color(config.textColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatKanjiDate(now),
            style: TextStyle(
              fontFamily: kanjiFontFamilies[config.font],
              fontSize: 20,
              color: Color(config.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
