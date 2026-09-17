import 'package:hive/hive.dart';

import '../domain/entities/widget_config.dart';
import '../domain/entities/widget_kind.dart';
import '../domain/entities/widget_target.dart';

class WidgetConfigLocalDataSource {
  static const String boxName = 'widget_config_box';

  Future<Box<WidgetConfig>> _openBox() => Hive.openBox<WidgetConfig>(boxName);

  Future<WidgetConfig> load(WidgetTarget target) async {
    final box = await _openBox();
    final stored = box.get(target.storageKey);
    if (stored != null) return stored;

    if (!target.isTemplate) {
      final template = box.get(WidgetTarget(target.kind).storageKey);
      if (template != null) return template;
    }
    return WidgetConfig.initial();
  }

  Future<Map<String, WidgetConfig>> loadTemplates() async {
    final box = await _openBox();
    return {
      for (final kind in WidgetKind.values)
        WidgetTarget(kind).storageKey:
            box.get(WidgetTarget(kind).storageKey) ?? WidgetConfig.initial(),
    };
  }

  Future<void> save(WidgetTarget target, WidgetConfig config) async {
    final box = await _openBox();
    await box.put(target.storageKey, config);
  }
}
