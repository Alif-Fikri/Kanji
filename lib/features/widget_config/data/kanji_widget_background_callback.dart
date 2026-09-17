import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/entities/widget_kind.dart';
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
  for (final kind in WidgetKind.values.where((kind) => kind.isAvailable)) {
    await updateHomeWidget(kind, await dataSource.load(kind));
  }
}
