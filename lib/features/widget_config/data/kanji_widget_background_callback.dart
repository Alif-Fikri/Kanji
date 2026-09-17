import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/entities/widget_kind.dart';
import '../domain/entities/widget_target.dart';
import 'kanji_widget_hive_bootstrap.dart';
import 'kanji_widget_updater.dart';
import 'widget_config_local_data_source.dart';

@pragma('vm:entry-point')
Future<void> kanjiClockBackgroundCallback(Uri? uri) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(widgetConfigTypeId)) {
    await Hive.initFlutter();
    registerWidgetConfigHiveAdapters();
  }

  final dataSource = WidgetConfigLocalDataSource();

  if (uri?.host == 'deleted') {
    final ids = uri?.queryParameters['widgetIds']?.split(',') ?? const [];
    for (final rawId in ids) {
      final widgetId = int.tryParse(rawId.trim());
      if (widgetId == null) continue;
      await dataSource.remove(
        WidgetTarget(WidgetKind.clock, widgetId: widgetId),
      );
    }
    return;
  }

  await refreshInstalledWidgets(dataSource.load);
}
