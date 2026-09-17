import 'package:home_widget/home_widget.dart';

import '../domain/entities/widget_config.dart';
import '../domain/entities/widget_kind.dart';
import '../presentation/widgets/kanji_clock_face.dart';
import '../presentation/widgets/widget_face.dart';

String widgetImageKey(WidgetKind kind) => '${kind.name}_image';

Future<void> updateHomeWidget(WidgetKind kind, WidgetConfig config) async {
  final provider = kind.androidProvider;
  if (provider == null) return;

  await HomeWidget.renderFlutterWidget(
    buildWidgetFace(kind: kind, config: config, now: DateTime.now()),
    key: widgetImageKey(kind),
    logicalSize: KanjiClockMetrics.logicalSize(config.size),
    pixelRatio: 3,
  );

  await HomeWidget.updateWidget(qualifiedAndroidName: provider);
}
