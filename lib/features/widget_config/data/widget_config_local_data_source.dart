import 'package:hive/hive.dart';

import '../domain/entities/widget_config.dart';
import '../domain/entities/widget_kind.dart';

class WidgetConfigLocalDataSource {
  static const String boxName = 'widget_config_box';

  Future<Box<WidgetConfig>> _openBox() => Hive.openBox<WidgetConfig>(boxName);

  Future<WidgetConfig> load(WidgetKind kind) async {
    final box = await _openBox();
    return box.get(kind.name) ?? WidgetConfig.initial();
  }

  Future<Map<WidgetKind, WidgetConfig>> loadAll() async {
    final box = await _openBox();
    return {
      for (final kind in WidgetKind.values)
        kind: box.get(kind.name) ?? WidgetConfig.initial(),
    };
  }

  Future<void> save(WidgetKind kind, WidgetConfig config) async {
    final box = await _openBox();
    await box.put(kind.name, config);
  }
}
