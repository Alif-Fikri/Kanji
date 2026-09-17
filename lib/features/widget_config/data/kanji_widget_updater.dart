import 'package:home_widget/home_widget.dart';

import '../domain/entities/widget_config.dart';
import '../domain/entities/widget_kind.dart';
import '../domain/entities/widget_target.dart';
import '../presentation/widgets/kanji_clock_face.dart';
import '../presentation/widgets/widget_face.dart';

Future<void> updateHomeWidget(WidgetTarget target, WidgetConfig config) async {
  await HomeWidget.renderFlutterWidget(
    buildWidgetFace(kind: target.kind, config: config, now: DateTime.now()),
    key: target.imageKey,
    logicalSize: KanjiClockMetrics.logicalSize(config.size),
    pixelRatio: 3,
  );

  await HomeWidget.updateWidget(qualifiedAndroidName: target.kind.androidProvider);
}

Future<void> refreshInstalledWidgets(
  Future<WidgetConfig> Function(WidgetTarget target) configLoader,
) async {
  final installed = await HomeWidget.getInstalledWidgets();

  for (final info in installed) {
    final widgetId = info.androidWidgetId;
    if (widgetId == null) continue;

    final kind = WidgetKind.values.firstWhere(
      (candidate) => candidate.matchesAndroidClass(info.androidClassName),
      orElse: () => WidgetKind.clock,
    );
    final target = WidgetTarget(kind, widgetId: widgetId);
    await updateHomeWidget(target, await configLoader(target));
  }
}
