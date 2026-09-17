import 'package:hive/hive.dart';

import '../domain/entities/widget_config.dart';

class WidgetConfigLocalDataSource {
  static const String boxName = 'widget_config_box';
  static const String configKey = 'config';

  Future<Box<WidgetConfig>> _openBox() => Hive.openBox<WidgetConfig>(boxName);

  Future<WidgetConfig> load() async {
    final box = await _openBox();
    return box.get(configKey) ?? WidgetConfig.initial();
  }

  Future<void> save(WidgetConfig config) async {
    final box = await _openBox();
    await box.put(configKey, config);
  }
}
