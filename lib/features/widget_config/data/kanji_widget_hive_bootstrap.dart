import 'package:hive/hive.dart';

import 'widget_config_hive_adapters.dart';

export 'widget_config_hive_adapters.dart' show widgetConfigTypeId;

void registerWidgetConfigHiveAdapters() {
  Hive.registerAdapter(KanjiFontAdapter());
  Hive.registerAdapter(WidgetSizeAdapter());
  Hive.registerAdapter(NumeralStyleAdapter());
  Hive.registerAdapter(WidgetConfigAdapter());
}
