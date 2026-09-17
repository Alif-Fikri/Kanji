import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../daily_kanji/data/daily_kanji_cache.dart';
import '../../daily_quote/data/quote_cache.dart';
import '../domain/entities/widget_kind.dart';
import '../domain/entities/widget_target.dart';
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
  await QuoteCache.warm();

  try {
    if (uri?.host == 'resized' && await _applyResize(uri!)) {
      return;
    }
    await refreshInstalledWidgets(WidgetConfigLocalDataSource().load);
  } finally {
    await Hive.close();
  }
}

Future<bool> _applyResize(Uri uri) async {
  final params = uri.queryParameters;
  final widgetId = int.tryParse(params['widgetId'] ?? '');
  final kind = widgetKindFromName(params['kind']);
  final widthDp = double.tryParse(params['widthDp'] ?? '');
  final heightDp = double.tryParse(params['heightDp'] ?? '');
  if (widgetId == null || kind == null || widthDp == null || heightDp == null) {
    return false;
  }

  final dataSource = WidgetConfigLocalDataSource();
  final target = WidgetTarget(kind, widgetId: widgetId);
  final config = await dataSource.load(target);
  final resized = config.copyWith(
    actualWidthDp: widthDp,
    actualHeightDp: heightDp,
  );

  await dataSource.save(target, resized);
  await updateHomeWidget(target, resized);
  return true;
}
