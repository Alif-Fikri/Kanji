import 'package:home_widget/home_widget.dart';

import '../domain/entities/widget_config.dart';
import '../presentation/widgets/kanji_clock_face.dart';

const String kanjiClockImageKey = 'kanji_clock_image';
const String kanjiClockAndroidProvider =
    'id.co.alchemist.kanjiwidget.KanjiClockWidgetProvider';

Future<void> updateKanjiClockWidget(WidgetConfig config) async {
  final now = DateTime.now();

  await HomeWidget.renderFlutterWidget(
    KanjiClockFace(config: config, now: now),
    key: kanjiClockImageKey,
    logicalSize: KanjiClockMetrics.logicalSize(config.size),
    pixelRatio: 3,
  );

  await HomeWidget.updateWidget(qualifiedAndroidName: kanjiClockAndroidProvider);
}
