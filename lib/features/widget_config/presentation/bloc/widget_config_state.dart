import 'package:equatable/equatable.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_target.dart';

class WidgetConfigState extends Equatable {
  final Map<String, WidgetConfig> configs;

  const WidgetConfigState({required this.configs});

  factory WidgetConfigState.initial() => const WidgetConfigState(configs: {});

  WidgetConfig configFor(WidgetTarget target) =>
      configs[target.storageKey] ?? WidgetConfig.initial();

  WidgetConfigState withConfig(WidgetTarget target, WidgetConfig config) {
    return WidgetConfigState(
      configs: {...configs, target.storageKey: config},
    );
  }

  @override
  List<Object?> get props => [configs];
}
