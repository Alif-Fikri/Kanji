import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  final config = await WidgetConfigLocalDataSource().load();
  await updateKanjiClockWidget(config);
}
