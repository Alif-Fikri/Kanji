import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../daily_kanji/data/daily_kanji_cache.dart';
import 'kanji_widget_hive_bootstrap.dart';
import 'kanji_widget_updater.dart';
import 'widget_config_local_data_source.dart';

@pragma('vm:entry-point')
Future<void> kanjiClockBackgroundCallback(Uri? uri) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(widgetConfigTypeId)) {
    registerWidgetConfigHiveAdapters();
  }
  await DailyKanjiCache.warm();

  try {
    await refreshInstalledWidgets(WidgetConfigLocalDataSource().load);
  } finally {
    await Hive.close();
  }
}
